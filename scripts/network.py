#! /usr/bin/env python


import prettytable
import os
import sys


unit = ["B/s", "KB/s", "MB/s"]
if os.path.isfile("/tmp/network_notif.tmp"):
    exit(0)
os.system("bwm-ng -o csv -c 1 -F /tmp/network_notif.tmp")
with open("/tmp/network_notif.tmp") as f:
    network = f.read().split('\n')[:-1]

network = [x.split(';') for x in network]

x = prettytable.PrettyTable(["Interface", "Download", "Upload"], border=False,
                            header=False)
x.align["Interface"] = "l"
x.align["Download"] = "l"
x.align["Upload"] = "l"

for n in network:
    if len(n) < 4:
        continue
    interface = n[1]
    bytesOut = float(n[2])
    bytesIn = float(n[3])
    unitOut = 0
    unitIn = 0

    while bytesOut > 1024 and unitOut < 2:
        bytesOut /= 1024
        unitOut += 1
    while bytesIn > 1024 and unitIn < 2:
        bytesIn /= 1024
        unitIn += 1

    x.add_row([interface, str(int(bytesIn)) + unit[unitIn],
               str(int(bytesOut)) + unit[unitOut]])

os.remove("/tmp/network_notif.tmp")

print x
