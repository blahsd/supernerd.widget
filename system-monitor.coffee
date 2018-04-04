
commands =
  cpu : "ps -A -o %cpu | awk '{s+=$1} END {printf(\"%.2f\",s/8);}'"
  mem : "ps -A -o %mem | awk '{s+=$1} END {print s \"%\"}' "
  hdd : "df / | awk 'END{print $5}'"
  net : "sh ./supernerd.widget/scripts/getnetwork.sh"



command: "echo " +
         "$(#{ commands.cpu }):::" +
         "$(#{ commands.mem }):::" +
         "$(#{ commands.hdd }):::" +
         "$(#{ commands.net }):::"

refreshFrequency: '1s'

render: ( ) ->
  """
    <div class="container">

          <div class="widg red" id="upl">
          <div class="icon-container" id='upl-icon-container'>
            <i class="fa fa-upload"></i>
          </div>
            <span class="output" id="upl-output"></span>
          </div>

          <div class="widg blue" id="dwl">
          <div class="icon-container" id='dwl-icon-container'>
            <i class="fa fa-download"></i>
          </div>
            <span class="output" id="dwl-output"></span>
          </div>

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


    </div>
  """

convertBytes: (bytes) ->
  kb = bytes / 1024
  mb = kb / 1024
  if mb < 0.01
    return "0.00mb"
  return "#{parseFloat(mb.toFixed(2))}MB"

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  cpu = output[ 0 ]
  mem = output[ 1 ]
  hdd = output[ 2 ]
  net = output[ 3 ].split( /@/g )
  upl = net[ 0 ]
  dwl = net[ 1 ]


  $( "#cpu-output").text("#{ cpu }%")
  $( "#mem-output").text("#{ mem }")
  $( "#hdd-output").text("#{ hdd }")
  $( "#upl-output").text("#{ @convertBytes(upl) }")
  $( "#dwl-output").text("#{ @convertBytes(dwl) }")


  @handleSysmon( domEl, Number( cpu ), '#cpu' )
  @handleSysmon( domEl, Number( mem.replace( /%/g, "") ), '#mem' )
  @handleSysmon( domEl, Number( hdd.replace( /%/g, "") ), '#hdd' )

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

  $(domEl).on 'mouseout', ".widg", (e) => $(domEl).find( $($(e.target))).removeClass('open')

  $(domEl).on 'click', ".widg", (e) => $(domEl).find( $($(e.target))).toggleClass('pinned')
