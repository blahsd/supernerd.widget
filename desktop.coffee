commands =
  activedesk: "echo $(/usr/local/bin/chunkc tiling::query -d id)"

command: "echo " +
         "$(#{ commands.activedesk}):::"

refreshFrequency: '1s'

render: ( ) ->
  """
    <div class="container" id="desktop">
      <div class="widg open" id="home">
        <div class="icon-container pinned" id="home-icon-container">
         <i class="far fa-home"></i>
        </div>
        <span class="output" id="desktop-output">1</span>
      </div>

    </div>
  """

update: ( output, domEl ) ->
  activedesk = output.split( /:::/g )[ 0 ]
  $(domEl).find("#desktop-output").text("#{activedesk}")
  #$(domEl).on 'click', "#home-icon-container", (e) -> #switch to desktop 1??

  
  #$(domEl).find(".active").removeClass("active")
  #$(domEl).find("#desk"+activedesk).addClass('active')
