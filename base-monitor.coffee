commands =
  volume : "osascript -e 'output volume of (get volume settings)'"
  ismuted : "osascript -e 'output muted of (get volume settings)'"
  brightness: "sh ./supernerd.widget/scripts/getbrightness.sh"
  battery : "pmset -g batt | egrep '([0-9]+\%).*' -o --colour=auto | cut -f1 -d';'"
  ischarging : "sh ./supernerd.widget/scripts/ischarging.sh"
  wifi: "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | sed -e \"s/^ *SSID: //p\" -e d"
  isconnected: "echo true"
  time: "date +\"%H:%M\""
  date  : "date +\"%a %d %b\""
  focus : "/usr/local/bin/chunkc tiling::query --window name"
  playing: "osascript -e 'tell application \"iTunes\" to if player state is playing then artist of current track & \" - \" & name of current track'"
  weather: "cat ./supernerd.widget/lib/weather.txt"


iconMapping:
  "rain"                :"fas fa-tint"
  "snow"                :"fas fa-snowflake"
  "fog"                 :"fas fa-braille"
  "cloudy"              :"fas fa-cloud"
  "wind"                :"fas fa-align-left"
  "clear-day"           :"fas fa-sun"
  "mostly-clear-day"    :"fas fa-adjust"
  "partly-cloudy-day"   :"fas fa-cloud"
  "clear-night"         :"fas fa-star"
  "partly-cloudy-night" :"fal fa-adjust"
  "unknown"             :"fas fa-question"

command: "echo " +
         "$(#{ commands.volume }):::" +
         "$(#{ commands.ismuted }):::" +
         "$(#{ commands.brightness }):::" +
         "$(#{ commands.battery }):::" +
         "$(#{ commands.ischarging }):::" +
         "$(#{ commands.wifi }):::" +
         "$(#{ commands.isconnected }):::" +
         "$(#{ commands.time }):::" +
         "$(#{ commands.date }):::" +
         "$(#{ commands.weather }):::"

refreshFrequency: '1s'

render: ( ) ->
  """
    <div class="container">
    <span id="valueHolder" value="10"></span>

      <div class="widg" id="volume">
        <div class="icon-container" id='volume-icon-container'>
          <i id="volume-icon"></i>
        </div>
        <span class='output'>
          <div class="bar-output" id="volume-bar-output">
            <div class="bar-output" id="volume-bar-color-output"></div>
          </div>
        </span>
        <span class="output" id='volume-output'></span>
      </div>


      <div class="widg " id="brightness">
        <div class="icon-container" id='brightness-icon-container'>
          <i class="fas fa-sun"></i>
        </div>
        <span class='output'>
          <div class="bar-output" id="brightness-bar-output">
            <div class="bar-output" id="brightness-bar-color-output"></div>
          </div>
        </span>
        <span class="output" id='brightness-output'></span>
      </div>

      <div class="widg" id="wifi">
        <div class="icon-container" id='wifi-icon-container'>
          <i class="fa fa-wifi"></i>
        </div>
        <span class="output" id='wifi-output'></span>
      </div>


      <div class="widg pinned" id="battery">
        <div class="icon-container" id='battery-icon-container'>
        <i class="battery-icon"></i>
        </div>
        <span class="output" id='battery-output'></span>
      </div>


      <div class="widg pinned" id="time">
        <div class="icon-container" id='time-icon-container'>
          <i class="far fa-clock"></i>
        </div>
        <span class="output" id='time-output'></span>
      </div>


      <div class="widg" id="date">
        <div class="icon-container" id='date-icon-container'>
        <i class="far fa-calendar-alt"></i>
        </div>
        <span class="output" id='date-output'></span>
      </div>
      <div class="widg" id="weather">
        <div class="icon-container" id="weather-icon-container">
          <i class="weather-icon"></i>
        </div>
        <span class="output" id="weather-output">Loading</span>
      </div>
    </div>
  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  values = []

  values.volume   = output[ 0 ]
  values.ismuted  = output[ 1 ]
  values.brightness = output[ 2 ]
  values.battery = output[ 3 ]
  values.ischarging  = output[ 4 ]
  values.wifi = output[ 5 ]
  values.isconnected = output[ 6 ]
  values.time = output[ 7 ]
  values.date = output[ 8 ]
  values.weatherdata = output[ 9 ]


  controls = ['time','date','battery','volume','wifi']
  for control in controls
    outputId = "#"+control+"-output"
    currentValue = $("#{outputId}").value
    updatedValue = values[control]

    if updatedValue != currentValue
      $("#{ outputId }").text("#{ updatedValue }")

      if control is 'battery'
         @handleBattery( domEl, Number( values["battery"].replace( /%/g, "" ) ), values["ischarging"] )
      else if control is 'wifi' then @handleWifi( domEl, values["wifi"] )
      else if control is  'volume' then @handleVolume( domEl, Number( values["volume"]), values["ismuted"] )
      else if control is 'brightness' then @handleBrightness( domEl, values["brightness"] )

  #@handleWeather( domEl, weatherdata )

#
# ─── HANDLE BRIGHTNESS ─────────────────────────────────────────────────────────
handleBrightness: (domEl, brightness ) ->
  brightness = Math.round(100*brightness) + 2
  $("#brightness-output").text("#{brightness}")
  $( "#brightness-bar-color-output" ).width( "#{brightness}%" )

#
#
# ─── HANDLE VOLUME ─────────────────────────────────────────────────────────
#

handleVolume: ( domEl, volume, ismuted ) ->
  div = $( domEl )

  volumeIcon = switch
    when volume ==   0 then "fa-volume-off"
    when volume <=  50 then "fa-volume-down"
    when volume <= 100 then "fa-volume-up"

  #
  # div.find("#volume").removeClass('blue')
  # div.find("#volume").removeClass('red')
  #
  # if ismuted != 'true'
  #   div.find( "#volume-output").text("#{ volume }")
  #   div.find('#volume').addClass('blue')
  #   div.find('#volume-icon-container').addClass('blue')
  # else
  #   div.find( "#volume-output").text("Muted")
  #   volumeIcon = "fa-volume-off"
  #   div.find('#volume').addClass('red')
  #   div.find('#volume-icon-container').addClass('red')

  $("#volume-output").text("#{volume}")
  $( "#volume-icon" ).html( "<i class=\"fa #{ volumeIcon }\"></i>" )
  $( "#volume-bar-color-output" ).width( "#{volume}%" )


#
# ─── HANDLE BATTERY ─────────────────────────────────────────────────────────
#

handleBattery: ( domEl, percentage, ischarging ) ->
  div = $( domEl )

  batteryIcon = switch
    when percentage <=  12 then "fa-battery-empty"
    when percentage <=  25 then "fa-battery-quarter"
    when percentage <=  50 then "fa-battery-half"
    when percentage <=  75 then "fa-battery-three-quarters"
    when percentage <= 100 then "fa-battery-full"


  div.find("#battery").removeClass('green')
  div.find("#battery").removeClass('yellow')
  div.find("#battery").removeClass('red')

  if percentage >= 35
    div.find('#battery').addClass('green')
    div.find('#battery-icon-container').addClass('green')
  else if percentage >= 15
    div.find('#battery').addClass('yellow')
    div.find('#battery-icon-container').addClass('yellow')
  else
    div.find('#battery').addClass('red')
    div.find('#battery-icon-container').addClass('red')

  if ischarging == "true"
    batteryIcon = "fas fa-bolt"
  $( ".battery-icon" ).html( "<i class=\"fa #{ batteryIcon }\"></i>" )

#
# ─── HANDLE WEATHER ─────────────────────────────────────────────────────────
#
handleWeather: ( domEl, weatherdata ) ->
  geolocation.getCurrentPosition (e) =>
    coords     = e.position.coords
    [lat, lon] = [coords.latitude, coords.longitude]
    @commands.weather = @makeCommand(@apiKey, "#{lat},#{lon}")


  data  = JSON.parse(weatherdata)
  $(domEl).find('#weather-output').text(weatherdata)
  today = data.daily?.data[0]

  return unless today?
  date  = @getDate today.time

  $(domEl).find('#weather-output').text(String (Math.round(today.temperatureMax)+'°'))
  $(domEl).find('#weather-ext-output').text(String(today.summary))
  $(domEl).find( ".weather-icon" ).html( "<i class=\"fa #{ @getIcon(today) }\"></i>" )


  $(domEl).find("#weather").removeClass('red')
  $(domEl).find("#weather").removeClass('white')
  $(domEl).find("#weather").removeClass('cyan')
  if data.temperatureMax >= 26
    $(domEl).find('#weather').addClass('red')
    $(domEl).find('#weather-icon-container').addClass('red')
  else if data.temperatureMax >= 6
    $(domEl).find('#weather').addClass('white')
    $(domEl).find('#weather-icon-container').addClass('white')
  else
    $(domEl).find('#weather').addClass('cyan')
    $(domEl).find('#weather-icon-container').addClass('cyan')

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

makeCommand: (apiKey, location) ->
  exclude  = "minutely,hourly,alerts,flags"


#
# ─── HANDLE WIFI ─────────────────────────────────────────────────────────
#

handleWifi: (domEl, wifi ) ->
  $( "#wifi-output").text("#{ wifi }")

  if wifi == ''
    wifiIcon = 'fas fa-exclamation-circle'
  else
    wifiIcon = 'fa fa-wifi'
  $(domEl).find( ".wifi-icon" ).html( "<i class=\"fa #{ wifiIcon }\"></i>" )


#
# ─── ANIMATION  ─────────────────────────────────────────────────────────
#
afterRender: (domEl) ->
  $(domEl).on 'mouseover', ".widg", (e) => $(domEl).find( $($(e.target))).addClass('open')
  $(domEl).on 'mouseover', ".icon-container", (e) => $(domEl).find( $($(e.target))).parent().addClass('open')
  $(domEl).on 'mouseover', ".output", (e) => $(domEl).find( $($(e.target))).parent().addClass('open')

  $(domEl).on 'mouseout', ".widg", (e) => $(domEl).find( $($(e.target))).removeClass('open')
  $(domEl).on 'mouseout', ".icon-container", (e) => $(domEl).find( $($(e.target))).parent().removeClass('open')
  $(domEl).on 'mouseout', ".output", (e) => $(domEl).find( $($(e.target))).parent().removeClass('open')

  $(domEl).on 'click', ".widg", (e) => @toggleOption( domEl, e, 'pinned')
#
# ─── CLICKS  ─────────────────────────────────────────────────────────
#

toggleOption: (domEl, e, option) ->
  target = $(domEl).find( $($(e.target))).parent()

  if target.hasClass("#{ option }")
    $(target).removeClass("#{ option }")
    $(output).removeClass("#{ option }")
  else
    $(target).addClass("#{ option }")
    $(output).addClass("#{ option }")
