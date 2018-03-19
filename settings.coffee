refreshFrequency = false

style: """
    @import url(https://use.fontawesome.com/releases/v5.0.6/css/all.css);
    @import url(supernerd.widget/styles/colors-wal.css);
    @import url(supernerd.widget/styles/applied.css);
"""

command: "osascript -e 'tell application \"$(ps ax | grep sicht | awk \'{print $5}\' | head -1 | cut -d/ -f3 | cut -d. -f1)\" to refresh'"

render: ( ) ->
  """
    <div class="container" id="settings">
      <div class="widg opt" id="mono">
        <div class="icon-container">
          mono
        </div>
      </div>

      <div class="widg opt" id="default">
        <div class="icon-container">
          default
        </div>
      </div>

      <div class="widg opt" id="float">
        <div class="icon-container">
          float
        </div>
      </div>
    </div>

    <div class="container" id="settings">
      <div class="widg" id="mono">
        <div class="icon-container">
          mono
        </div>
      </div>

      <div class="widg" id="split">
        <div class="icon-container">
          split
        </div>
      </div>

      <div class="widg" id="float">
        <div class="icon-container">
          float
        </div>
      </div>
    </div>
  """

update: ( output, domEl ) ->
  output = output

afterRender: (domEl) ->
  $(domEl).on 'mouseover', ".widg", (e) => $(domEl).find($($(e.target))).addClass('pinned')
  $(domEl).on 'mouseout', ".widg", (e) => $(domEl).find($($(e.target))).removeClass('pinned')

  $(domEl).on 'click', ".opt", (e)  => $(domEl).find($($(e.target))).toggleClass('pinned')

  $(domEl).on 'click', ".opt", (e) => @run "sh $HOME/Library/Application\\ Support/Übersicht/widgets/supernerd.widget/scripts/selectstyle.sh #{ $(domEl).find($($(e.target))).attr('id') }"
  $(domEl).on 'click', ".opt", (e) => @refresh()
