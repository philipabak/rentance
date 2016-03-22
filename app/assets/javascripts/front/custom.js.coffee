$(document).ready ->
  new FastClick(document.body)

  # Search filters
  $('.selectpicker').selectpicker width: '100%'

  $('#range').ionRangeSlider
    min: 0
    max: 10000
    type: 'double'
    prefix: '$'

  # Search page slide panel
  $('.toggle-slide').click ->
    $(this).toggleClass 'active'
    $('.sliding-panel').toggleClass 'active'

  # Details page
  $('.details-slider').bxSlider pager: false

  width = $(window).width()
  if width >= 768
    $('#details-sidebar').fixTo '.details-tab-content',
      useNativeSticky: false
      top: 90
      zIndex: 1000
  else
    $('#details-sidebar').fixTo 'destroy'

  $('.details-wishlist').click ->
    $(this).toggleClass 'active'

  # YouTube autoplay
  $('[data-toggle="modal"]').click ->
    theModal = $(this).data('target')
    videoSRC = $(this).attr('data-theVideo')
    videoSRCauto = videoSRC + '?autoplay=1'
    $(theModal + ' iframe').attr 'src', videoSRCauto
    $(theModal + ' button.close').click ->
      $(theModal + ' iframe').attr 'src', videoSRC
    $('.modal').click ->
      $(theModal + ' iframe').attr 'src', videoSRC


$(window).bind 'load resize', ->
  width = $(window).width()
  if width >= 768
    $('.sliding-panel-inner').mCustomScrollbar
      theme: 'minimal-dark'
      scrollInertia: 0
      callbacks: onTotalScroll: ->
        if $(this).find('.load-more').length > 0
          $(this).find('.load-more').remove()
          if window.ListingList
            window.ListingList.appendPage()
        return
    $('#search-filters').insertBefore('.search-results').removeClass('collapse').css('height', 'auto')
  else
    $('.sliding-panel-inner').mCustomScrollbar 'destroy'
    $('#search-filters').insertAfter('#navbar-collapse').addClass('collapse')
    $('#filters').collapse 'show'
    $('.search-filter-inner').show().delay 500
