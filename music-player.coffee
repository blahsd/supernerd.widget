options =
  player: 'itunes' # spotify | itunes

commands =
  isitunesrunning: "sh ./supernerd.widget/scripts/isitunesrunning.sh"
  isspotifyrunning: "sh ./supernerd.widget/scripts/isspotifyrunning.sh"
  itunes: "osascript -e 'if application \"iTunes\" is running then tell application \"iTunes\" to if player state is playing then artist of current track & \" - \" & name of current track'"
  spotify: "osascript -e 'if application \"Spotify\" is running then tell application \"Spotify\" to artist of current track & \" - \" & name of current track'"

command: "echo " +
         "$(#{ commands.isitunesrunning}):::" +
         "$(#{ commands.isspotifyrunning}):::" +
         "$(#{ commands.itunes}):::" +
         "$(#{ commands.spotify})"

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
  output = output.split( /:::/g )
  isitunesrunning = output[0]
  isspotifyrunning = output[1]
  itunes = output[2]
  spotify = output[3]

  if isitunesrunning
    $( ".playing-output") .text("#{ itunes }")
  else if isspotifyrunning
    $( ".playing-output") .text("#{ spotify }")
  else
    $( ".playing-output") .text("Stopped")
