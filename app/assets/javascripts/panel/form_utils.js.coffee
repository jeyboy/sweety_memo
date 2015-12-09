window.show_spinner = ($elem) ->
  $elem.addClass('active')

  if ($elem.find('.spinner').length == 0)
    $elem.append("<span class='spinner fa fa-spin fa-refresh' aria-hidden='true'></span>")

window.hide_spinner =  ->
  $('.has-spinner').removeClass('active')


#window.send_request: (url, method, data, succ_func, complete_func, decl_func) ->
#  $.ajax
#    url: url
#    method: method
#    data: data
#    success: (response) ->
#      modal_window.proceed_state_off()
#      if (response.status)
#        succ_func(response)
#      else
#        output_errors(response.errors)
#        if (decl_func) then decl_func(response)
#    complete: (e, xhr, settings) ->
#      if (complete_func)
#        complete_func(e, xhr, settings)
#
#      if (e.status == 401)
#        location.reload()
#
#
#window.output_errors: (errors) ->
#  $list = $("<ul class='text-danger'></ul>")
#
#  for k,v of errors
#    for err in v
#      $list.append($("<li>#{k}: #{err}</li>"))
#
#  if (modal_window.opened)
#    modal_window.inject_data_to_body($list, '.errors')
#  else
#    alert($list)

$ ->
  $('body').on 'submit', '.blockable', ->
    $submit = $(':submit', @)
    $submit.prop('disabled', true)
    show_spinner($submit)