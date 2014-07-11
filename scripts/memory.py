#! /usr/bin/env python


import prettytable


with open("/proc/meminfo") as f:
    meminfo = f.read().split('\n')

memtotal, memfree, buffers, cached = None, None, None, None
for line in meminfo:
    if line.startswith('MemTotal:'):
        memtotal = int(line.split(' ')[-2]) / 1024
    if line.startswith('MemFree:'):
        memfree = int(line.split(' ')[-2]) / 1042
    if line.startswith('Buffers:'):
        buffers = int(line.split(' ')[-2]) / 1042
    if line.startswith('Cached:'):
        cached = int(line.split(' ')[-2]) / 1042

x = prettytable.PrettyTable(["Type", "Value"], border=False, header=False)
x.align["Type"] = "l"
x.align["Value"] = "l"
if memtotal:
    x.add_row(["Total Memory", memtotal])
if memfree:
    x.add_row(["Free Memory", memfree])
if buffers:
    x.add_row(["Buffers", buffers])
if cached:
    x.add_row(["Cached", cached])

print x
