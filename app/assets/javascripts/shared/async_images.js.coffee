jQuery ->
  regexp = /\d+/
  $.each($('.async_img'), (i, img) ->
    $img = $(img)
    $downloadingImage = $("<img>");
    $downloadingImage.load( ->
      $img.attr('src', $(this).attr('src'))

      $parent = $img.closest('.item')
      if ($parent.hasClass('fixed_height'))
        if ($parent.prop('scrollHeight') > $parent.outerHeight())
          $img.css(
            'max-height', (Number(regexp.exec($img.css('max-height'))) -
              ($parent.prop('scrollHeight') - $parent.outerHeight() + 20)) + 'px'
          )
    )
    $downloadingImage.attr('src', $img.data('src'))
  )
