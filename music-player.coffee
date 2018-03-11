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

refreshFrequency: '2s'

render: ( ) ->
  """
    <div class="container">
        <div class="widg" id="play">
          <div class="icon-container" id="play-icon-container">
            <i class="fas fa-play" id="play-button"></i>
          </div>
          <div class="icon-container" id="next-icon-container">
            <i class="fas fa-step-forward" id="next-button"></i>
          </div>
          <span class="static-output" id='play-output'></span>
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
    $( "#play-output").text("#{ spotify }")
  else if isitunesplaying
    @handlePlayIcon(domEl, true)
    $( "#play-output").text("#{ itunes }")
  else if not isspotifyplaying && not isitunesplaying
    @handlePlayIcon(domEl, false)
    $( "#play-output").text("Paused")
#
# ─── HANDLES  ─────────────────────────────────────────────────────────
#

handlePlay: (domEl, status) ->
  @run "osascript -e 'tell application \"iTunes\" to playpause'"
  @handlePlayIcon(domEl, status)

handlePlayIcon: (domEl, status) ->
  if status == 'NULL'
    if $(domEl).find('#play-button').hasClass('fa-play')
      status = true
    else
      status = false

  if status == true
    $(domEl).find('#play-button').removeClass()
    $(domEl).find('#play-button').addClass('fas fa-pause')
    $(domEl).find('#play').addClass('open')
  else
    $(domEl).find('#play-button').removeClass()
    $(domEl).find('#play-button').addClass('fas fa-play')
    $(domEl).find('#play').removeClass('open')

handleNext: (domEl) ->
  @run "osascript -e 'tell application \"iTunes\" to next track'"
  $(domEl).find('#play-button').removeClass()
  $(domEl).find('#play-button').addClass('fas fa-pause')

afterRender: (domEl) ->
  $(domEl).on 'click', '#home', => @run "open ~/"

  $(domEl).on 'click', '#play-button', => @handlePlay(domEl, 'NULL')
  $(domEl).on 'click', '#next-button', => @handleNext(domEl)

#
# ─── ANIMATION  ─────────────────────────────────────────────────────────
#
  # ---- OPEN
  $(domEl).on 'mouseover', ".widg", (e) => $(domEl).find( $($(e.target))).addClass('open')
  $(domEl).on 'mouseover', ".icon-container", (e) => $(domEl).find( $($(e.target))).parent().addClass('open')
  $(domEl).on 'mouseover', ".output", (e) => $(domEl).find( $($(e.target))).parent().addClass('open')

  $(domEl).on 'mouseout', ".widg", (e) => $(domEl).find( $($(e.target))).removeClass('open')
  $(domEl).on 'mouseout', ".icon-container", (e) => $(domEl).find( $($(e.target))).parent().removeClass('open')
  $(domEl).on 'mouseout', ".output", (e) => $(domEl).find( $($(e.target))).parent().removeClass('open')

  #$(domEl).on 'click', ".widg", (e) => @toggleOption( domEl, e, 'pinned')
#
# ─── CLICKS  ─────────────────────────────────────────────────────────
#

toggleOption: (domEl, e, option) ->
  target = $(domEl).find( $($(e.target))).parent()

  if target.hasClass("#{ option }")
    $(target).removeClass("#{ option }")
    $(output).removeClass("#{ option }")
  else
    $(target).addClass("#{ option }")
    $(output).addClass("#{ option }")
