$(document).ready ->
  if $(document).find('#map-canvas').length > 0
    window.GoogleMap = new GoogleMap()

class GoogleMap
  constructor: ->
    map     = $(document).find('#map-canvas')
    lat     = map.data('lat') || 38.8833
    lng     = map.data('lng') || -97.0167
    latLng  = new google.maps.LatLng(lat, lng)
    zoom    = if map.data('lat') then 12 else 4
    styles  = [
      {
        stylers: [
          {
            saturation: -10
          }
        ]
      }
      {
        featureType: 'road'
        elementType: 'labels'
        stylers: [
          {
            lightness: 30
          }
          {
            saturation: -30
          }
        ]
      }
    ]
    @map = new google.maps.Map(
      map[0]
      mapTypeId:  google.maps.MapTypeId.ROADMAP
      center:     latLng
      zoom:       zoom
      styles:     styles
    )
    @geocoder = new (google.maps.Geocoder)

    @markers      = []
    @url          = map.data('url')
    @main         = $(document).find('#main')

    unless @url
      @createMarker {
        listings_count: 1
        title: ''
        cluster: ''
      }, latLng

    google.maps.event.addListener @map, 'idle', =>
      @updateMarkers() if @url

    google.maps.event.addListener @map, 'click', =>
      # @closeMarkers()

  updateToNewAddress: (address) =>
    @geocoder.geocode
      address: address
      partialmatch: true
    , (results, status) =>
      if status == google.maps.GeocoderStatus.OK
        if results[0].geometry.viewport
          @map.fitBounds results[0].geometry.viewport
        else
          @map.setCenter results[0].geometry.location
        @map.setZoom 12 if @map.getZoom() > 12

      else
        console.log 'Geocode was not successful for the following reason: ' + status
      return

  updateToNewPlace: (place) =>
    if place.geometry
      if place.geometry.viewport
        @map.fitBounds place.geometry.viewport
      else
        @map.setCenter place.geometry.location
        @map.setZoom 17
    else
      console.log 'Autocomplete\'s returned place contains no geometry'
      return

  updateMarkers: =>
    bounds = @map.getBounds()
    nePoint = bounds.getNorthEast()
    swPoint = bounds.getSouthWest()

    $.ajax
      dataType: 'json'
      url:      @url
      data:
        $.extend {
          bounds_lat:   [swPoint.lat(), nePoint.lat()]
          bounds_lng:   [swPoint.lng(), nePoint.lng()]
          zoom:         @map.getZoom()
          age:          @main.find('.age-box .selected').data('age')
        }, {}

      error: (xhr, status, error) ->
        console.log error

      success: (data, status, xhr) =>
        @showMarkers(data)

  showMarkers: (data) =>
    oldMarkersIdx = []
    newMarkers = []

    $.each data, (j, point) =>
      latLng = new google.maps.LatLng(point.latitude, point.longitude)

      i = 0
      while i < @markers.length
        if @markers[i].getPosition().equals(latLng) and @markers[i].title is point.title
          oldMarkersIdx.push i
          break
        i++
      if i is @markers.length
        marker = @createMarker(point, latLng)
        newMarkers.push marker

        google.maps.event.addListener marker, 'click', =>
          @map.panTo marker.position
          @closeMarkers()
          @openMarker marker

    i = 0
    while i < @markers.length
      if oldMarkersIdx.indexOf(i) isnt -1
        newMarkers.push @markers[i]
      else
        @markers[i].setMap null
      i++

    @markers = newMarkers

  createMarker: (point, latLng) =>
    style = 'zero'
    if point.listings_count >= 5000
      style = 'large'
    else if point.listings_count >= 500
      style = 'medium'
    else if point.listings_count >= 50
      style = 'small'
    else if point.listings_count >= 2
      style = 'tiny'

    marker = new RichMarker(
      position:       latLng
      map:            @map
      flat:           true
      dragganle:      false
      anchor:         RichMarkerPosition.MIDDLE
      content:        '<div class="map-circle ' + style + '" title="' + point.title + '">' + point.listings_count + '</div>'
      title:          point.title
      cluster:        point.cluster
      listings_count: point.listings_count
    )
    return marker

  closeMarkers: =>
    i = 0
    while i < @markers.length
      content = @markers[i].getContent()
      if content.indexOf(' active') isnt -1
        @markers[i].setContent content.replace(' active', '')
      i++

  openMarker: (marker) =>
    content = marker.getContent()
    if content.indexOf(' active') is -1
      marker.setContent content.replace(/(map-circle)/, '$1 active')

    # window.ListingList.update(marker.cluster)  if window.ListingList
