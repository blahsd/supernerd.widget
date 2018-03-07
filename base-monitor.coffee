apiKey: '103d3850d574a558eb1e11905de4a047' # put your forcast.io api key inside the quotes here
svgNs: 'xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"'

commands =
  battery: "pmset -g batt | egrep '([0-9]+\%).*' -o --colour=auto | cut -f1 -d';'"
  time: "date +\"%H:%M\""
  wifi: "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | sed -e \"s/^ *SSID: //p\" -e d"
  volume : "osascript -e 'output volume of (get volume settings)'"
  cpu : "ps -A -o %cpu | awk '{s+=$1} END {printf(\"%.2f\",s/8);}'"
  mem : "ps -A -o %mem | awk '{s+=$1} END {print s \"%\"}' "
  hdd : "df -hl | awk '{s+=$5} END {print s \"%\"}'"
  date  : "date +\"%a %d %b\""
  focus : "/usr/local/bin/chunkc tiling::query --window name"
  playing: "osascript -e 'tell application \"iTunes\" to if player state is playing then artist of current track & \" - \" & name of current track'"
  ismuted : "osascript -e 'output muted of (get volume settings)'"
  ischarging : "sh ./supernerd.widget/scripts/ischarging.sh"
  weather : "sh ./supernerd.widget/scripts/getweather.sh '103d3850d574a558eb1e11905de4a047' '45.4391,8.8855'"


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
         "$(#{ commands.battery }):::" +
         "$(#{ commands.time }):::" +
         "$(#{ commands.wifi }):::" +
         "$(#{ commands.volume }):::" +
         "$(#{ commands.date }):::" +
         "$(#{ commands.ismuted }):::" +
         "$(#{ commands.ischarging }):::" +
         "$(#{ commands.weather }):::"


refreshFrequency: false

render: ( ) ->
  """
    <div class="container">
      <div class="widg" id="volume">
        <div class="icon-container" id='volume-icon-container'>
          <i id="volume-icon"></i>
        </div>
        <span class="output closed" id='volume-output'></span>
      </div>
      <div class="widg" id="wifi">
        <div class="icon-container" id='wifi-icon-container'>
          <i class="fa fa-wifi"></i>
        </div>
        <span class="output closed" id='wifi-output'></span>
      </div>
      <div class="widg" id="battery">
        <div class="icon-container" id='battery-icon-container'>
        <i class="battery-icon"></i>
        </div>
        <span class="output closed" id='battery-output'></span>
      </div>
      <div class="widg" id="time">
        <div class="icon-container" id='time-icon-container'>
          <i class="far fa-clock"></i>
        </div>
        <span class="output closed" id='time-output'></span>
      </div>
      <div class="widg" id="date">
        <div class="icon-container" id='date-icon-container'>
        <i class="far fa-calendar-alt"></i>
        </div>
        <span class="output closed" id='date-output'></span>
      </div>

      <div class="widg" id="weather">
        <div class="icon-container" id="weather-icon-container">
          <i class="weather-icon"></i>
        </div>
        <span class="output closed " id="weather-output">Loading</span>

      </div>

    </div>
  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  battery = output[ 0 ]
  time   = output[ 1 ]
  wifi = output[ 2 ]
  volume = output[ 3 ]
  date = output[ 4 ]
  ismuted = output[ 5 ]
  ischarging = output[ 6 ]
  weatherdata = output[ 7 ]


  $(domEl).find( "#time-output" ).text( "#{ time }" )
  $(domEl).find( "#date-output" ).text( "#{ date }" )
  $(domEl).find( "#battery-output").text("#{ battery }")
  $(domEl).find( "#wifi-output").text("#{ wifi }")

  @handleBattery( domEl, Number( battery.replace( /%/g, "" ) ), ischarging )
  @handleVolume( domEl, Number( volume ), ismuted )
  @handleWifi( domEl, wifi )
  @handleWeather( domEl, weatherdata )

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
  if wifi == 'NULL'
    wifiIcon = 'fas fa-exclamation-circle'
  else
    wifiIcon = 'fa fa-wifi'
  $(domEl).find( ".wifi-icon" ).html( "<i class=\"fa #{ wifiIcon }\"></i>" )

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
# ─── HANDLE VOLUME ─────────────────────────────────────────────────────────
#

handleVolume: ( domEl, volume, ismuted ) ->
  div = $( domEl )
  volumeIcon = switch
    when volume ==   0 then "fa-volume-off"
    when volume <=  50 then "fa-volume-down"
    when volume <= 100 then "fa-volume-up"

  div.find("#volume").removeClass('blue')
  div.find("#volume").removeClass('red')
  if ismuted != 'true'
    div.find( "#volume-output").text("#{ volume }")
    div.find('#volume').addClass('blue')
    div.find('#volume-icon-container').addClass('blue')
  else
    div.find( "#volume-output").text("Muted")
    volumeIcon = "fa-volume-off"
    div.find('#volume').addClass('red')
    div.find('#volume-icon-container').addClass('red')

  $( "#volume-icon" ).html( "<i class=\"fa #{ volumeIcon }\"></i>" )

#
# ─── ANIMATION  ─────────────────────────────────────────────────────────
#
afterRender: (domEl) ->
  $(domEl).on 'mouseover', ".icon-container", (e) => @toggleOption($(domEl).find( $($(e.target).parent().find('.output')) ), 'open', true)
  $(domEl).on 'mouseout', ".widg", (e) => @toggleOption($(domEl).find( $($(e.target).find('.output')) ), 'open', false)

  $(domEl).on 'click', ".widgh", (e) => @toggleOption($(domEl).find( $($(e.target).find('.output')) ), 'pinned', true)

#
# ─── CLICKS  ─────────────────────────────────────────────────────────
#

toggleOption: (target, option, add) ->
  parent = target.parent()
  children = target.children()

  if add
    $(parent).addClass("#{ option }")
    $(target).addClass("#{ option }")

    for child in children
      do
      child.addClass("#{ option }")

  else
    $(parent).removeClass("#{ option }")
    $(target).removeClass("#{ option }")

    for child in children
      do
      child.removeClass("#{ option }")
