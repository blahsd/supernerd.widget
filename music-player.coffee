commands =
  volume : "osascript -e 'output volume of (get volume settings)'"
  ismuted : "osascript -e 'output muted of (get volume settings)'"
  isitunesrunning: "osascript -e 'if application \"iTunes\" is running then return true'"
  isspotifyrunning: "osascript -e 'if application \"Spotify\" is running then return true'"
  isitunesplaying: "osascript -e 'if application \"iTunes\" is running then tell application \"iTunes\" to if player state is playing then return true'"
  isspotifyplaying: "osascript -e 'if application \"Spotify\" is running then tell application \"Spotify\" to if player state is playing then return true'"
  itunes: "osascript -e 'if application \"iTunes\" is running then tell application \"iTunes\" to if player state is playing then artist of current track & \" - \" & name of current track'"
  spotify: "osascript -e 'if application \"Spotify\" is running then tell application \"Spotify\" to artist of current track & \" - \" & name of current track '"

command: "echo " +
        "$(#{ commands.volume }):::" +
        "$(#{ commands.ismuted }):::" +
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

      </div>
        <div class="widg" id="play">
          <div class="icon-container" id="play-icon-container">
            <i class="fas fa-play" id="play-button"></i>
          </div>
          <div class="icon-container" id="next-icon-container">
            <i class="fas fa-step-forward" id="next-button"></i>
          </div>
          <span class="static-output" id='play-output'></span>
        </div>
          <div class="widg" id="volume">
            <div class="icon-container" id='volume-icon-container'>
              <i id="volume-icon"></i>
            </div>
            <span class="output" id='volume-output'>Paused</span>
          </div>
    </div>
  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )
  volume = output[0]
  ismuted = output[1]
  isitunesrunning = output[2]
  isspotifyrunning = output[3]
  isitunesplaying = output[4]
  isspotifyplaying = output[5]
  itunes = output[6]
  spotify = output[7]

  @handleVolume( domEl, Number( volume ), ismuted )


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
handleVolume: ( domEl, volume, ismuted ) ->
  div = $( domEl )

  volumeIcon = switch
    when volume ==   0 then "fa-volume-off"
    when volume <=  50 then "fa-volume-down"
    when volume <= 100 then "fa-volume-up"

  div.find("#volume").removeClass('blue')
  div.find("#volume").removeClass('red')
  if ismuted != 'true'
    div.find( "#volume-output").text("#{ volume }")
    div.find('#volume').addClass('blue')
    div.find('#volume-icon-container').addClass('blue')
  else
    div.find( "#volume-output").text("Muted")
    volumeIcon = "fa-volume-off"
    div.find('#volume').addClass('red')
    div.find('#volume-icon-container').addClass('red')

  $( "#volume-icon" ).html( "<i class=\"fa #{ volumeIcon }\"></i>" )

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
    $(domEl).find('#play').addClass('open pinned')
  else
    $(domEl).find('#play-button').removeClass()
    $(domEl).find('#play-button').addClass('fas fa-play')
    $(domEl).find('#play').removeClass('open pinned')

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

  $(domEl).on 'click', ".widg", (e) => @toggleOption( domEl, e, 'pinned')
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
