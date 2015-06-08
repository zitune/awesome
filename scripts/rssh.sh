#! /bin/bash

DEST=`echo "" | dmenu -p "RSSH" -nb "#000000" -nb "#ffffff" -sb "#ffffff" -sf "#000000"`
if [ x$DEST != x ]
then
    eval `cat ~/.ssh/environment-trantor`
    urxvtc -e ssh root@$DEST
fi
