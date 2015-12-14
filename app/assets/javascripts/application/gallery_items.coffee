$ ->
  $('.item').popover({
    trigger: 'hover',
#    placement: 'right',
    html: true,
  });

  if ('ontouchstart' in window)
    $('[data-toggle="popover"]').popover({
      'trigger': 'manual'
    });

  $('body').on 'click', '.img_clc', ->
    url = $(@).data('url')
    $parent = $(@).closest('.item')

    if (url)
      header = $parent.find('h1').text()
      description = $parent.data('content')

      modal_window.show(
        modal_window.template(
          false,
          header,
          "<div class='text-center'><img style='height: auto; max-width: 100%;' src='#{url}'/></div><div>#{description}</div>",
          modal_window.close_button()
        )
      )
