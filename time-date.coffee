
commands =
  time: "date +\"%H:%M\""
  date  : "date +\"%a %d %b\""


command: "echo " +
         "$(#{ commands.time }):::" +
         "$(#{ commands.date }):::"

refreshFrequency: '10s'

render: ( ) ->
  """
    <div class="container">

          <div class="widg open" id="time">
            <span class="output" id="time-output"></span>
          </div>

          <div class="icon-container" id="">|
          </div>

          <div class="widg open" id="date">
            <span class="output" id="date-output"></span>
          </div>




    </div>
  """

update: ( output, domEl ) ->
  output = output.split( /:::/g )

  values = []

  values.time = output[ 0 ]+' - CET'
  values.date = output[ 1 ]

  controls = ['time','date']
  for control in controls
    outputId = "#"+control+"-output"
    currentValue = $("#{outputId}").value
    updatedValue = values[control]

    if updatedValue != currentValue
      $("#{ outputId }").text("#{ updatedValue }")
