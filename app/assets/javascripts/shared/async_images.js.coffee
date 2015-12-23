jQuery ->
  regexp = /\d+/
  $.each($('.async_img'), (i, img) ->
    $img = $(img)
    $downloadingImage = $("<img>");
    $downloadingImage.load( ->
      $img.attr('src', $(this).attr('src'))

      $parent = $img.closest('.item')
      if ($parent.hasClass('fixed_height'))
        outerHeight = 0

        $('*', $parent).each( ->
          outerHeight += $(this).outerHeight();
        )

        paddings = 101
        if (outerHeight - paddings > $parent.outerHeight())
          $img.css(
            'max-height', (Number(regexp.exec($img.css('max-height'))) -
              (outerHeight - paddings - $parent.outerHeight()) / 2) + 'px'
          )
    )
    $downloadingImage.attr('src', $img.data('src'))
  )
