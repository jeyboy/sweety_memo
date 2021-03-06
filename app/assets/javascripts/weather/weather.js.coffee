window.wheater = undefined
window.weather_limit = 6
#window.sunrise = undefined
#window.sunset = undefined

window.sun_obj = undefined
window.moon_obj = undefined

current_timestamp = () -> Math.round(+new Date() / 1000)

window.proc_day = (is_day)->
  unless is_day
    is_day = !!window.sun_obj

  initClientRect()
  wrapper = wrapperNode()

  if window.sun_obj
    wrapper.removeChild(sun_obj)
    window.sun_obj = undefined

  if window.moon_obj
    wrapper.removeChild(moon_obj)
    window.moon_obj = undefined

  if is_day
    window.sun_obj = document.createElement('img')
    window.sun_obj.setAttribute('style', "position:absolute; z-index: -1; visibility:visible; top:0; left:#{window.uwidth - 250}px;")
    window.sun_obj.setAttribute('src', window.sun)
    wrapper.appendChild(window.sun_obj)
  else
    window.moon_obj = document.createElement('img')
    window.moon_obj.setAttribute('style', "position:absolute; z-index: -1; visibility:visible; top:0; left:#{window.uwidth - 250}px;")
    window.moon_obj.setAttribute('src', window.moon)
    wrapper.appendChild(window.moon_obj)



init_weather_data = ->
#  $.ajax
#    method: 'get'
#    url: 'http://api.openweathermap.org/data/2.5/weather?q=Zaporizhia,Ukraine&lang=ru&appid=c84fde3de3b623d068423c00490870c4&type=accurate'
#    success: (response) ->
#      window.sunrise = response['sys']['sunrise']
#      window.sunset = response['sys']['sunset']

  $.ajax
    method: 'get'
    url: 'http://api.openweathermap.org/data/2.5/forecast?q=Zaporizhia,Ukraine&lang=ru&appid=c84fde3de3b623d068423c00490870c4&type=accurate&units=metric'
    success: parse_weather_data

parse_weather_data = (response) ->
  window.wheater = []

  for block in response['list']
    icon = block['weather'][0]['icon']

    window.wheater.push({
      time: block['dt']
      humidity: block['main']['humidity']
      temperature: block['main']['temp']
      pressure: block['main']['pressure']
      wind: block['wind']['speed'] # m/s
      clouds: block['clouds']['all'] # %
      description: block['weather'][0]['description']
      icon: icon
      rain: if block['rain'] then block['rain']['3h'] # mm for last 3 hours
      snow: if block['snow'] then block['snow']['3h'] # mm for last 3 hours
      day: icon[icon.length - 1] == 'd'
    })

  wheater_proc()

fill_panel = ->
  if (window.wheater.length == 0)
    return

  $block = $('.weather_panel').html('')
  space = window.innerHeight - 15 - $('.navbar-fixed-top').outerHeight()
  item_max_height = 50
  offset = 999999

  for block in window.wheater#[..window.weather_limit]
    date = new Date(block.time * 1000);

    $elem = $("""
      <div class='weather_block' style='clear: both'>
        <div style='float: left; padding-top: 5px;'>
          <div>#{date.getHours()}:00 #{date.getDate()}.#{date.getFullYear()} - #{block.description}</div>
          <div>Влажность: #{block.humidity}% Давление: #{block.pressure}mm Облачность: #{block.clouds}%</div>
        </div>
        <div style='float: right; padding-left: 8px;'>
          <span class='degrees'>#{Math.round(block.temperature)}&deg;</span>
          <img src="http://openweathermap.org/img/w/#{block.icon}.png"></img>
        </div>
      </div>
    """)

    if ((space -= item_max_height) > 0)
      $block.append($elem)

      offset = Math.min(offset, $elem.find('img').position().left)

    else break

  $block.attr('data-offset', -(offset + 12))
  if ($block.position().left != 0)
    $block.css({"left": $block.data('offset') + 'px'});


init_theme = (block) ->
  stopRainfall()
  stopSnowfall()

  amount = window.innerWidth * window.innerHeight / window.weather_def_del

  if (block.rain && block.snow)
    amount /= 2

  if (block.rain)
    rainfall(amount)

  if (block.snow)
    snowfall(amount)

  proc_day(block.day)


window.wheater_proc = ->
  if (window.wheater.length < window.weather_limit)
    init_weather_data()
  else
    fill_panel()
    init_theme(window.wheater.shift())
    setTimeout 'wheater_proc()', 1098000

$ ->
  init_weather_data()

  $(window).on 'resize', ->
    fill_panel() # need to optimize rebuild of panel on resize
    init_theme(window.wheater[0])
    proc_day()

  $('body').on 'click', '.weather_panel', ->
    $that = $(@)
    new_pos = 0

    if ($that.position().left == 0)
      new_pos = $that.data('offset')
      $that.removeClass('colored')
    else
      $that.addClass('colored')

    $that.css({"left": new_pos + 'px'});