#!/bin/bash
cd $HOME/Library/Application\ Support/Übersicht/widgets/supernerd.widget/

cp "styles/$1.css" 'styles/applied.css'

osascript scripts/refresh.applescript
