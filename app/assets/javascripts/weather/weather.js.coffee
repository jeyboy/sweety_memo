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
  if (window.wheater.length == 0)
    return

  $block = $('.weather_panel').html('')
  space = window.innerHeight - 15 - $('.navbar-fixed-top').outerHeight()
  item_max_height = 50
  offset = 99999

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

      offset = Math.min(offset, $elem.find('img').position().left + 10)

    else break

  $block.attr('data-offset', -offset)
  if ($block.position().left != 0)
    $block.css({"left": $block.data('offset') + 'px'});


init_theme = (block) ->
#  snowfall()
# rainfall()


wheater_proc = ->
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

  $('body').on 'click', '.weather_panel', ->
    $that = $(@)
    new_pos = 0

    if ($that.position().left == 0)
      new_pos = $that.data('offset')
      $that.removeClass('colored')
    else
      $that.addClass('colored')

    $that.css({"left": new_pos + 'px'});