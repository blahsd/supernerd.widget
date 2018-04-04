#!/usr/bin/env bash
current=$(/usr/local/bin/mpc status)

if [[ $current = *"playing"* ]]; then
  echo true
else
  echo false
fi
