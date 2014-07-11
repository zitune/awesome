#! /usr/bin/env python

import sys
import os
import urllib2


term = "urxvtc -e"
browser = "firefox"
player = "cvlc"
image = "feh"
gif = "animate -loop 0"

if __name__ == "__main__":
    if len(sys.argv) != 2:
        exit(1)
    url = sys.argv[1]
    default_cmd = browser + ' "' + url + '"' + ' > /dev/null 2>&1'

    if url.startswith("http://www.youtube.com/watch?") or \
            url.startswith("https://www.youtube.com/watch?") or \
            url.startswith("http://www.dailymotion.com/video/"):
            # doesn't work on dailymotion https
        os.system(term + ' ' + player + ' "' + url + '" || ' + default_cmd)
    elif url.endswith(".jpg") or \
            url.endswith(".png") or \
            url.endswith(".JPG") or \
            url.endswith(".PNG"):
        os.system(term + ' ' + image + ' "' + url + '" || ' + default_cmd)
    elif url.endswith(".gif") or \
            url.endswith(".GIF"):
        os.system(term + ' ' + gif + ' "' + url + '" || ' + default_cmd)
    elif ((url.startswith("https://trac.") or
           "trac.bearstech.com" in url) and
          url.split('/')[-2] == 'ticket'):
        fields = url.split('/')
        host = fields[2]
        ticket = fields[-1].split("#")
        if len(ticket) > 1:
            os.system(term + ' /home/hybris/scripts/trac.sh -s ' + host +
                      ' changelog ' + str(ticket[0]))
        os.system(term + ' /home/hybris/scripts/trac.sh -s ' + host + ' view '
                  + str(ticket[0]))
        os.system(default_cmd)
    else:
        os.system(default_cmd)
