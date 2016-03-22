$(document).ready ->
  $('#new_listing_photo').fileupload
    dataType: 'script'
    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        data.context = $(tmpl('template-upload', file))
        $('#new_listing_photo').parent().find('.listingphoto-collection').append(data.context)
        data.submit()
      else
        alert("#{file.name} is not a gif, jpeg, or png image file")

    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 360, 10)
        if progress < 180
          progress += 90
          data.context.find('.uploading').css('background-image', 'linear-gradient(' + progress + 'deg, transparent 50%, white 50%), linear-gradient(90deg, white 50%, transparent 50%)')
        else if progress == 180
          data.context.find('.uploading').css('background-image', 'linear-gradient(90deg, white 50%, transparent 50%)')
        else if progress > 180 && progress < 360
          progress -= 90
          data.context.find('.uploading').css('background-image', 'linear-gradient(' + progress + 'deg, transparent 50%, #5bc0de 50%), linear-gradient(90deg, white 50%, transparent 50%)')
        else
          data.context.find('.uploading').css('background-image', 'none')

    done: (e, data) ->
      data.context.fadeOut()

    fail: (e, data) ->
      data.context.delay(2000).fadeOut().children().css('background-color', 'red')
      $('<div class=\"alert alert-dismissable alert-danger\"><button aria-hidden=\"true\" class=\"close\" data-dismiss=\"alert\" type=\"button\">&times;<\/button>' + 'File uploading has failed: ' + data.errorThrown + '<\/div>').appendTo('#flash').hide().fadeIn().delay(3000).fadeOut()
