window.wheater = undefined
window.weather_limit = 6
#window.sunrise = undefined
#window.sunset = undefined

current_timestamp = () -> Math.round(+new Date() / 1000)

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
  $block = $('.weather_panel').html('')
  space = window.innerHeight - 15 - $('.navbar-fixed-top').outerHeight()
  item_max_height = 50
  offset = 0

  for block in window.wheater#[..window.weather_limit]
    date = new Date(block['time'] * 1000);

    $elem = $("""
      <div class='weather_block'>
        <span>#{date.getHours()}:00 #{date.getDate()}.#{date.getFullYear()}</span>
        <img src="http://openweathermap.org/img/w/#{block['icon']}.png"></img>
        <span>#{Math.round(block['temperature'])}&deg;</span>
      </div>
    """)

    if ((space -= item_max_height) > 0)
      $block.append($elem)

      offset = Math.max(offset, $elem.find('img').position().left)

    else break

  $block.attr('data-offset', -offset)
  if ($block.position().left < -999)
    $block.css({"left": $block.data('offset') + 'px'});


init_theme = (block) ->
#  snowfall()


wheater_proc = ->
  if (window.wheater.length < window.weather_limit)
    init_weather_data()
  else
    fill_panel()
    init_theme(window.wheater.shift())
    setTimeout 'wheater_proc()', 1098000

$ ->
  init_weather_data()

  $('body').on 'click', '.weather_panel', ->
    $that = $(@)
    $that.css({"left": (if ($that.position().left == 0) then $that.data('offset') else 0) + 'px'});