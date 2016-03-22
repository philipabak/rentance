$(document).ready ->
  initFlashFadeout()

$(document).on 'hidden.bs.modal', '#myModal', (e) ->
  initFlashFadeout()

@initFlashFadeout = ->
  $('#flash .alert').delay(3000).fadeOut()
