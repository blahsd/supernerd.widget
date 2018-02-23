
commands =
  cpu : "ps -A -o %cpu | awk '{s+=$1} END {printf(\"%.2f\",s/8);}'"
  mem : "ps -A -o %mem | awk '{s+=$1} END {print s \"%\"}' "
  hdd : "df -hl | awk '{s+=$5} END {print s \"%\"}'"

command: "echo " +
         "$(#{ commands.cpu }):::" +
         "$(#{ commands.mem }):::" +
         "$(#{ commands.hdd }):::"

refreshFrequency: '10s'

render: ( ) ->
  """
    <div class="container">

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
  """

style: """
    @import url(https://use.fontawesome.com/releases/v5.0.6/css/all.css);
    @import url(supernerd.widget/styles/default.css);
"""
update: ( output, domEl ) ->
  output = output.split( /:::/g )

  cpu = output[ 0 ]
  mem = output[ 1 ]
  hdd = output[ 2 ]
  $( ".cpu-output") .text("#{ cpu }")
  $( ".mem-output") .text("#{ mem }")
  $( ".hdd-output") .text("#{ hdd }")
