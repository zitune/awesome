#! /bin/bash

export DISPLAY=":0.0"

amixer set Master playback 5%+
echo "getsound()" | awesome-client

