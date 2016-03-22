$(document).ready ->
  sortableList = $('ul.listingphoto-collection')
  sortUrl = sortableList.data('sort_url') || sortableList.data('sort-url')

  sortableList.sortable
    handle: 'img'
    scroll: true

  sortableList.on 'sortupdate', (event, ui) =>
    $.ajax
      type:     'post'
      dataType: 'script'
      url:      sortUrl
      data:     sortableList.sortable('serialize')

      error: (xhr, status, error) ->
        console.log error
