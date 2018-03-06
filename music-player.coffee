commands =
  isitunesrunning: "osascript -e 'if application \"iTunes\" is running then return true'"
  isspotifyrunning: "osascript -e 'if application \"Spotify\" is running then return true'"
  isitunesplaying: "osascript -e 'if application \"iTunes\" is running then tell application \"iTunes\" to if player state is playing then return true'"
  isspotifyplaying: "osascript -e 'if application \"Spotify\" is running then tell application \"Spotify\" to if player state is playing then return true'"
  itunes: "osascript -e 'if application \"iTunes\" is running then tell application \"iTunes\" to if player state is playing then artist of current track & \" - \" & name of current track'"
  spotify: "osascript -e 'if application \"Spotify\" is running then tell application \"Spotify\" to artist of current track & \" - \" & name of current track '"

command: "echo " +
         "$(#{ commands.isitunesrunning}):::" +
         "$(#{ commands.isspotifyrunning}):::" +
         "$(#{ commands.isitunesplaying}):::" +
         "$(#{ commands.isspotifyplaying}):::" +
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
        <div class="widg play" id="play">
          <div class="icon-container" id="play-icon-container">
            <i class="fas fa-play" id="play-button"></i>
          </div>
          <div class="icon-container" id="next-icon-container">
            <i class="fas fa-step-forward" id="next-button"></i>
          </div>
          <span class="output" id='play-output'></span>
        </div>

    </div>
  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )
  isitunesrunning = output[0]
  isspotifyrunning = output[1]
  isitunesplaying = output[2]
  isspotifyplaying = output[3]
  itunes = output[4]
  spotify = output[5]

  if isitunesrunning
    $( "#play-output") .text("#{ itunes }")
  if isspotifyrunning
    $( "#play-output") .text("#{ spotify }")

  if isspotifyplaying || isitunesplaying
    $(domEl).find('#play-button').removeClass()
    $(domEl).find('#play-button').addClass('fas fa-pause')

handlePlay: (domEl) ->
  @run "osascript -e 'tell application \"Spotify\" to playpause'"
  if $(domEl).find('#play-button').hasClass('fa-play')
    $(domEl).find('#play-button').removeClass()
    $(domEl).find('#play-button').addClass('fas fa-pause')
  else
    $(domEl).find('#play-button').removeClass()
    $(domEl).find('#play-button').addClass('fas fa-play')

handleNext: (domEl) ->
  @run "osascript -e 'tell application \"Spotify\" to next track'"
  $(domEl).find('#play-button').removeClass()
  $(domEl).find('#play-button').addClass('fas fa-pause')

afterRender: (domEl) ->
  $(domEl).on 'click', '#home', => @run "open ~/"

  $(domEl).on 'click', '#play-button', => @handlePlay(domEl)
  $(domEl).on 'click', '#next-button', => @handleNext(domEl)
