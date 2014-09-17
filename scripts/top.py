#! /usr/bin/env python


import prettytable
import os
import sys


unit = ["B/s", "KB/s", "MB/s"]
if os.path.isfile("/tmp/top_notif.tmp"):
    os.remove("/tmp/top_notif.tmp")
os.system("ps ax --no-headers -o \"%C;%p;%c\" | sed 's/ //g' > /tmp/top_notif.tmp")
with open("/tmp/top_notif.tmp") as f:
    top = f.read().split('\n')

top = [x.split(';') for x in top]
for i in xrange(len(top)):
    if len(top[i]) < 3:
        continue
    top[i][0] = float(top[i][0])
top.sort()
top.reverse()

x = prettytable.PrettyTable(["CPU", "PID", "Command"], border=False,
                            header=False)
x.align["CPU"] = "l"
x.align["PID"] = "l"
x.align["Command"] = "l"

for n in top:
    if len(n) < 3:
        continue
    if len(list(x)) > 10:
        break
    x.add_row([n[0], n[1], n[2]])

os.remove("/tmp/top_notif.tmp")

print x
