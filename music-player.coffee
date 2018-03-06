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
          <i class="fas fa-home"></i>
        <span id="home-link" class="closed">~/</span>
        </div>
        <div class="widg music" id="music">
          <i class="fas fa-play" id="playButton"></i>
          <i class="fas fa-step-forward" id="nextButton"></i>
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
  if isspotifyrunning
    $( ".playing-output") .text("#{ spotify }")

handlePlay: (domEl) ->
  @run "osascript -e 'tell application \"Spotify\" to playpause'"
  if $(domEl).find('#player').hasClass('fa-play')
    $(domEl).find('#player').removeClass()
    $(domEl).find('#player').addClass('fas fa-pause')
  else
    $(domEl).find('#player').removeClass()
    $(domEl).find('#player').addClass('fas fa-play')

handleNext: (domEl) ->
  @run "osascript -e 'tell application \"Spotify\" to next track'"

afterRender: (domEl) ->
  $(domEl).on 'click', '#home', => @run "open ~/"

  $(domEl).on 'click', '#playButton', => @handlePlay(domEl)
  $(domEl).on 'click', '#nextButton', => @handleNext()
