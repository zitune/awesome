#! /bin/bash

DEST=`echo "" | dmenu -p "SSH" -nb "#000000" -nb "#ffffff" -sb "#ffffff" -sf "#000000"`
if [ x$DEST != x ]
then
    eval `cat ~/.ssh/environment-alpha`
    urxvtc -e ssh $DEST
fi
