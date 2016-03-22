$(document).ready ->
  initSummernote()

$(document).on 'shown.bs.modal', '#myModal', (e) ->
  initSummernote(e.target)

@initSummernote = (target) ->
  if $.fn.summernote
    target = target or document
    summernote = $(target).find('.summernote')
    if summernote
      summernote.summernote
        toolbar: [
          ['table', ['table']],
          ['style', ['style']],
          ['fontsize', ['fontsize']],
          ['color', ['color']],
          ['style', ['bold', 'italic', 'underline', 'clear']],
          ['para', ['ul', 'ol', 'paragraph']],
          ['height', ['height']],
        ]

      # to set code for summernote
      summernote.code summernote.val()

      # to get code for summernote
      summernote.closest('form').submit ->
        summernote.val summernote.code()
        true
