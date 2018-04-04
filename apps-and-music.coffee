options =
  focus: false
  desktop: true


commands =
  isitunesrunning: "osascript -e 'if application \"iTunes\" is running then return true'"
  isspotifyrunning: "osascript -e 'if application \"Spotify\" is running then return true'"
  isitunesplaying: "osascript -e 'if application \"iTunes\" is running then tell application \"iTunes\" to if player state is playing then return true'"
  isspotifyplaying: "osascript -e 'if application \"Spotify\" is running then tell application \"Spotify\" to if player state is playing then return true'"
  itunes: "osascript -e 'if application \"iTunes\" is running then tell application \"iTunes\" to if player state is playing then artist of current track & \" - \" & name of current track'"
  spotify: "osascript -e 'if application \"Spotify\" is running then tell application \"Spotify\" to artist of current track & \" - \" & name of current track '"
  running: "osascript -e 'tell application \"System Events\" to name of every process whose background only is false'"
  focus: "echo $(/usr/local/bin/chunkc tiling::query --window owner)"
  activedesk: "echo $(/usr/local/bin/chunkc tiling::query -d id)"


command: "echo " +
         "$(#{ commands.running }):::" +
         "$(#{ commands.focus }):::" +
         "$(#{ commands.activedesk }):::" +
         "$(#{ commands.isitunesrunning}):::" +
         "$(#{ commands.isspotifyrunning}):::" +
         "$(#{ commands.isitunesplaying}):::" +
         "$(#{ commands.isspotifyplaying}):::" +
         "$(#{ commands.itunes}):::" +
         "$(#{ commands.spotify})"

refreshFrequency: '10s'

getIcon: ( processName ) -> # No spaces, no numbers in the app name.
  icon = switch
#Apple Apps
    when processName == "?" then "fab fa-apple"
    when processName == "Finder" then "far fa-window-restore"
    when processName == "Preview" then "fas fa-eye-dropper"
    when processName == "Safari" then "fa fa-compass"
    when processName == "iTunes" then "fab fa-itunes-note"
    when processName == "Mail" then "far fa-envelope"
    when processName == "ActivityMonitor" then "far fa-window-close"

#Microsoft Office
    when processName == "MicrosoftWord" then "fas fa-file-word"
    when processName == "MicrosoftPowerPoint" then "fas fa-file-powerpoint"
    when processName == "MicrosoftExcel" then "fas fa-file-excel"
    when processName == "MicrosoftOutlook" then "fas fa-file-outlook"

#Writing / Programming
    when processName == "Atom" then "far fa-code"
    when processName == "SublimeText" then "far fa-code"
    when processName == "Hyper" then "far fa-terminal"
    when processName == "iTerm" then "far fa-terminal"
    when processName == "Terminal" then "far fa-terminal"

#Music
    when processName == "Spotify" then "fab fa-spotify"

#Messaging
    when processName == "WhatsApp" then "fab fa-whatsapp"
    when processName == "Airmail" then "far fa-envelope"
    when processName == "Spark" then "far fa-envelope"
    else "far fa-window-maximize"

  if icon == "far fa-window-maximize"
    if processName.search("Win") > -1 || processName.search("prl") > -1 #parallels apps
      icon = "fab fa-windows"

  return icon


render: ( ) ->
  """
<div class="container">
<div class="widg tray-button pinned red" id="home">
  <div class="icon-container" id="home-icon-container">
  <span id="active-desktop"></span>
  </div>
</div>

<div class="tray hidden" id="home-tray">

  <div class="widg launcher" id="open /Applications/Safari.app">
    <div class="icon-container" id="browser-icon-container">
      <i class="icon far fa-compass"></i>
      <span class="alt-text">BROWSER</span>
    </div>
  </div>

  <div class="widg launcher" id="open '/Applications/Airmail 3.app'">
    <div class="icon-container" id="mail-icon-container">
      <i class="icon far fa-envelope"></i>
      <span class="alt-text">MAIL</span>
    </div>
  </div>

  <div class="widg launcher" id="open /Applications/WhatsApp.app">
    <div class="icon-container" id="messages-icon-container">
      <i class="icon far fa-comments"></i>
      <span class="alt-text">WAPP</span>
    </div>
  </div>

  <div class="widg launcher" id="open /Applications/Hyper.app">
    <div class="icon-container" id="terminal-icon-container">
      <i class="icon far fa-terminal"></i>
      <span class="alt-text">TERM</span>
    </div>
  </div>

  <div class="widg launcher" id="open /Applications/Atom.app">
    <div class="icon-container" id="editor-icon-container">
      <i class="icon far fa-code"></i>
      <span class="alt-text">ATOM</span>
    </div>
  </div>
</div>

<div class="widg" id="play">
  <div class="icon-container" id="play-icon-container">
    <i class="fas fa-play" id="play-button"></i>
  </div>
</div>

<div class="widg" id="next">
  <div class="icon-container" id="next-icon-container">
    <i class="fas fa-step-forward" id="next-button"></i>
  </div>
</div>

<div class="widg" id="playing">
  <span class="output nohidden" id='play-output'></span>
</div>
</div>


  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )
  running = output[0]
  focus = output[1]
  activedesk = output[2]
  isitunesrunning = output[3]
  isspotifyrunning = output[4]
  isitunesplaying = output[5]
  isspotifyplaying = output[6]
  itunes = output[7]
  spotify = output[8]

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

  if options.focus is true
    $("#focus-icon").removeClass()
    $("#focus-icon").addClass("#{@getIcon(focus)}")

  if options.desktop is true
    #$("#home").removeClass()
    #$("#home").addClass("widg pinned tray-button #{ @getDesktopColor(activedesk) }")
    $("#active-desktop").text(activedesk)
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
    $(domEl).find('#play-list').removeClass("hidden")
    $(domEl).find('#play-button').addClass('fas fa-pause')
  else
    $(domEl).find('#play-button').removeClass()
    $(domEl).find('#play-button').addClass('fas fa-play')
    $(domEl).find('#play-list').addClass("hidden")


handleNext: (domEl) ->
  @run "osascript -e 'tell application \"iTunes\" to next track'"
  $(domEl).find('#play-button').removeClass()
  $(domEl).find('#play-button').addClass('fas fa-pause')
  @refresh()

afterRender: (domEl) ->
  $(domEl).on 'click', ".widg", (e) -> run $(e.target).attr('id')

  $(domEl).on 'mouseover', ".widg", (e) => if not $(domEl).find( $($(e.target))).hasClass('tray-button') then $(domEl).find($($(e.target))).addClass('pinned')
  $(domEl).on 'mouseout', ".widg", (e) => if not $(domEl).find( $($(e.target))).hasClass('tray-button') then $(domEl).find($($(e.target))).removeClass('pinned')

  $(domEl).on 'click', '#play', => @handlePlay(domEl, 'NULL')
  $(domEl).on 'click', '#next', => @handleNext(domEl)

  $(domEl).on 'click', ".tray-button", (e) => $(domEl).find(".tray").toggleClass('hidden')
