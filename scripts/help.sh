#! /bin/bash

cat /home/hybris/.config/awesome/keys.lua | grep '^\-\-' | sed 's/^--//' | sed 's/^ //'
cat
