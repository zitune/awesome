#!/bin/bash

xrandr | grep "HDMI1 connected"
if [[ $? == 0 ]]; then
  # is connected
  xrandr --output HDMI1 --left-of LVDS1 --auto
else
  # not connected
  xrandr --output HDMI1 --auto
fi

xrandr | grep "VGA1 connected"
if [[ $? == 0 ]]; then
  # is connected
  xrandr --output VGA1 --left-of LVDS1 --auto
else
  # not connected
  xrandr --output VGA1 --auto
fi
