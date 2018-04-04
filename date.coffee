commands =
  date  : "date +\"%a %d %b\""

command: "echo " +
         "$(#{ commands.date }):::"

refreshFrequency: '30m'

render: ( ) ->
  """
    <div class="container">
          <div class="widg" id="date">
            <span class="output nohidden" id="date-output"></span>
          </div>
    </div>
  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  values = []

  values.date = output[ 0 ]

  controls = ['date']
  for control in controls
    outputId = "#"+control+"-output"
    currentValue = $("#{outputId}").value
    updatedValue = values[control]

    if updatedValue != currentValue
      $("#{ outputId }").text("#{ updatedValue }")
