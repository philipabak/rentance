$(document).ready ->
  initGeolocation()

@initGeolocation = () ->
  if $(document).find('#map-canvas').length > 0 and $(document).find('#geolocation').length > 0
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(geoSuccess, geoError)
    else
      geoError('Geolocation is not supported')

@geoSuccess = (position) ->
  return if $('#geolocation').hasClass('success')
  $('#geolocation').addClass('success')
  showAlertMessage('You are located', 'success')

  if window.GoogleMap
    latLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    window.GoogleMap.map.panTo latLng
    window.GoogleMap.map.setZoom 12

@geoError = (msg) ->
  $('#geolocation').addClass 'error'
  showAlertMessage((if typeof msg is 'string' then msg else 'Geolocation is disabled'), 'danger')

@showAlertMessage = (msg, type) ->
  $('<div class=\"alert alert-dismissable alert-' + type + '\"><button aria-hidden=\"true\" class=\"close\" data-dismiss=\"alert\" type=\"button\">&times;<\/button>' + msg + '<\/div>').appendTo('#flash').hide().fadeIn().delay(3000).fadeOut()
