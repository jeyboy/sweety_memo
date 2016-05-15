jQuery ->
  ((window, document) ->

#    width = $(window).width();
#    if (width < 768)
#      return


    ###
    # Grab all iframes on the page or return
    ###

    iframes = document.getElementsByTagName('iframe')

    ###
    # Loop through the iframes array
    ###

    i = 0
    while i < iframes.length
      iframe = iframes[i]
      players = /www.youtube.com|player.vimeo.com/

      ###
      # If the RegExp pattern exists within the current iframe
      ###

      if iframe.src.search(players) > 0

        ###
        # Calculate the video ratio based on the iframe's w/h dimensions
        ###

        videoRatio = iframe.height / iframe.width * 100

        ###
        # Replace the iframe's dimensions and position
        # the iframe absolute, this is the trick to emulate
        # the video ratio
        ###

        iframe.style.position = 'absolute'
        iframe.style.top = '0'
        iframe.style.left = '0'
        iframe.width = '100%'
        iframe.height = '100%'

        ###
        # Wrap the iframe in a new <div> which uses a
        # dynamically fetched padding-top property based
        # on the video's w/h dimensions
        ###

        wrap = document.createElement('div')
        wrap.className = 'fluid-vids'
        wrap.style.width = '100%'
        wrap.style.position = 'relative'
        wrap.style.paddingTop = videoRatio + '%'
        wrap.style.minHeight = '50px'

        ###
        # Add the iframe inside our newly created <div>
        ###

        iframeParent = iframe.parentNode
        iframeParent.insertBefore wrap, iframe
        wrap.appendChild iframe
      i++
    return
  ) window, document
