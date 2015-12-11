window.recalc_padding = ->
  h = $('.navbar-fixed-top').outerHeight();
  $(".body").css({"padding-top": h + "px"});

jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

  $(window).on 'resize', recalc_padding

$(window).load(-> recalc_padding());
