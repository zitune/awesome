#! /bin/bash

DEST=`echo "" | dmenu -p "RSSH" -nb "#000000" -sb "#000000" -sf "#ffffff" -nf "#ffffff" -fn "-8-courier-*-*-*-*-10-*-*-*-*-*-*-*"`
if [ x$DEST != x ]
then
    eval `cat ~/.ssh/environment-alpha`
    urxvtc -e ssh root@$DEST
fi
