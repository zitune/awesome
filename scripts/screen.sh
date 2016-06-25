#! /bin/bash


DEST=`echo "" | dmenu -p "SCREEN" -nb "#000000" -nf "#ffffff" -sb "#000000" -sf "#ffffff" -fn "-8-courier-*-*-*-*-10-*-*-*-*-*-*-*"`
if [ x$DEST != x ]
then
    urxvtc -e screen -d -R $DEST
fi
