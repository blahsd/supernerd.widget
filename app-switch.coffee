options =
  display: "applications" # applications | desktops

commands =
  running: "osascript -e 'tell application \"System Events\" to name of every process whose background only is false'"
  focus: "echo $(/usr/local/bin/chunkc tiling::query --window owner)"

command: "echo " +
      "$(#{ commands.running }):::" +
      "$(#{ commands.focus })"

refreshFrequency: false

render: ( ) ->
  """
  <div class="container launcher">
    <div class="widg" id="app-launcher">

      <div class="widg pinned red" id="home">
        <div class="icon-container" id="home-icon-container">
         <i class="fab fa-apple" id="focus-icon"></i>
        </div>
      </div>

      <div class="container hidden" id="app-list">
        <div class='widg open' id='task'>
          <div class="widg container" id="task-container">
          </div>
        </div>
      </div>

    </div>
  </div>

  """

getIcon: ( processName ) -> # No spaces, no numbers in the app name.
  icon = switch
#Apple Apps
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

update: ( output, domEl ) ->
  $("#task-container").empty()
  output = output.split( /:::/g )

  processes = output[ 0 ].split( /, / )
  focus = output[ 1 ].split( /-/g )

  processes = ['Atom','Hyper','Safari','iTunes']    #Get rid of this to get a task manager
#  instead of an app launcher

  for process in processes
    process = process.replace(/ /g, "")
    process = process.replace(/[0-9]/g, "")
    process = process.trim()
    processIcon = @getIcon(process)
    $( "#task-container" ).append("""
  <div class="widg" id="open /Applications/#{ process }.app">
    <div class="icon-container" id="#{ process }-icon-container">
      <i class="#{ processIcon }"></i>
    </div>
    <span class="link hidden textonly" id="#{ process }-link">#{ process }</span>
  </div>
    """)
  if focus[0].trim()=='?'
    return
  else
    #$(domEl).find("#"+"#{focus[0].trim()}-link").parent().addClass('pinned')   #comment out this for the task manager

toggleRefresh: (domEl, e) -> #doesnt work
  if $(e).hasClass('pinned')
    e.removeClass('pinned')
    stop()
  else
    e.addClass('pinned')
    start()

highlight: (domEl, e) ->
  $(e.target).parent().addClass('pinned')
  refresh().delay(1000)
  $(e.target).parent().removeClass('pinned')
  refresh().delay(1000)

afterRender: (domEl) ->
  $(domEl).on 'click', "#home", => $(domEl).find("#app-list").toggleClass('open')

  $(domEl).on 'click', ".launcher", (e) -> run $(e.target).attr('id')

  $(domEl).on 'mouseover', "#app-list", (e) => $(domEl).find($($(e.target))).addClass('pinned')
  $(domEl).on 'mouseout', "#app-list", (e) => $(domEl).find($($(e.target))).removeClass('pinned')
