$(document).ready ->
  initSelectize()

$(document).on 'shown.bs.modal', '#myModal', (e) ->
  initSelectize(e.target)

@initSelectize = (target) ->
  if $.fn.selectize
    target = target or document
    $(target).find('.ui-selectize').selectize plugins: ['remove_button']
