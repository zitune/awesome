#! /bin/bash


DEST=`echo "" | dmenu -p "SSH" -nb "#000000" -nf "#ffffff" -sb "#000000" -sf "#ffffff" -fn "-8-courier-*-*-*-*-10-*-*-*-*-*-*-*"`
if [ x$DEST != x ]
then
    eval `cat ~/.ssh/environment-alpha`
    urxvtc -e ssh $DEST
fi
