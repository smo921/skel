#!/bin/bash

        RED='\[\033[0;31m\]'
     YELLOW='\[\033[0;33m\]'
      GREEN='\[\033[0;32m\]'
       BLUE='\[\033[0;34m\]'
  LIGHT_RED='\[\033[1;31m\]'
LIGHT_GREEN='\[\033[1;32m\]'
      WHITE='\[\033[1;37m\]'
 LIGHT_GRAY='\[\033[0;37m\]'
 COLOR_NONE='\[\033[0m\]'

	GRAY='\[\033[1;30m\]'
	NO_COLOUR='\[\033[0m\]'
	LIGHT_BLUE='\[\033[1;34m\]'


function reachable {
    uptime=`ssh -o ConnectTimeout=10 $1 uptime 2>/dev/null`
    if [ "$2" == "-v" -a $? -ne 0 ]; then
      echo "$1 Unreachable"
    else
      echo "$1 up: $uptime"
    fi
    return $?
}

function dsrm {
  docker stop $1 && \
  docker rm $1
}
