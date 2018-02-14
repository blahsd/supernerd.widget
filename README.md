# Supernerd

Sweet-ass (double!) menu bar replacement for  [Übersicht](http://tracesof.net/uebersicht/). Lots of the code in here was taken from splintah/[nerdbar.widget](https://github.com/splintah/nerdbar.widget), and supernerd definitely would not have happened without it. However I wanted to have all of the features I wanted and a bit different setup, hence supernerd. Anyways, Nerdbar is amazing, Supernerd sucks pretty bad. But it does look *pretty damn sweet*.

![supernerd_img](./screenshot.png)

This was intended to be a customisation for the personal use of yours truly, but feel free to contribute and/or recommend changes. Pull requests very welcome.

Supernerd adds a bunch of new functionality to the original it started from. In particular it adds a lot of semi-useful system monitoring indicators, and very cool icons courtesy of [fontawesome](http://fontawesome.com). Furthermore, thanks to its condensed form that keeps all the widgets in one single file, it's super super easy to customise and to theme to your liking by editing *one single file* instead of one for each widget.

# Components
I've struggled to keep the component count to a minimum. This in order to make theming possible, as each file needs its own css (damn you, Ubersicht!) and I don't want to have to edit a dozen css when I change my color scheme. Currently all of Supernerd's widgets are included in:

* bar.coffee

This other file is just to enable widgets to display icons. If you want to disable icons, just get rid of it:

* fontawesome.coffee

There is, honestly, one drawback to using one single `.coffee` for all of the display info, which is that the resource consumption will be a bit higher because all of the widgets have to refresh at the rate of the most frequently refreshing widget. Since in general I find that Ubersicht is really lightweight, I decided simply not to care.

# Displays
* **iTunes**  artist and track name of the playing track
* **Focus**   title of the window currently focues
* **Info**    Volume, wifi, battery, time and date
* **Links**   Handy app/location launcher. Comes set up with home folder, Safari, Mail, WhatsApp, Hyper and Atom, but can be configured very easily (just look for these apps' name in `display.coffee`!
* **Desktop** Graphically displays which desktop you are in
* **Sysmon**  Displays cpu, ram, and hard disk usage, with cool colors which reflect the load

# Installation
1. [Install Übersicht](http://tracesof.net/uebersicht/).

2. Clone this repository to your Übersicht widgets:

```bash
git clone https://github.com/blahsd/supernerd.widget $HOME/Library/Application\ Support/Übersicht/widgets
```

# Customisation
Supernerd is the only bar replacement that employs one single widget to display all of the informations you need. Since everybody else does it differently, it's probably a bad idea (see above). At any rate, this setup makes it super  easy to theme, because you only have to edit one file's CSS which then applies to all of the widgets.

Currently Supernerd ships with two selectable themes:
* [Snazzy](https://github.com/sindresorhus/hyper-snazzy) theme (which I recommend)
* Pro

Select them by editing the `theme` variable in `display.coffee`, or make your own css.

# Credits
* [splintah/nerdbar.widget](https://github.com/splintah/nerdbar.widget): tons of code that I took shamelessly and adapted/expanded. Definitely would not have done supernerd if it wasn't for this code.
* [herbischoff/nerbar.widget](https://github.com/herrbischoff/nerdbar.widget): most of the original nerdbar widget.
* [Pe8er/playbox.widget](https://github.com/Pe8er/Playbox.widget): the script that fetches information from iTunes, which I recklessly mutilated for use with supernerd.
* [syndresorhus/hyper-snazzy](https://github.com/sindresorhus/hyper-snazzy): I copied the sweet colors of the `snazzy` theme from here.
