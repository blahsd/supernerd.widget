commands =
  focus: "echo $(/usr/local/bin/chunkc tiling::query --window name)"

command: "echo " +
         "$(#{ commands.focus}):::"

refreshFrequency: false

render: ( ) ->
  """
     <div class="container" id="window">
      <div class="widg" id="window">
          <div class="icon-container" id="music-icon-container">
          </div>
        <span class="output" id="window-output"></span>
      </div>
    </div>
  """

update: ( output, domEl ) ->
  window = output.split( /:::/g )[ 0 ]
  window = window.split( /–/g )[ 0 ]
  $( "#window-output" ).text(window)
