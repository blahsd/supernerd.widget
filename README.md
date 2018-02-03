# supernerd.widget

Menu bar 'replacement', created using [Übersicht](http://tracesof.net/uebersicht/). This was built-up over herbischoff/[nerbar.widget](https://github.com/herrbischoff/nerdbar.widget). Nerdbar is amazing, supernerd sucks pretty bad. However, nerbar relied on kwm, while I'm now using [chunkwm](https://github.com/koekeishiya/chunkwm), its spiritual successor, which breaks a lot of nerdbar's functions.

Right now I'm making this just for my own use but feel free to contribute and or recommend changes.

# Components

* background.coffee:   draws a background bar in which your widgets should live
* focused-window.coffee:  displays that process that owns the currently focused window
* playing.coffee:     displays artist and title of the track currently playing in iTunes. Sometimes fucks up royally and just displays weird babble.
* info.coffee:        currently displays only the time. 

# Installation
[Install Übersicht](http://tracesof.net/uebersicht/).

Clone this repository to your Übersicht widgets:

```bash
git clone https://github.com/blahsd/supernerd.widget $HOME/Library/Application\ Support/Übersicht/widgets
```
