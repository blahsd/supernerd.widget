options =
  display: "applications" # applications | desktops

commands =
  running: "osascript -e 'tell application \"System Events\" to name of every process whose background only is false'"

command: "echo " +
      "$(#{ commands.running})"

refreshFrequency: false

render: ( ) ->
  """
    <div class="container" id="task-container">
    </div>

    <div class="widg" id="refresh">
      <div class="icon-container" id="browser-icon-container">
      <i class="fa fa-sync-alt"></i>
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
  return icon

update: ( output, domEl ) ->
  $("#task-container").empty()


  processes = output.split( /, / )

  for process in processes
    process = process.replace(/ /g, "")
    process = process.replace(/[0-9]/g, "")
    process = process.trim()
    processIcon = @getIcon(process)

    $( "#task-container" ).append("""
  <div class="widg " id="open /Applications/#{ process }.app">
    <div class="icon-container" id="#{ process }-icon-container">
      <i class="#{ processIcon }"></i>
    </div>
    <span  class="link closed" id="#{ process }-link">#{ process }</span>
  </div>

""")

toggleRefresh: (domEl, e) -> #doesnt work
  if $(e).hasClass('pinned')
    e.removeClass('pinned')
    stop()
  else
    e.addClass('pinned')
    start()

highlight: (domEl, e) ->
  $(e.target).parent().addClass('pinned').delay(1000)
  refresh().delay(1000)
  $(e.target).parent().removeClass('pinned')
  refresh().delay(1000)

afterRender: (domEl) ->
  #$(domEl).on 'click', ".widg", (e) -> $(e.target).parent().addClass('pinned')
  $(domEl).on 'click', ".widg", (e) -> run $(e.target).parent().parent().attr('id')
  $(domEl).on 'click', ".widg", (e) => @highlight(domEl, e)
  $(domEl).on 'click', "#refresh", (e) -> refresh() && $(e.target).parent().removeClass('pinned')
