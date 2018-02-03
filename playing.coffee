#
# ──────────────────────────────────────────────────────────────────── IV -─────
#   :::::: P L A Y I N G : :  :   :    :     :        :          :
# ──────────────────────────────────────────────────────────────────────────────
#

  #
  # ─── ALL COMMANDS ───────────────────────────────────────────────────────────
  #

  commands =
    artist:     "osascript -e 'tell application \"iTunes\" to artist of current track as string'"
    title:     "osascript -e 'tell application \"iTunes\" to name of current track as string'"
    TEST: "echo hi"
    # focusedWindow: """
    #   osascript -e 'global frontApp, frontAppName, windowTitle
    #   set windowTitle to ""
    #   tell application "System Events"
    #       set frontApp to first application process whose frontmost is true
    #       set frontAppName to name of frontApp
    #       tell process frontAppName
    #           tell (1st window whose value of attribute "AXMain" is true)
    #               set windowTitle to value of attribute "AXTitle"
    #           end tell
    #       end tell
    #   end tell
    #   return frontAppName & " — " & windowTitle'
    # """

  #
  # ─── COLORS ─────────────────────────────────────────────────────────────────
  #

  colors =
    black:   "#3B4252"
    red:     "#BF616A"
    green:   "#A3BE8C"
    yellow:  "#EBCB8B"
    blue:    "#81A1C1"
    magenta: "#B48EAD"
    cyan:    "#88C0D0"
    white:   "#D8DEE9"

  #
  # ─── COMMAND ────────────────────────────────────────────────────────────────
  #

  command: "echo " +
           "$(#{ commands.artist })" +
           "  –  " +
           "$(#{ commands.title })"

  #
  # ─── REFRESH ────────────────────────────────────────────────────────────────
  #

  refreshFrequency: 128

  #
  # ─── RENDER ─────────────────────────────────────────────────────────────────
  #

  render: ( ) ->
    """
    <link rel="stylesheet" href="./font-awesome/font-awesome.min.css" />

    <div class="playing">
      <i class="fa fa-playing-maximize"></i>
      <span class="playing-output"></span>
    </div>
    """

  #
  # ─── RENDER ─────────────────────────────────────────────────────────────────
  #

  update: ( output ) ->
    $( ".playing-output" ).text( "#{ output }" )

  #
  # ─── STYLE ──────────────────────────────────────────────────────────────────
  #

  style: """
    .playing
      left: 150px
      color: #{ colors.white }
      display: inline-block
      max-width: 400px
      text-overflow: ellipsis
      overflow: hidden
      white-space: nowrap

    width: 100%
    text-overflow: ellipsis
    overflow: hidden
    white-space: nowrap
    top: 26px
    left: 100px
    font-family: 'Menlo'
    font-size: 12px
    font-smoothing: antialiasing
    z-index: 0
  """

# ──────────────────────────────────────────────────────────────────────────────
