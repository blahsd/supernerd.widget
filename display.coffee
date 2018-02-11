#
# ──────────────────────────────────────────────── I ───────
#   :::::: S U P E R N E R D – TOP
# ──────────────────────────────────────────────────────────
#

#
# ─── ALL COMMANDS ───────────────────────────────────────────────────────────
#

commands =
  battery: "pmset -g batt | egrep '([0-9]+\%).*' -o --colour=auto " +
           "| cut -f1 -d';'"
  time   : "date +\"%H:%M\""
  wifi   : "/System/Library/PrivateFrameworks/Apple80211.framework/" +
           "Versions/Current/Resources/airport -I | " +
           "sed -e \"s/^ *SSID: //p\" -e d"
  volume : "osascript -e 'output volume of (get volume settings)'"
  cpu : "ps -A -o %cpu | awk '{s+=$1} END {printf(\"%.2f\",s/8);}'"
  mem : "ps -A -o %mem | awk '{s+=$1} END {print s \"%\"}' "
  hdd : "df -hl | awk '{s+=$5} END {print s \"%\"}'"
  date  : "date +\"%a %d %b\""
  focus : "/usr/local/bin/chunkc tiling::query --window name"
  playing: "osascript ~/dev/supernerd/lib/get-current-track.applescript"

#
# ─── COLORS ─────────────────────────────────────────────────────────────────
#

colors =
  black:   "#282a36"
  red:     "#ff5c57"
  green:   "#5af78e"
  yellow:  "#f3f99d"
  blue:    "#57c7ff"
  magenta: "#ff6ac1"
  cyan:    "#9aedfe"
  white:   "#eff0eb"

#
# ─── COMMAND ────────────────────────────────────────────────────────────────
#

command: "echo " +
         "$(#{ commands.battery }):::" +
         "$(#{ commands.time }):::" +
         "$(#{ commands.wifi }):::" +
         "$(#{ commands.volume }):::" +
         "$(#{ commands.cpu }):::" +
         "$(#{ commands.mem }):::" +
         "$(#{ commands.hdd }):::" +
         "$(#{ commands.date }):::" +
         "$(#{ commands.focus }):::" +
         "$(#{ commands.playing }):::"


#
# ─── REFRESH ────────────────────────────────────────────────────────────────
#

refreshFrequency: 128

#
# ─── RENDER ─────────────────────────────────────────────────────────────────
#

render: ( ) ->
  """
  <div id="main">
    <div class="bar" id="top">

      <div class="container" id="left">
        <div class="widg" id="music">
          <i class="fab fa-itunes-note"></i>
          <span class="infoPlaceholder">iTunes</span>
          <span class="artist"></span>-
          <span class="song"></span>
          <span class="infoPlaceholder">Stopped</span>
        </div>
      </div>

    <div class="container" id="center">
      <div class="widg" id="window">
        <i class="fa fa-window-maximize"></i>
        <span class="window-output"></span>
      </div>
    </div>

    <div class="container" id="right">
      <div class="widg" id="volume">
        <span class="volume-icon"></span>
        <span class="volume-output"></span>
      </div>
      <div class="widg" id="wifi">
        <i class="fa fa-wifi"></i>
        <span class="wifi-output"></span>
      </div>
      <div class="widg" id="battery">
        <span class="battery-icon"></span>
        <span class="battery-output"></span>
      </div>
      <div class="widg" id="time">
        <i class="far fa-clock"></i>
        <span class="time-output"></span>
      </div>
      <div class="widg" id="date">
        <i class="far fa-calendar-alt"></i>
        <span class="date-output"></span>
      </div>
    </div>
  </div>

  <div class="bar" id="bottom">

    <div class="container" id="left">
      <div class="widg" id="home">
        <i class="fas fa-home"></i>
        ~/
      </div>
      <div class="widg" id="browser">
        <i class="far fa-compass"></i>
        Browser
      </div>
      <div class="widg" id="mail">
        <i class="far fa-envelope"></i>
        Mail
      </div>
      <div class="widg" id="messages">
        <i class="far fa-comments"></i>
        Messages
      </div>
    </div>

    <div class="container" id="center">
    <br/>
    </div>

    <div class="container" id="right">
      <div class="widg" id="cpu">
        <i class="fa fa-spinner"></i>
        <span class="cpu-output"></span>
      </div>
      <div class="widg" id="mem">
        <i class="fas fa-server"></i>
        <span class="mem-output"></span>
      </div>

      <div class="widg" id="hdd">
        <i class="fas fa-hdd"></i>
          <span class="hdd-output"></span>
      </div>
    </div>

  </div>
</div>
  """

#
# ─── RENDER ─────────────────────────────────────────────────────────────────
#

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  battery = output[ 0 ]
  time   = output[ 1 ]
  wifi = output[ 2 ]
  volume = output[ 3 ]
  cpu = output[ 4 ]
  mem = output[ 5 ]
  hdd = output[ 6 ]
  date = output[ 7 ]
  focus = output[ 8 ]
  playing = output[ 9 ]

  # Focus
  focus = focus.split( / /g )[ 0 ]
  # Music
  playing = playing.split ( /@/g )
  artist = playing[ 0 ]
  song = playing[ 1 ]
  album = playing[ 2 ]
  tDuration = playing[3]
  tPosition = playing[4]

  div = $(domEl)
  if !playing[ 1 ]
      div.find(".artist").hide(1)
      div.find(".song").hide(1)
      div.find(".infoPlaceholder").show(1)
  else
      div.find(".artist").show(1)
      div.find(".song").show(1)
      div.find(".infoPlaceholder").hide(1)

  $( ".time-output" )    .text( "#{ time }" )
  $( ".date-output" )    .text( "#{ date }" )
  $( ".battery-output") .text("#{ battery }")
  $( ".wifi-output") .text("#{ wifi }")
  $( ".volume-output") .text("#{ volume }")
  $( ".cpu-output") .text("#{ cpu }")
  $( ".mem-output") .text("#{ mem }")
  $( ".hdd-output") .text("#{ hdd }")
  $( ".window-output" ).text( "#{ focus }" )
  $( ".song" ).text( "#{ song }" )
  $( ".artist" ).text( "#{ artist }" )


  @handleBattery( domEl, Number( battery.replace( /%/g, "" ) ) )
  @handleVolume( Number( volume ) )

#
# ─── HANDLE BATTERY ─────────────────────────────────────────────────────────
#

handleBattery: ( domEl, percentage ) ->
  div = $( domEl )

  batteryIcon = switch
    when percentage <=  12 then "fa-battery-empty"
    when percentage <=  25 then "fa-battery-quarter"
    when percentage <=  50 then "fa-battery-half"
    when percentage <=  75 then "fa-battery-three-quarters"
    when percentage <= 100 then "fa-battery-full"
  $( ".battery-icon" ).html( "<i class=\"fa #{ batteryIcon }\"></i>" )

  if percentage >= 20
    div.find('.battery').css('color', colors.green )
  else if percentage >= 10
    div.find('.battery').css('color', colors.yellow )
  else
    div.find('.battery').css('color', colors.red )
#
# ─── HANDLE VOLUME ─────────────────────────────────────────────────────────
#

handleVolume: ( volume ) ->
  volumeIcon = switch
    when volume ==   0 then "fa-volume-off"
    when volume <=  50 then "fa-volume-down"
    when volume <= 100 then "fa-volume-up"
  $( ".volume-icon" ).html( "<i class=\"fa #{ volumeIcon }\"></i>" )

#
# ─── HANDLE CLICKS ────────────────────────────────────────────────────────
#
afterRender: (domEl) ->
    $(domEl).on 'click', '.music', => @run "open /Applications/iTunes.app"

#
# ─── STYLE ─────────────────────────────────────────────────────────────────
#

style: """
#volume
  color: #{ colors.cyan }
#music
  color: #{ colors.green }

font-family: 'Menlo'
font-size: 12px
font-smoothing: antialiasing
color: #{ colors.white }
width:100%

.bar
  background-color: #{ colors.black }
  border-radius:4px
  margin:8px
  padding-left:24px
  padding-right:24px

.bar:after
  content: "";
  display: table;
  clear: both;

#bottom
  margin-top:58%

.container
  float: left;
  width: 33.33%
  display:flex

#left
  justify-content:flex-start

#right
  justify-content:flex-end

#center
  display:block
  text-align:center

.widg
  margin:8px
"""

# ──────────────────────────────────────────────────────────────────────────────
