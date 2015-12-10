window.recalc_padding = ->
  h = $('.navbar-fixed-top').outerHeight();
  $(".body").css({"padding-top": h + "px"});

jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

  recalc_padding()

  $(window).on 'resize', recalc_padding


