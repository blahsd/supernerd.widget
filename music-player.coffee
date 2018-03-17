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
    <div class="container">

      <div class="widg pinned" id="home">
        <div class="icon-container" id="home-icon-container">
         <i class="far fa-home"></i>
        </div>
      </div>
          <div class="container">
            <div class="widg" id="browser">
              <div class="icon-container" id="browser-icon-container">
              <i class="far fa-compass"></i>
              </div>
              <span id="browser-link" class="link closed">web</span>
            </div>
            <div class="widg" id="mail">
              <div class="icon-container" id="music-icon-container">
              <i class="far fa-envelope"></i>
              </div>
              <span id="mail-link" class="link closed">mail</span>
            </div>
            <div class="widg" id="messages">
              <div class="icon-container" id="music-icon-container">
              <i class="far fa-comments"></i>
              </div>
              <span id="messages-link" class="link closed">msg</span>
            </div>
            <div class="widg" id="terminal">
              <div class="icon-container" id="music-icon-container">
              <i class="far fa-terminal"></i>
              </div>
              <span id="terminal-link" class="link closed">zsh</span>
            </div>
            <div class="widg" id="editor">
              <div class="icon-container" id="music-icon-container">
              <i class="far fa-code"></i>
              </div>
              <span id="editor-link" class="link closed">atom</span>
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
  $(domEl).on 'click', '#home', => @run "open ~/"

  $(domEl).on 'click', '#play-button', => @handlePlay(domEl, 'NULL')
  $(domEl).on 'click', '#next-button', => @handleNext(domEl)

#
# ─── ANIMATION  ─────────────────────────────────────────────────────────
#
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
