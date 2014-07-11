#!/bin/bash

ps aux | grep "$1" | grep -v notlaunched | grep -v grep > /dev/null
ret=$((1 - $?))

exit $ret
