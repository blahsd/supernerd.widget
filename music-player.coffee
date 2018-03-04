commands =
  isitunesrunning: "osascript -e 'if application \"iTunes\" is running then return true'"
  isspotifyrunning: "osascript -e 'if application \"Spotify\" is running then return true'"
  itunes: "osascript -e 'if application \"iTunes\" is running then tell application \"iTunes\" to if player state is playing then artist of current track & \" - \" & name of current track'"
  spotify: "osascript -e 'if application \"Spotify\" is running then tell application \"Spotify\" to artist of current track & \" - \" & name of current track '"



command: "echo " +
         "$(#{ commands.isitunesrunning}):::" +
         "$(#{ commands.isspotifyrunning}):::" +
         "$(#{ commands.itunes}):::" +
         "$(#{ commands.spotify})"

refreshFrequency: '1s'

render: ( ) ->
  """
    <div class="container">
        <div class="widg music" id="music">
          <i class="fab fa-itunes-note"></i>
        </div>
      <span class="playing-output"></span>
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
  if isspotifyrunning
    $( ".playing-output") .text("#{ spotify }")
