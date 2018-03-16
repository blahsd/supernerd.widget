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

refreshFrequency: false

render: ( ) ->
  """
    <div class="container" >

    <div class="widg" id="app-launcher">
      <div class="widg pinned" id="home">
        <div class="icon-container" id="home-icon-container">
         <i class="far fa-home"></i>
        </div>
      </div>

      <div class="widg hidden" id="app-list">

        <div class="widg" id="browser">
          <div class="icon-container" id="browser-icon-container">
            <i class="icon far fa-compass"></i>
          </div>
        </div>

        <div class="widg" id="mail">
          <div class="icon-container" id="mail-icon-container">
            <i class="icon far fa-envelope"></i>
          </div>
        </div>

        <div class="widg" id="messages">
          <div class="icon-container" id="messages-icon-container">
            <i class="icon far fa-comments"></i>
          </div>
        </div>

        <div class="widg" id="terminal">
          <div class="icon-container" id="terminal-icon-container">
            <i class="icon far fa-terminal"></i>
          </div>
        </div>

        <div class="widg" id="editor">
          <div class="icon-container" id="editor-icon-container">
            <i class="icon far fa-code"></i>
          </div>
        </div>

      </div>
    </div>

    <div class="widg" id="play">

      <div class="icon-container" id="play-icon-container">
        <i class="fas fa-play" id="play-button"></i>
      </div>

      <div class="icon-container" id="next-icon-container">
        <i class="fas fa-step-forward" id="next-button"></i>
      </div>

      <div class="overflow-container">
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
    $( "#play-output").text("")
#
# ─── HANDLES  ─────────────────────────────────────────────────────────
#

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
  else
    $(domEl).find('#play-button').removeClass()
    $(domEl).find('#play-button').addClass('fas fa-play')


handleNext: (domEl) ->
  @run "osascript -e 'tell application \"iTunes\" to next track'"
  $(domEl).find('#play-button').removeClass()
  $(domEl).find('#play-button').addClass('fas fa-pause')
  @refresh()

afterRender: (domEl) ->


  $(domEl).on 'click', '#play-button', => @handlePlay(domEl, 'NULL')
  $(domEl).on 'click', '#next-button', => @handleNext(domEl)

#
# ─── ANIMATION  ─────────────────────────────────────────────────────────

  $(domEl).on 'click', "#home", (e) => $(domEl).find("#app-list").toggleClass('open')
  $(domEl).on 'click', '#browser', => @run "open /Applications/Safari.app"
  $(domEl).on 'click', '#mail', => @run "open /Applications/Mail.app"
  $(domEl).on 'click', '#messages', => @run "open /Applications/WhatsApp.app"
  $(domEl).on 'click', '#terminal', => @run "open /Applications/Hyper.app"
  $(domEl).on 'click', '#editor', => @run "open /Applications/Atom.app"

  $(domEl).on 'mouseover', "#app-list .icon-container", (e) => $(domEl).find( $($(e.target))).parent().addClass('pinned')
  $(domEl).on 'mouseout', "#app-list ", (e) => $(domEl).find( $($(e.target))).parent().removeClass('pinned')



toggleOption: (domEl, e, option) ->
  target = $(domEl).find( $($(e.target))).parent()

  if target.hasClass("#{ option }")
    $(target).removeClass("#{ option }")
    $(output).removeClass("#{ option }")
  else
    $(target).addClass("#{ option }")
    $(output).addClass("#{ option }")
