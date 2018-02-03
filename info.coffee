#
# ──────────────────────────────────────────────── II ──────
#   :::::: I N F O : :  :   :    :     :        :          :
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
           #{}"$(#{ commands.battery }):::" +
           "$(#{ commands.time }):::"
           #{}"$(#{ commands.wifi }):::" +
           #{}"$(#{ commands.volume }):::"

  #
  # ─── REFRESH ────────────────────────────────────────────────────────────────
  #

  refreshFrequency: 1000

  #
  # ─── RENDER ─────────────────────────────────────────────────────────────────
  #

  render: ( ) ->
    """
    <link rel="stylesheet" href="./font-awesome/font-awesome.min.css" />

    <div class="volume">
      <span class="volume-icon"></span>
      <span class="volume-output"></span>
    </div>
    <div class="wifi">
      <i class="fa fa-wifi"></i>
      <span class="wifi-output"></span>
    </div>
    <div class="battery">
      <span class="battery-icon"></span>
      <span class="battery-output"></span>
    </div>
    <div class="time">
      <i class="fa fa-clock-o"></i>
      <span class="time-output"></span>
    </div>
    """

  #
  # ─── RENDER ─────────────────────────────────────────────────────────────────
  #

  update: ( output ) ->
    output = output.split( /:::/g )

    time   = output[ 0 ]

    $( ".time-output" )    .text( "#{ time }" )

    #@handleBattery( Number( battery.replace( /%/g, "" ) ) )
    #@handleVolume( Number( volume ) )

  #
  # ─── HANDLE BATTERY ─────────────────────────────────────────────────────────
  #

  handleBattery: ( percentage ) ->
    batteryIcon = switch
      when percentage <=  12 then "fa-battery-0"
      when percentage <=  25 then "fa-battery-1"
      when percentage <=  50 then "fa-battery-2"
      when percentage <=  75 then "fa-battery-3"
      when percentage <= 100 then "fa-battery-4"
    $( ".battery-icon" ).html( "<i class=\"fa #{ batteryIcon }\"></i>" )

  #
  # ─── HANDLE VOLUME ──────────────────────────────────────────────────────────
  #

  handleVolume: ( volume ) ->
    volumeIcon = switch
      when volume ==   0 then "fa-volume-off"
      when volume <=  50 then "fa-volume-down"
      when volume <= 100 then "fa-volume-up"
    $( ".volume-icon" ).html( "<i class=\"fa #{ volumeIcon }\"></i>" )

  #
  # ─── STYLE ──────────────────────────────────────────────────────────────────
  #

  style: """
    .battery
      color: #{ colors.green }
    .time
      color: #{ colors.white }
    .wifi
      color: #{ colors.white }
    .volume
      color: #{ colors.cyan }

    display: flex
    div
      margin-right: 15px

    top: 26px
    right: 100px
    font-family: 'Menlo'
    font-size: 12px
    font-smoothing: antialiasing
    z-index: 0
  """

# ──────────────────────────────────────────────────────────────────────────────
