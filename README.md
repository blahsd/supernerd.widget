# supernerd.widget

Menu bar 'replacement' for  [Übersicht](http://tracesof.net/uebersicht/). Originally built-up over herbischoff/[nerbar.widget](https://github.com/herrbischoff/nerdbar.widget). Nerdbar is amazing, supernerd sucks pretty bad. However, nerbar relied on kwm, while I'm now using [chunkwm](https://github.com/koekeishiya/chunkwm), its spiritual successor, which breaks a lot of nerdbar's functions. Also, supernerd looks *pretty damn sweet*.

![supernerd_img](./screenshot.png)

Right now I'm making this just for my own use but feel free to contribute and or recommend changes. Pull requests very welcome.

Supernerd adds a bunch of new functionality to the original it started from. In particular it adds a lot of semi-useful system monitoring indicators, and very cool icons courtesy of [fontawesome](http://fontawesome.com). Furthermore, thanks to its condensed form that keeps all the widgets in one single file, it's super super easy to customise and to theme to your liking by editing *one single file* instead of one for each widget.

# Components

There's no components anymore! Isn't that fantastic? There is only one file that you have to deal with, which holds all of the stats you need in a nifty, dark, round-bordered bar:

* bar.coffee

This other file is just to enable widgets to display icons. If you want to disable icons, just get rid of it:

* fontawesome.coffee

Sometime down the road I might add another component to have a second, separate bar.

# Installation
1. [Install Übersicht](http://tracesof.net/uebersicht/).

2. Clone this repository to your Übersicht widgets:

```bash
git clone https://github.com/blahsd/supernerd.widget $HOME/Library/Application\ Support/Übersicht/widgets
```

3. Profit.

# Customisation
Supernerd is the only bar replacement that employs one single widget to display all of the informations you need. Since everybody else does it differently, it might be a bad idea, but I don't really know why, so I don't care. At any rate, having it this way probably reduces over head, and most importantly makes it super easy to theme, because you only have to edit one file's CSS which then applies to all of the widgets.

Supernerds ships themed with the colours of the [Snazzy](https://github.com/sindresorhus/hyper-snazzy) theme (which I recommend).

# Credits
* [herbischoff/nerbar.widget](https://github.com/herrbischoff/nerdbar.widget): most of the original styling
* [Pe8er/playbox.widget](https://github.com/Pe8er/Playbox.widget): the script that fetches information from iTunes, which I recklessly mutilated for use with supernerd
* [syndresorhus/hyper-snazzy](https://github.com/sindresorhus/hyper-snazzy): I copied the sweet colors from here
