commands =
  focus: "echo $(/usr/local/bin/chunkc tiling::query --window name)"

command: "echo " +
         "$(#{ commands.focus}):::"

refreshFrequency: '0.5s'

render: ( ) ->
  """
     <div class="container" id="window">
      <div class="widg" id="window">
        <span class="window-output"></span>
      </div>
    </div>
  """

update: ( output, domEl ) ->
  window = output.split( /:::/g )[ 0 ]
  window = window.split( /–/g )[ 0 ]
  $( ".window-output" ).text(window)
