#! /usr/bin/env python


import prettytable
import sys

lines = sys.argv[1].split('\n')
if lines[0].startswith(';'):
    titles = xrange(len(lines[0].split(';')) - 1)
else:
    titles = xrange(len(lines[0].split(';')))
x = prettytable.PrettyTable(titles, border=False, header=False)
for t in titles:
    x.align[str(t)] = "l"

for l in lines:
    if l != '':
        if l.startswith(';'):
            x.add_row(l[1:].split(';'))
        else:
            x.add_row(l.split(';'))

print x
