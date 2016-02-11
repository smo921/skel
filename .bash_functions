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
    hname=`ssh -o ConnectTimeout=10 $1 hostname 2>/dev/null`
    ##if [ $? -ne 0 ]; then echo "$1 Unreachable"; fi
    return $?
}

