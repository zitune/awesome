#! /bin/bash


DEST=`echo "" | dmenu -p "SCREEN" -nb "#000" -nf "#fff" -sb "#fff" -sf "#000"`
if [ x$DEST != x ]
then
    urxvtc -e screen -d -R $DEST
fi
