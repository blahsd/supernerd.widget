# Supernerd

Sweet-ass (double!) menu bar replacement for  [Übersicht](http://tracesof.net/uebersicht/). Lots of the code in here was taken from splintah/[nerdbar.widget](https://github.com/splintah/nerdbar.widget), and supernerd definitely would not have happened without it. However I wanted to have all of the features I wanted and a bit different setup, hence supernerd. Anyways, Nerdbar is amazing, Supernerd sucks pretty bad. But it does look *pretty damn sweet*.

![supernerd_img](./screenshot.png)

This was intended to be a customisation for the personal use of yours truly, but feel free to contribute and/or recommend changes. Pull requests very welcome.

Supernerd adds a bunch of new functionality to the original it started from. In particular it adds a lot of semi-useful system monitoring indicators, and very cool icons courtesy of [fontawesome](http://fontawesome.com). Furthermore, thanks to its condensed form that keeps all the widgets in one single file, it's super super easy to customise and to theme to your liking by editing *one single file* instead of one for each widget.

# Displays
* **Player**  artist and track name of the playing track (works for itunes, spotify)
* **Focus**   title of the window currently focues [temporarily disabled]
* **Info**    Volume, wifi, battery, time and date
* **Links**   Handy app/location launcher. Comes set up with home folder, Safari, Mail, WhatsApp, Hyper and Atom, but can be configured very easily (just take a look in `app-launcher.coffee`!
* **Desktop** Graphically displays which desktop you are in [temporarily disabled]
* **Sysmon**  Displays cpu, ram, and hard disk usage, with cool colors which reflect the load

# Installation
1. [Install Übersicht](http://tracesof.net/uebersicht/).

2. Clone this repository to your Übersicht widgets:

```bash
git clone https://github.com/blahsd/supernerd.widget $HOME/Library/Application\ Support/Übersicht/widgets
```

# Customisation
Thanks to the amazing work of [davidlday](https://github.com/davidlday) Supernerd is now the only menubar replacement which employs a single .css for the entire system, while also having each widget coded in a separate file. This allows for an amazing ease of customisation of the widget displays, which can be handled, moved, disabled, etc. one by one, while also at the same time allowing the modifications of one single .css to affect the entire display.

Supernerd is also fully compatible with wal / pywal, and if you select the correspondent .css, named colors-wal.css, for import in the bar-top.coffee component, it will automatically adjust to wal's colors.

Currently Supernerd ships with two selectable themes:
* Snazzy
* Pro

Select them by editing the `theme` variable in `bar-top.coffee`, or make your own css.

# Credits
* [splintah/nerdbar.widget](https://github.com/splintah/nerdbar.widget): tons of code that I took shamelessly and adapted/expanded. Definitely would not have done supernerd if it wasn't for this code.
* [davidlday/supernerd.widget](https://github.com/davidlday/supernerd.widget): this man gave us CSS separated from the code logic. He made it possible to have each widget split in a different file while maintaining the level of customisability we're used to. No way to thank him enough.
* [herbischoff/nerbar.widget](https://github.com/herrbischoff/nerdbar.widget): most of the original nerdbar widget.
* [Pe8er/playbox.widget](https://github.com/Pe8er/Playbox.widget): the script that fetches information from iTunes, which I recklessly mutilated for use with supernerd.
* [syndresorhus/hyper-snazzy](https://github.com/sindresorhus/hyper-snazzy): I copied the sweet colors of the `snazzy` theme from here.
* [Wallpaper] (https://unsplash.com/photos/5KNecHxjTnI)
