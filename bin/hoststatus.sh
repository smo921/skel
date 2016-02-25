#!/usr/bin/env bash

ping -c 2 $1 2>&1 > /dev/null
if [ $? -eq 0 ]; then
  UTIME=$(ssh $1 uptime 2>/dev/null)
  echo "$1 up $UTIME" 
else
  echo "$1 down"
fi
