#!/usr/local/bin
current=$(/usr/local/bin/mpc status)

if [[ $current = *"playing"* ]]; then
  /usr/local/bin/mpc pause
else
  /usr/local/bin/mpc play
fi
