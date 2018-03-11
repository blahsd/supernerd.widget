
commands =
  cpu : "ps -A -o %cpu | awk '{s+=$1} END {printf(\"%.2f\",s/8);}'"
  mem : "ps -A -o %mem | awk '{s+=$1} END {print s \"%\"}' "
  hdd : "df -hl | awk '{s+=$5} END {print s \"%\"}'"
  battery : "pmset -g batt | egrep '([0-9]+\%).*' -o --colour=auto | cut -f1 -d';'"
  ischarging : "sh ./supernerd.widget/scripts/ischarging.sh"


command: "echo " +
         "$(#{ commands.cpu }):::" +
         "$(#{ commands.mem }):::" +
         "$(#{ commands.hdd }):::" +
         "$(#{ commands.battery }):::" +
         "$(#{ commands.ischarging }):::"

refreshFrequency: '1m'

render: ( ) ->
  """
    <div class="container">

          <div class="widg" id="cpu">
          <div class="icon-container" id='cpu-icon-container'>
            <i class="fa fa-spinner"></i>
          </div>
            <span class="output" id="cpu-output"></span>
          </div>

          <div class="widg" id="mem">
          <div class="icon-container" id='mem-icon-container'>
            <i class="fas fa-server"></i>
            </div>
            <span class="output" id="mem-output"></span>
          </div>

          <div class="widg" id="hdd">
          <div class="icon-container" id='hdd-icon-container'>
            <i class="fas fa-hdd"></i>
            </div>
              <span class="output" id="hdd-output"></span>
          </div>

          <div class="widg" id="battery">
            <div class="icon-container" id='battery-icon-container'>
            <i class="battery-icon"></i>
            </div>
            <span class="output" id='battery-output'></span>
          </div>

    </div>
  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  cpu = output[ 0 ]
  mem = output[ 1 ]
  hdd = output[ 2 ]
  battery = output[ 3 ]
  ischarging = output[ 4 ]

  $( "#cpu-output") .text("#{ cpu }")
  $( "#mem-output") .text("#{ mem }")
  $( "#hdd-output") .text("#{ hdd }")
  $( "#battery-output") .text("#{ battery }")

  @handleSysmon( domEl, Number( cpu ), '#cpu' )
  @handleSysmon( domEl, Number( mem.replace( /%/g, "") ), '#mem' )
  @handleSysmon( domEl, Number( hdd.replace( /%/g, "") ), '#hdd' )

  @handleBattery( domEl, Number( battery.replace( /%/g, "" ) ), ischarging )

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
# ─── HANDLE SYSMON –─────────────────────────────────────────────────────────
#
handleSysmon: ( domEl, sysmon, monid ) ->
  div = $(domEl)

  div.find(monid).removeClass('blue')
  div.find(monid).removeClass('cyan')
  div.find(monid).removeClass('green')
  div.find(monid).removeClass('yellow')
  div.find(monid).removeClass('magenta')
  div.find(monid).removeClass('red')

  if sysmon <= 10
    div.find(monid).addClass('blue')
  else if sysmon <= 20
    div.find(monid).addClass('blue')
  else if sysmon <= 40
    div.find(monid).addClass('cyan')
  else if sysmon <= 50
    div.find(monid).addClass('green')
  else if sysmon <= 75
    div.find(monid).addClass('yellow')
  else
    div.find(monid).addClass('red')

#
# ─── UNIVERSAL CLICK AND ANIMATION HANDLING  ─────────────────────────────────────────────────────────
#
afterRender: (domEl) ->
  $(domEl).on 'mouseover', ".widg", (e) => $(domEl).find( $($(e.target))).addClass('open')
  $(domEl).on 'mouseover', ".icon-container", (e) => $(domEl).find( $($(e.target))).parent().addClass('open')
  $(domEl).on 'mouseover', ".output", (e) => $(domEl).find( $($(e.target))).parent().addClass('open')

  $(domEl).on 'mouseout', ".widg", (e) => $(domEl).find( $($(e.target))).removeClass('open')
  $(domEl).on 'mouseout', ".icon-container", (e) => $(domEl).find( $($(e.target))).parent().removeClass('open')
  $(domEl).on 'mouseout', ".output", (e) => $(domEl).find( $($(e.target))).parent().removeClass('open')

  $(domEl).on 'click', ".widg", (e) => @toggleOption( domEl, e, 'pinned')

toggleOption: (domEl, e, option) ->
  target = $(domEl).find( $($(e.target))).parent()

  if target.hasClass("#{ option }")
    $(target).removeClass("#{ option }")
    $(output).removeClass("#{ option }")
  else
    $(target).addClass("#{ option }")
    $(output).addClass("#{ option }")
