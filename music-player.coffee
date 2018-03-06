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
        <div class="widg home" id="home">
          <div class="icon-container pinned" id="home-icon-container">
          <i class="fas fa-home"></i>
          </div>
        </div>
        <div class="widg music" id="music">
          <div class="icon-container" id="music-icon-container">
            <i class="fas fa-play" id="playButton"></i>
            <i class="fas fa-step-forward" id="nextButton"></i>
          </div>
          <span class="output" id='playing-output'></span>
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
    $( "#playing-output") .text("#{ itunes }")
  if isspotifyrunning
    $( "#playing-output") .text("#{ spotify }")

handlePlay: (domEl) ->
  @run "osascript -e 'tell application \"Spotify\" to playpause'"
  if $(domEl).find('#playButton').hasClass('fa-play')
    $(domEl).find('#playButton').removeClass()
    $(domEl).find('#playButton').addClass('fas fa-pause')
  else
    $(domEl).find('#playButton').removeClass()
    $(domEl).find('#playButton').addClass('fas fa-play')

handleNext: (domEl) ->
  @run "osascript -e 'tell application \"Spotify\" to next track'"

afterRender: (domEl) ->
  $(domEl).on 'click', '#home', => @run "open ~/"

  $(domEl).on 'click', '#playButton', => @handlePlay(domEl)
  $(domEl).on 'click', '#nextButton', => @handleNext()
