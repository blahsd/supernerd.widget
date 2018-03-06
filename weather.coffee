apiKey: '103d3850d574a558eb1e11905de4a047' # put your forcast.io api key inside the quotes here

refreshFrequency: 60000


command: "echo {}"

render: () -> """

  <div class="container">
    <div class="widg" id="weather">
      <div class="icon-container" id="weather-icon-container">
        <i class="weather-icon"></i>
      </div>
      <span class="output closed " id="weather-output">Loading</span>
      <span class="output closed" id="weather-ext-output">Loading</span>
    </div>
  </div>
"""

svgNs: 'xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"'

toggleOption: (target, parent, option, excludingCondition = false) ->
  if excludingCondition && $(target).hasClass(excludingCondition)
    return
  if $(parent) != false
    if $(parent).hasClass("#{ option }")
      $(parent).removeClass("#{ option }")
      $(target).removeClass("#{ option }")
    else
      $(parent).addClass("#{ option }")
      $(target).addClass("#{ option }")
  else
    if $(target).hasClass("#{ option }")
      $(target).removeClass("#{ option }")
    else
      $(target).addClass("#{ option }")

toggleOpen: (target, open = false) ->
  if target.hasClass('pinned')
    return
  if open
    $(target).addClass('open')
  else
    $(target).removeClass('open')

afterRender: (domEl) ->
  geolocation.getCurrentPosition (e) =>
    coords     = e.position.coords
    [lat, lon] = [coords.latitude, coords.longitude]
    @command   = @makeCommand(@apiKey, "#{lat},#{lon}")

    $(domEl).find('.location').prop('textContent', e.address.city)
    @refresh()

    $(domEl).on 'mouseover', '#weather', => @toggleOpen($(domEl).find('#weather-output'), true) &&
    $(domEl).on 'mouseout', '#weather', => @toggleOpen($(domEl).find('#weather-output'))
    $(domEl).on 'click', '#weather', => @toggleOption($(domEl).find('#weather-output'),$(domEl).find('#weather-icon-container'),'pinned')


makeCommand: (apiKey, location) ->
  exclude  = "minutely,hourly,alerts,flags"
  "curl -sS 'https://api.forecast.io/forecast/#{apiKey}/#{location}?units=auto&exclude=#{exclude}'"

update: (output, domEl) ->
  data  = JSON.parse(output)
  today = data.daily?.data[0]

  return unless today?
  date  = @getDate today.time

  $(domEl).find('#weather-output').text(String (Math.round(today.temperatureMax)+'°'))
  $(domEl).find('#weather-ext-output').text(String(today.summary))
  $(domEl).find( ".weather-icon" ).html( "<i class=\"fa #{ @getIcon(today) }\"></i>" )

iconMapping:
  "rain"                :"fas fa-tint"
  "snow"                :"fas fa-snowflake"
  "fog"                 :"fas fa-braille"
  "cloudy"              :"fas fa-cloud"
  "wind"                :"fab fa-gitter" #this must be turned
  "clear-day"           :"fas fa-sun"
  "mostly-clear-day"    :"fas fa-sun"
  "partly-cloudy-day"   :"fas fa-cloud"
  "clear-night"         :"fas fa-star"
  "partly-cloudy-night" :"fas fa-cloud"
  "unknown"             :"fas fa-question"

getIcon: (data) ->
  return @iconMapping['unknown'] unless data

  if data.icon.indexOf('cloudy') > -1
    if data.cloudCover < 0.25
      @iconMapping["clear-day"]
    else if data.cloudCover < 0.5
      @iconMapping["mostly-clear-day"]
    else if data.cloudCover < 0.75
      @iconMapping["partly-cloudy-day"]
    else
      @iconMapping["cloudy"]
  else
    @iconMapping[data.icon]

getDate: (utcTime) ->
  date  = new Date(0)
  date.setUTCSeconds(utcTime)
  date
