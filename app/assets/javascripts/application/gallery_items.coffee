$ ->
  $('.item').popover({
    trigger: 'hover',
#    placement: 'right',
    html: true,
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
          "<div class='text-center'><img src='#{url}'/></div><div>#{description}</div>"
        )
      )
