$(document).ready ->
  if $(document).find('#listing-list').length > 0
    window.ListingList = new ListingList()

class ListingList
  constructor: ->
    @list         = $(document).find('#listing-list')
    @url          = @list.data('url')
    @autocompleteMapping =
      street_number:                ['short_name', 'house_number']
      route:                        ['long_name', 'street_name']
      locality:                     ['long_name', 'city']
      postal_code:                  ['short_name', 'postal_code']
      administrative_area_level_1:  ['short_name', 'province']
      country:                      ['short_name', 'country']

    @headTemplate   = Handlebars.compile $(document).find('.js-template-head').text()
    @pageTemplate   = Handlebars.compile $(document).find('.js-template-page').text()
    @emptyTemplate  = Handlebars.compile $(document).find('.js-template-empty').text()

  clear: =>
    @list.empty()

  update: (place) =>
    @list.empty()

    @listingsShown = 0
    @page = 0

    @params = {}

    i = 0
    while i < place.address_components.length
      addressType = place.address_components[i].types[0]
      if @autocompleteMapping[addressType]
        name = @autocompleteMapping[addressType][1]
        val = place.address_components[i][@autocompleteMapping[addressType][0]]
        @params[name] = val
      i++

    @appendPage()

  appendPage: =>
    @list.append(
      $ '<div>',
        class: 'loading-spinner'
    )

    $.ajax
      dataType: 'json'
      url:      @url
      data:
        $.extend {
          page: @page
        }, @params

      error: (xhr, status, error) ->
        console.log error

      success: (data, status, xhr) =>
        @showPage(data)

  showPage: (data) =>
    @list.find('.loading-spinner').remove()

    if @page == 0
      if data.total_count > 0
        head = @headTemplate data
        $head = $(head)

        $head.find('.selectpicker').selectpicker width: '100%'

        @list.append $head
      else
        empty = @emptyTemplate data
        @list.append empty

    if data.total_count > 0
      page = @pageTemplate data
      $page = $(page)

      $page.find('.slider').bxSlider pager: false
      $page.find('.app-star').on 'click', (e) ->
        $(this).toggleClass 'active'
        return

      @list.append $page

    @listingsShown += data.listings.length

    if data.total_count > @listingsShown
      @page += 1
      @list.append(
        $ '<div>',
          class: 'load-more'
      )
