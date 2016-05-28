#! /usr/bin/env python

import prettytable
from subprocess import Popen, PIPE

MOUNTPOINTS = {'/': None,
               '/boot': None,
               '/home/hybris': None,
               '/home/hybris/dev': None,
               '/home/hybris/Documents': None,
               '/home/hybris/Downloads': None,
               '/home/hybris/Mail': None,
               '/home/hybris/Pictures': None}

p = Popen("df", stdout=PIPE, shell=True)
(output, err) = p.communicate()

for line in output.split('\n'):
    for m in MOUNTPOINTS.keys():
        if line.endswith(m):
            MOUNTPOINTS[m] = line.split(' ')[-2]

x = prettytable.PrettyTable(["Mount", "Used"], border=False, header=False)
x.align["Mount"] = "l"
x.align["Used"] = "l"
m = MOUNTPOINTS.keys()
m.sort()
for k in m:
    if MOUNTPOINTS[k]:
        x.add_row([k, MOUNTPOINTS[k]])

print x
