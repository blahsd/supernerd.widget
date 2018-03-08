
commands =
  cpu : "ps -A -o %cpu | awk '{s+=$1} END {printf(\"%.2f\",s/8);}'"
  mem : "ps -A -o %mem | awk '{s+=$1} END {print s \"%\"}' "
  hdd : "df -hl | awk '{s+=$5} END {print s \"%\"}'"

command: "echo " +
         "$(#{ commands.cpu }):::" +
         "$(#{ commands.mem }):::" +
         "$(#{ commands.hdd }):::"

refreshFrequency: false

render: ( ) ->
  """
    <div class="container">

          <div class="widg" id="cpu">
          <div class="icon-container" id='cpu-icon-container'>
            <i class="fa fa-spinner"></i>
          </div>
            <span class="output closed" id="cpu-output"></span>
          </div>

          <div class="widg" id="mem">
          <div class="icon-container" id='mem-icon-container'>
            <i class="fas fa-server"></i>
            </div>
            <span class="output closed" id="mem-output"></span>
          </div>

          <div class="widg" id="hdd">
          <div class="icon-container" id='hdd-icon-container'>
            <i class="fas fa-hdd"></i>
            </div>
              <span class="output closed" id="hdd-output"></span>
          </div>
    </div>
  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  cpu = output[ 0 ]
  mem = output[ 1 ]
  hdd = output[ 2 ]
  $( "#cpu-output") .text("#{ cpu }")
  $( "#mem-output") .text("#{ mem }")
  $( "#hdd-output") .text("#{ hdd }")

  @handleSysmon( domEl, Number( cpu ), '#cpu' )
  @handleSysmon( domEl, Number( mem.replace( /%/g, "") ), '#mem' )
  @handleSysmon( domEl, Number( hdd.replace( /%/g, "") ), '#hdd' )

#
# ─── COLOR SYSMON –─────────────────────────────────────────────────────────
#
handleSysmon: ( domEl, sysmon, monid ) ->
  div = $(domEl)

  div.find(monid).removeClass('blue')
  div.find(monid).removeClass('cyan')
  div.find(monid).removeClass('green')
  div.find(monid).removeClass('yellow')
  div.find(monid).removeClass('magenta')
  div.find(monid).removeClass('red')
  div.find(monid).removeClass('white')
  div.find(monid).removeClass('black')
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

afterRender: (domEl) ->
  $(domEl).on 'mouseover', '#cpu', => $(domEl).find('.cpu-output').addClass('open')
  $(domEl).on 'mouseout', '#cpu', => $(domEl).find('.cpu-output').removeClass('open')

  $(domEl).on 'mouseover', '#mem', => $(domEl).find('.mem-output').addClass('open')
  $(domEl).on 'mouseout', '#mem', => $(domEl).find('.mem-output').removeClass('open')

  $(domEl).on 'mouseover', '#hdd', => $(domEl).find('.hdd-output').addClass('open')
  $(domEl).on 'mouseout', '#hdd', => $(domEl).find('.hdd-output').removeClass('open')

  $(domEl).on 'mouseover', '#cpu', => $(domEl).find('#cpu').addClass('open')
  $(domEl).on 'mouseout', '#cpu', => $(domEl).find('#cpu').removeClass('open')

  $(domEl).on 'mouseover', '#mem', => $(domEl).find('#mem').addClass('open')
  $(domEl).on 'mouseout', '#mem', => $(domEl).find('#mem').removeClass('open')

  $(domEl).on 'mouseover', '#hdd', => $(domEl).find('#hdd').addClass('open')
  $(domEl).on 'mouseout', '#hdd', => $(domEl).find('#hdd').removeClass('open')
