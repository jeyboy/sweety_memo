jQuery ->
  $.each($('.async_img'), (i, img) ->
    $img = $(img)
    $downloadingImage = $("<img>");
    $downloadingImage.load( ->
      $img.attr('src', $(this).attr('src'))
    )
    $downloadingImage.attr('src', $img.data('src'))
  )
