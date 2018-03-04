
refreshFrequency: false

render: ( ) ->
  """
    <div class="container">
      <div class="widg" id="home">
        <i class="fas fa-home"></i>
        <span id="home-link" class="closed">~/</span>
      </div>
      <div class="widg" id="browser">
        <i class="far fa-compass"></i>
        <span id="browser-link" class="closed">web</span>
      </div>
      <div class="widg" id="mail">
        <i class="far fa-envelope"></i>
        <span id="mail-link" class="closed">mail</span>
      </div>
      <div class="widg" id="messages">
        <i class="far fa-comments"></i>
        <span id="messages-link" class="closed">msg</span>
      </div>
      <div class="widg" id="terminal">
        <i class="far fa-terminal"></i>
        <span id="terminal-link" class="closed">zsh</span>
      </div>
      <div class="widg" id="editor">
        <i class="far fa-code"></i>
        <span id="editor-link" class="closed">atom</span>
      </div>
    </div>
  """

afterRender: (domEl) ->
    $(domEl).on 'mouseover', '#home', => $(domEl).find('#home-link').addClass('open')
    $(domEl).on 'mouseout', '#home', => $(domEl).find('#home-link').removeClass('open')

    $(domEl).on 'mouseover', '#browser', => $(domEl).find('#browser-link').addClass('open')
    $(domEl).on 'mouseout', '#browser', => $(domEl).find('#browser-link').removeClass('open')

    $(domEl).on 'mouseover', '#mail', => $(domEl).find('#mail-link').addClass('open')
    $(domEl).on 'mouseout', '#mail', => $(domEl).find('#mail-link').removeClass('open')

    $(domEl).on 'mouseover', '#messages', => $(domEl).find('#messages-link').addClass('open')
    $(domEl).on 'mouseout', '#messages', => $(domEl).find('#messages-link').removeClass('open')

    $(domEl).on 'mouseover', '#terminal', => $(domEl).find('#terminal-link').addClass('open')
    $(domEl).on 'mouseout', '#terminal', => $(domEl).find('#terminal-link').removeClass('open')

    $(domEl).on 'mouseover', '#editor', => $(domEl).find('#editor-link').addClass('open')
    $(domEl).on 'mouseout', '#editor', => $(domEl).find('#editor-link').removeClass('open')

    $(domEl).on 'mouseover', '#home', => $(domEl).find('#home').addClass('open')
    $(domEl).on 'mouseout', '#home', => $(domEl).find('#home').removeClass('open')

    $(domEl).on 'mouseover', '#browser', => $(domEl).find('#browser').addClass('open')
    $(domEl).on 'mouseout', '#browser', => $(domEl).find('#browser').removeClass('open')

    $(domEl).on 'mouseover', '#mail', => $(domEl).find('#mail').addClass('open')
    $(domEl).on 'mouseout', '#mail', => $(domEl).find('#mail').removeClass('open')

    $(domEl).on 'mouseover', '#messages', => $(domEl).find('#messages').addClass('open')
    $(domEl).on 'mouseout', '#messages', => $(domEl).find('#messages').removeClass('open')

    $(domEl).on 'mouseover', '#terminal', => $(domEl).find('#terminal').addClass('open')
    $(domEl).on 'mouseout', '#terminal', => $(domEl).find('#terminal').removeClass('open')

    $(domEl).on 'mouseover', '#editor', => $(domEl).find('#editor').addClass('open')
    $(domEl).on 'mouseout', '#editor', => $(domEl).find('#editor').removeClass('open')

    $(domEl).on 'click', '#home', => @run "open ~/"
    $(domEl).on 'click', '#browser', => @run "open /Applications/Safari.app"
    $(domEl).on 'click', '#mail', => @run "open /Applications/Mail.app"
    $(domEl).on 'click', '#messages', => @run "open /Applications/WhatsApp.app"
    $(domEl).on 'click', '#terminal', => @run "open /Applications/Hyper.app"
    $(domEl).on 'click', '#editor', => @run "open /Applications/Atom.app"
