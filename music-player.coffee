
commands =
  playing: "osascript -e 'tell application \"iTunes\" to if player state is playing then artist of current track & \" - \" & name of current track'"

command: "echo " +
         "$(#{ commands.playing })"

refreshFrequency: '10s'

render: ( ) ->
  """
    <div class="container">
        <div class="widg" id="music">
          <i class="fab fa-itunes-note"></i>
          <span class="playing-output"></span>
        </div>
    </div>
  """

update: ( output, domEl ) ->


  $( ".playing-output") .text("#{ output }")
