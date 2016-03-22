$(document).ready ->
  if $(document).find('#autocomplete').length > 0
    window.Autocomplete = new Autocomplete()

class Autocomplete
  constructor: ->
    input = $(document).find('#autocomplete')
    @autocomplete = new google.maps.places.Autocomplete(
        input[0]
        types: [ 'geocode' ]
    )

    @autocomplete.addListener 'place_changed', =>
      place = @autocomplete.getPlace()
      window.GoogleMap.updateToNewPlace(place)  if window.GoogleMap
      window.ListingList.update(place)  if window.ListingList
