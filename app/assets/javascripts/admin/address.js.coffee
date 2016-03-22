$(document).on 'change', '#address_country', (e) ->
  $this = $(this)
  provincesUrl = '/address/provinces.json?country=' + $('#address_country').val()

  $.getJSON provincesUrl, (data) ->
    $label  = $this.closest('form').find('#province_label')
    $el     = $this.closest('form').find('#address_province')

    if data.length is 0
      $label.text('State / Province')
      $el.replaceWith('<input name="' + $el.prop('name') + '" id="address_province" class="form-control" type="text">')
    else
      $label.text(data[0].type.charAt(0).toUpperCase() + data[0].type.slice(1))
      $el.replaceWith('<select name="' + $el.prop('name') + '" id="address_province" class="form-control">')
      $el = $('#address_province')
      $el.html('<option value="">Please select a ' + data[0].type + '</option>')
      $.each data, (i, province) ->
        $el.append $('<option></option>').attr('value', province.code).text(province.name)
