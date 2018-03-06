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


command: "echo " +
         "$(#{ commands.battery }):::" +
         "$(#{ commands.time }):::" +
         "$(#{ commands.wifi }):::" +
         "$(#{ commands.volume }):::" +
         "$(#{ commands.date }):::" +
         "$(#{ commands.ismuted }):::" +
         "$(#{ commands.ischarging }):::"

refreshFrequency: '2s'

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
      <div class="widg red" id="date">
        <div class="icon-container" id='date-icon-container'>
        <i class="far fa-calendar-alt"></i>
        </div>
        <span class="output closed" id='date-output'></span>
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

  $(domEl).find( "#time-output" ).text( "#{ time }" )
  $(domEl).find( "#date-output" ).text( "#{ date }" )
  $(domEl).find( "#battery-output").text("#{ battery }")
  $(domEl).find( "#wifi-output").text("#{ wifi }")

  @handleBattery( domEl, Number( battery.replace( /%/g, "" ) ), ischarging )
  @handleVolume( domEl, Number( volume ), ismuted )

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
  volumeIcon = switch
    when volume ==   0 then "fa-volume-off"
    when volume <=  50 then "fa-volume-down"
    when volume <= 100 then "fa-volume-up"


  if ismuted != 'true'
    $(domEl).find( "#volume-output").text("#{ volume }")
  else
    $(domEl).find( "#volume-output").text("Muted")
    volumeIcon = "fa-volume-off"

  $( "#volume-icon" ).html( "<i class=\"fa #{ volumeIcon }\"></i>" )

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

#
# ─── CLICKS  ─────────────────────────────────────────────────────────
#

afterRender: (domEl) ->
  $(domEl).on 'mouseover', '#volume', => @toggleOpen($(domEl).find('#volume-output'), true)
  $(domEl).on 'mouseout', '#volume', => @toggleOpen($(domEl).find('#volume-output'))
  $(domEl).on 'click', '#volume', => @toggleOption($(domEl).find('#volume-output'),$(domEl).find('#volume-icon-container'),'pinned')

  $(domEl).on 'mouseover', '#wifi', => @toggleOpen($(domEl).find('#wifi-output'), true)
  $(domEl).on 'mouseout', '#wifi', => @toggleOpen($(domEl).find('#wifi-output'))
  $(domEl).on 'click', '#wifi', => @toggleOption($(domEl).find('#wifi-output'),$(domEl).find('#wifi-icon-container'),'pinned')

  $(domEl).on 'mouseover', '#battery', => @toggleOpen($(domEl).find('#battery-output'), true)
  $(domEl).on 'mouseout', '#battery', => @toggleOpen($(domEl).find('#battery-output'))
  $(domEl).on 'click', '#battery', => @toggleOption($(domEl).find('#battery-output'),$(domEl).find('#battery-icon-container'),'pinned')

  $(domEl).on 'mouseover', '#time', => @toggleOpen($(domEl).find('#time-output'), true)
  $(domEl).on 'mouseout', '#time', => @toggleOpen($(domEl).find('#time-output'))
  $(domEl).on 'click', '#time', => @toggleOption($(domEl).find('#time-output'),$(domEl).find('#time-icon-container'),'pinned')

  $(domEl).on 'mouseover', '#date', => @toggleOpen($(domEl).find('#date-output'), true)
  $(domEl).on 'mouseout', '#date', => @toggleOpen($(domEl).find('#date-output'))
  $(domEl).on 'click', '#date', => @toggleOption($(domEl).find('#date-output'),$(domEl).find('#date-icon-container'),'pinned')
