$(document).ready ->
  initMap()

$(document).on 'shown.bs.modal', '#myModal', (e) ->
  initMap(e.target)

@initMap = (target) ->
  target = target or document
  if $(target).find('#map').length > 0
    window.GoogleMap = new GoogleMap(target)

class GoogleMap
  constructor: (target) ->
    map = $(target).find('#map')
    geolocationLatitude  = $(target).find('#geolocation_latitude')
    geolocationLongitude = $(target).find('#geolocation_longitude')

    lat = geolocationLatitude.val() || 38.8833
    lng = geolocationLongitude.val() || -97.0167

    latLng = new google.maps.LatLng(lat, lng)
    zoom = (if geolocationLatitude.val() then 14 else 3)

    @map = new google.maps.Map(
      map[0]
      mapTypeId: google.maps.MapTypeId.ROADMAP
      center: latLng
      zoom: zoom
    )
    @icon  = map.data('marker-icon') || map.data('marker_icon')

    if geolocationLatitude.length > 0
      draggable = map.closest('form').length > 0
      @marker = new google.maps.Marker(
        position:   latLng
        map:        @map
        icon:       @icon
        draggable:  draggable
      )
      @geocoder = new google.maps.Geocoder()

      @findAddress()  unless geolocationLatitude.val()

      if draggable
        google.maps.event.addListener @marker, 'dragend', =>
          latLng = @marker.getPosition()
          @map.panTo latLng
          @updateCoordinates latLng

        $(document).on 'change', '#address_house_number, #address_street_name, #address_line_2, #address_city, #address_postal_code, #address_province, #address_country', (e) =>
          @findAddress()

    else
      @markers = []
      @infowindows = []

      url = map.data('url')
      $.getJSON url, (data) =>
        @drawMarkers(data)
        @fitMapToMarkers()

      google.maps.event.addListener @map, 'click', =>
        @closeInfowindows()

  findAddress: =>
    address = []
    house = $('#address_house_number').val()
    address.push(house)  if house

    street = $('#address_street_name').val()
    address.push(street)  if street

    line2 = $('#address_line_2').val()
    address.push(line2)  if line2

    city = $('#address_city').val()
    address.push(city)  if city

    postalCode = $('#address_postal_code').val()
    address.push(postalCode)  if postalCode

    province = $('#address_province').val()
    address.push(province)  if province

    country = $('#address_country option:selected').text()
    address.push(country)  if country

    @geocoder.geocode
      address: address.join(', ')
      partialmatch: true
    , @geocodeResult

  geocodeResult: (results, status) =>
    if status is google.maps.GeocoderStatus.OK
      @map.fitBounds results[0].geometry.viewport
      @marker.setPosition results[0].geometry.location
      @updateCoordinates results[0].geometry.location
    else
      console.log 'Geocode failed due to: ' + status

  updateCoordinates: (latLng) =>
    $('#geolocation_latitude').val(latLng.lat())
    $('#geolocation_longitude').val(latLng.lng())

  drawMarkers: (list) =>
    oldMarkersIdx = []
    newMarkers = []
    newInfowindows = []

    $.each list, (j, point) =>
      latLng = new google.maps.LatLng(point.latitude, point.longitude)

      i = 0
      while i < @markers.length
        if @markers[i].getPosition().equals(latLng) and @markers[i].getTitle() is point.title
          oldMarkersIdx.push i
          break
        i++
      if i is @markers.length
        marker = new google.maps.Marker(
          position: latLng
          map:      @map
          icon:     @icon
          title:    point.title
        )
        newMarkers.push marker

        infowindow = new google.maps.InfoWindow(
          content:  point.html
          maxWidth: 300
        )
        google.maps.event.addListener marker, 'click', =>
          @closeInfowindows()
          infowindow.open @map, marker

        newInfowindows.push infowindow

    i = 0
    while i < @markers.length
      if oldMarkersIdx.indexOf(i) isnt -1
        newMarkers.push @markers[i]
        newInfowindows.push @infowindows[i]
      else
        @markers[i].setMap null
      i++

    @markers = newMarkers
    @infowindows = newInfowindows

  fitMapToMarkers: =>
    if @markers.length > 0
      latLngBounds = new google.maps.LatLngBounds()
      $.each @markers, (i, marker) =>
        latLngBounds.extend marker.getPosition()
      @map.fitBounds latLngBounds
      @map.setZoom(16) if @map.getZoom() > 16

  closeInfowindows: =>
    i = 0
    while i < @infowindows.length
      @infowindows[i].close()
      i++
