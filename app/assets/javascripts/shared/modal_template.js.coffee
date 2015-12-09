jQuery.fn.extend reconnect: (act, selector, func) ->
  $(@)
    .off act, selector
    .on act, selector, func

  return @


window.modal_window =
  modal_block_name: 'modal_block'

  modal_proceeding_selector: 'modal-proc'

  modal_content_selector: 'modal-content'
  modal_dialog_selector: 'modal-dialog'
  modal_header_selector: 'modal-header'
  modal_body_selector: 'modal-body'
  modal_footer_selector: 'modal-footer'

  opened: false
  on_close: undefined
  blockable: false
  action_registered: false

  default_title: 'Loading'
  default_body: '<div style="width: 100%; display: table; text-align: center;">' +
    '<div style="display: table-cell; text-align: center; vertical-align: middle; height: 40vh;">' +
    '<div class="hexdots-loader">Loading…</div>' +
    '</div></div>'


  update_width: ->
    $tables = $('.table', "##{modal_window.modal_block_name}")

    if ($tables.length > 0)
      min_width = 660

      $.each($tables, ->
        el_width = Number($(@).css('width').slice(0, -2))
        if el_width > min_width then min_width = el_width
      )

      if (min_width != 660)
        $container_elem = $(".#{modal_window.modal_dialog_selector}", "##{modal_window.modal_block_name}")
        $body_elem = $(".#{modal_window.modal_body_selector}", "##{modal_window.modal_block_name}")
        min_width += Number($body_elem.css('padding-right').slice(0, -2)) + Number($body_elem.css('padding-left').slice(0, -2))
        $container_elem.css('width', min_width + 'px')



  register_actions: ->
    modal_window.action_registered = true

    $('body')
      .on 'click', '.mdl_prcd_btn', ->
        modal_window.proceed_state_on()

      .on 'hidden.bs.modal', '.modal', ->
        modal_window.opened = false
        if (modal_window.on_close)
          modal_window.on_close()

      .on 'show.bs.modal', '.modal', ->
        modal_window.opened = true

      .on 'shown.bs.modal', '.modal', ->
        modal_window.update_width()


  proceed_button: (text = undefined, classes = '', id = '', tag = 'a') ->
    "<#{tag} class='mdl_prcd_btn close #{classes}' id='#{id}' >#{text || "Proceed"}</#{tag}>"

  close_button: (text = undefined, classes = '', id = '', tag = 'a') ->
    "<#{tag} class='close #{classes}' id='#{id}' data-dismiss='modal' aria-hidden='true'>#{text || "×"}</#{tag}>"





  build_header: (data) ->
    $header = $("<div class='#{modal_window.modal_header_selector}'></div>")
    $header
    .append(modal_window.close_button(undefined, 'close'))
    .append("<div class='head_content'>#{data}</div>")

  build_pdf_data: (pdf_path) ->
    obj = "<object data=\"{FileName}\" type=\"application/pdf\" width=\"100%\" height=\"400px\">";
    obj += "If you are unable to view file, you can download from <a href = \"{FileName}\">here</a>";
    obj += " or download <a target = \"_blank\" href = \"http://get.adobe.com/reader/\">Adobe PDF Reader</a> to view the file.";
    obj += "</object>";
    obj = obj.replace(/\{FileName\}/g, pdf_path);
    obj

  build_body: (data) ->
    $("<div class='#{modal_window.modal_body_selector}'>#{data}</div>")

  build_footer: (data) ->
    $("<div class='#{modal_window.modal_footer_selector}'>#{data || '&nbsp;'}</div>")

  template: (full_screen = false, header = modal_window.default_title, body = modal_window.default_body, footer, id)->
    cont = "<div class='modal fade #{if (full_screen) then "full_screen"}' id='#{id || modal_window.modal_block_name}' role='dialog'>"
    unless (full_screen)
      cont += "<div class='#{modal_window.modal_dialog_selector}'><div class='#{modal_window.modal_content_selector}'>"

    $base = $(cont)
    $cont = if full_screen then $base else $base.find(".#{modal_window.modal_content_selector}")

    $cont
      .append(modal_window.build_header(header))
      .append(modal_window.build_body(body))

    if footer
      $cont.append(modal_window.build_footer(footer))

    return $base




  show_prev: (container_selector) ->
    modal_window.show($(container_selector || "##{modal_window.modal_block_name}"))

  show: (template, container_selector) ->
    modal_window.hide()
    $block = $(container_selector || "##{modal_window.modal_block_name}")

    if $block.length == 0
      $('body').append($block = $(template))
    else

      $block.replaceWith($new_block = $(template))
      $block = $new_block

    if (!modal_window.action_registered)
      modal_window.register_actions()

    $block.modal(
      backdrop: (if modal_window.blockable then 'static' else true),
      keyboard: !modal_window.blockable,
      show: true
    )

  create: (full_screen, header, body, footer, id) ->
    modal_window.hide($("#{if id then "##{id}" else ''}.modal"))
    modal_window.show(modal_window.template(
      full_screen,
      if typeof header is 'boolean' then '&nbsp;' else header,
      if typeof body is 'boolean' then '&nbsp;' else body,
      if typeof footer is 'boolean' then '&nbsp;' else footer,
      id)
    )

  hide: (selector) ->
    $(selector || '.modal').modal('hide')
    $('.modal-backdrop').remove()




  proceed_state_on: ->
    parent_selector = ".#{modal_window.modal_content_selector}"
    if ($(parent_selector, '.modal').length == 0)
      parent_selector = undefined

    modal_window.inject_data(modal_window.default_body, ".#{modal_window.modal_proceeding_selector}", false, parent_selector)
    $(".#{modal_window.modal_header_selector}, .#{modal_window.modal_body_selector}, .#{modal_window.modal_footer_selector}").hide()

  proceed_state_off: ->
    $(".#{modal_window.modal_proceeding_selector}", '.modal').remove()
    $(".#{modal_window.modal_header_selector}, .#{modal_window.modal_body_selector}, .#{modal_window.modal_footer_selector}").show()




  replace_elems: (header, body, footer, modal_selector) ->
    if (header) then modal_window.replace_header(header, modal_selector)
    if (body) then modal_window.replace_body(body, modal_selector)
    if (footer) then modal_window.replace_footer(footer, modal_selector)

  replace_header: (new_data, modal_selector) ->
    $(modal_selector || '.modal').find(".#{modal_window.modal_header_selector}").replaceWith(modal_window.build_header(new_data))

  replace_body: (new_data, modal_selector) ->
    $(modal_selector || '.modal').find(".#{modal_window.modal_body_selector}").replaceWith(modal_window.build_body(new_data))
    modal_window.update_width()

  replace_footer: (new_data, modal_selector) ->
    $(modal_selector || '.modal').find(".#{modal_window.modal_footer_selector}").replaceWith(modal_window.build_footer(new_data))

  inject_data_to_body: (new_data, block_class, prepend, modal_selector) ->
    modal_window.inject_data(new_data, block_class, prepend, ".#{modal_window.modal_body_selector}", modal_selector)

  inject_data: (new_data, block_class, prepend = false, modal_block_selector, modal_selector) ->
    $mbody = $(modal_selector || '.modal')
    if (modal_block_selector) then $mbody = $mbody.find(modal_block_selector)
    $block = $mbody.find(block_class)
    if ($block.length == 0)
      $block = $("<div class='#{block_class.split(" ").pop().substring(1)}'></div>")
      if prepend then $mbody.prepend($block) else $mbody.append($block)

    $block.html(new_data)
