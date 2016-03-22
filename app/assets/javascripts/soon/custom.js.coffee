$(document).ready ->
  $('#countdown').countdown
    date: '18 October 2015 18:00:00'
    format: 'on'

  $('.tooltips').tooltip
    selector: '[data-toggle=tooltip]'
    container: 'body'
  return
