commands =
  activedesk: "echo $(/usr/local/bin/chunkc tiling::query -d id)"

command: "echo " +
         "$(#{ commands.activedesk}):::"

refreshFrequency: false

render: ( ) ->
  """
    <div class="container pinned" id="desktop">
      <div class="widg " id="home">
        <div class="icon-container" id="home-icon-container">
         <i class="far fa-home"></i>
        </div>
        <span class="output" id="desktop-output">1</span>
      </div>
    </div>
  """

update: ( output, domEl ) ->
  values = []
  values.desktop = output.split( /:::/g )[ 0 ]

  controls = ['desktop']
  for control in controls
    outputId = "#"+control+"-output"
    currentValue = $("#{outputId}").value
    updatedValue = values[control]

    if updatedValue != currentValue
      $("#{ outputId }").text("#{ updatedValue }")

  #$(domEl).find("#desktop-output").text("#{activedesk}")
  #$(domEl).on 'click', "#home-icon-container", (e) -> #switch to desktop 1??


  #$(domEl).find(".active").removeClass("active")
  #$(domEl).find("#desk"+activedesk).addClass('active')
