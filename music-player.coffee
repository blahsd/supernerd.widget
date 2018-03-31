

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

refreshFrequency: '10s'

render: ( ) ->
  """
    <div class="container" >

    <div class="widg" id="play">

      <div class="icon-container" id="play-icon-container">
        <i class="fas fa-play" id="play-button"></i>
      </div>

    </div>

    <div class="widg hidden" id="play-tray">

      <div class="widg" id="next">

        <div class="icon-container" id="next-icon-container">
          <i class="fas fa-step-forward" id="next-button"></i>
        </div>

      </div>

      <div class="widg" id="playing">
        <span class="output nohidden" id='play-output'></span>
      </div>

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

  if isspotifyplaying
    @handlePlayIcon(domEl, true)
    @handlePlayIcon(domEl, true)
    @run "osascript -e 'if application \"Spotify\" is running then tell application \"Spotify\" to if player state is playing then artist of current track & \" - \" & name of current track'", (err, output) ->
      $(domEl).find('#play-output').text(output)
  else if isitunesplaying
    @handlePlayIcon(domEl, true)
    @handlePlayIcon(domEl, true)
    @run "osascript -e 'if application \"iTunes\" is running then tell application \"iTunes\" to if player state is playing then artist of current track & \" - \" & name of current track'", (err, output) ->
      $(domEl).find('#play-output').text(output)
  else if not isspotifyplaying && not isitunesplaying
    @handlePlayIcon(domEl, false)
    $("#play-output").text("")

#
# ─── HANDLES  ─────────────────────────────────────────────────────────
#

getDesktopColor: (activedesk) ->
  color = switch
    when activedesk == "1" then "red"
    when activedesk == "2" then "yellow"
    when activedesk == "3" then "blue"
    when activedesk == "4" then "magenta"

  return color

handlePlay: (domEl, status) ->
  @run "osascript -e 'tell application \"iTunes\" to playpause'"
  @handlePlayIcon(domEl, status)
  @refresh()

handlePlayIcon: (domEl, status) ->
  if status == 'NULL'
    if $(domEl).find('#play-button').hasClass('fa-play')
      status = true
    else
      status = false

  if status == true
    $(domEl).find('#play-button').removeClass()
    $(domEl).find('#play-button').addClass('fas fa-pause')
    $(domEl).find('#play').addClass('pinned')
    $(domEl).find('#play-tray').removeClass('hidden')
  else
    $(domEl).find('#play-button').removeClass()
    $(domEl).find('#play').removeClass('pinned')
    $(domEl).find('#play-button').addClass('fas fa-play')
    $(domEl).find('#play-tray').addClass('hidden')

handleNext: (domEl) ->
  @run "osascript -e 'tell application \"iTunes\" to next track'"
  $(domEl).find('#play-button').removeClass()
  $(domEl).find('#play-button').addClass('fas fa-pause')
  @refresh()

afterRender: (domEl) ->
  $(domEl).on 'click', '#play', => @handlePlay(domEl, 'NULL')
  $(domEl).on 'click', '#next', => @handleNext(domEl)
