commands =
  activedesk: "echo $(/usr/local/bin/chunkc tiling::query -d id)"

command: "echo " +
         "$(#{ commands.activedesk}):::"

refreshFrequency: '0.5s'

render: ( ) ->
  """
    <div class="container" id="desktop">
      <div class="widg">
        <i class="fa fa-window-maximize desk" id="desk1"></i>
        <i class="fa fa-window-maximize desk" id="desk2"></i>
        <i class="fa fa-window-maximize desk" id="desk3"></i>
        <i class="fa fa-window-maximize desk" id="desk4"></i>
      </div>
    </div>
  """

update: ( output, domEl ) ->
  activedesk = output.split( /:::/g )[ 0 ]
  $(domEl).find(".active").removeClass("active")
  $(domEl).find("#desk"+activedesk).addClass('active')
