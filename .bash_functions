#!/bin/bash

#   termwide prompt
#      by Giles - created 2 November 98
#
#   The idea here is to have the upper line of this two line prompt 
#   always be the width of your term.  Do this by calculating the
#   width of the text elements, and putting in fill as appropriate
#   or left-truncating $PWD.
#
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



function prompt_command {
TERMWIDTH=${COLUMNS}

#   Calculate the width of the prompt:
hostnam=$(echo $HOSTNAME | sed -e "s/[\.].*//")
#hostnam=$(echo -n $HOSTNAME | sed -e "s/[\.].*//")

#   "whoami" and "pwd" include a trailing newline
#usernam=$(who am i| awk '{print $1}')
usernam=$LOGNAME


let usersize=$(echo -n $usernam | wc -c | tr -d " ")
###parse_git_branch
newPWD="${PWD}"
let pwdsize=$(echo -n ${newPWD} | wc -c | tr -d " ")
#   Add all the accessories below ...
let promptsize=$(echo -n "--(${usernam}@${hostnam})---(${newPWD})--" \
                 | wc -c | tr -d " ")


##let promptsize+=${GIT_PROMPT_LEN}


let fillsize=${TERMWIDTH}-${promptsize}
fill=""
while [ "$fillsize" -gt "0" ] 
do 
   fill="${fill}-"
   let fillsize=${fillsize}-1
done

if [ "$fillsize" -lt "0" ]
then
   let cut=3-${fillsize}
   newPWD="...$(echo -n $newPWD | sed -e "s/\(^.\{$cut\}\)\(.*\)/\2/")"
fi
}


function prompt_color {
# System wide functions and aliases
# Environment stuff goes in /etc/profile

# For some unknown reason bash refuses to inherit
# PS1 in some circumstances that I can't figure out.
# Putting PS1 here ensures that it gets loaded every time.

# Set up prompts. Color code them for logins. Red for root, white for 
# user logins, green for ssh sessions, cyan for telnet,
# magenta with red "(ssh)" for ssh + su, magenta for telnet.
	local WHITE="\[\033[1;37m\]"
	local RED="\[\033[1;31m\]"
	local GREEN="\[\033[0;32m\]"
	local YELLOW="\[\033[0;33m\]"
	local BLUE="\[\033[0;34m\]"
	local PURPLE="\[\033[0;35m\]"
	local NO_COLOUR="\[\033[00m\]"

	PROMPT_COLOR="$WHITE"
	SEP_COLOR="$BLUE"
	TXT_COLOR="$YELLOW"

	if [ `uname` = "SunOS" ]; then
		THIS_TTY=`/usr/bin/who am i | awk '{print $2}'`
	else
		THIS_TTY=tty`ps aux | grep $$ | grep [b]ash | awk '{ print $7 }'`
	fi

	SESS_SRC=`who | grep $THIS_TTY | awk '{ print $6 }'`

	SSH_FLAG=0
	SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
	if [ $SSH_IP ] ; then
  		SSH_FLAG=1
	fi
	SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
	if [ $SSH2_IP ] ; then
  		SSH_FLAG=1
	fi
	if [ $SSH_FLAG -eq 1 ] ; then
  		CONN=ssh
	elif [ -z $SESS_SRC ] ; then
  		CONN=lcl
	elif [ $SESS_SRC = "(:0.0)" -o $SESS_SRC = "" ] ; then
  		CONN=lcl
	else
  		CONN=tel
	fi

	# Okay...Now who we be?
	#if [ `uname` = "SunOS" -a `/usr/bin/who am i | awk '{print $1}'` = "root" ] ; then
	if [ $LOGNAME = "root" ] ; then
  		USR=priv
	else
  		USR=nopriv
	fi

	#Set some prompts...
	if [ $CONN = lcl -a $USR = nopriv ] ; then
  #		PS1="[\u \W]\\$ "
		PROMPT_COLOR="$WHITE"
		SEP_COLOR="$BLUE"
		TXT_COLOR="$GREEN"
	elif [ $CONN = lcl -a $USR = priv ] ; then
  #		PS1="\[\033[01;31m\][\w]\\$\[\033[00m\] "
		PROMPT_COLOR=$RED
		SEP_COLOR=$BLUE
		TXT_COLOR=$RED
	elif [ $CONN = tel -a $USR = nopriv ] ; then
  #		PS1="\[\033[01;34m\][\u@\h \W]\\$\[\033[00m\] "
		PROMPT_COLOR=$WHITE
		SEP_COLOR=$YELLOW
		TXT_COLOR=$BLUE
	elif [ $CONN = tel -a $USR = priv ] ; then
  #		PS1="\[\033[01;30;45m\][\u@\h \W]\\$\[\033[00m\] "
		PROMPT_COLOR=$RED
		SEP_COLOR=$YELLOW
		TXT_COLOR=$PURPLE
	elif [ $CONN = ssh -a $USR = nopriv ] ; then
  #		PS1="\[\033[01;32m\][\u@\h \W]\\$\[\033[00m\] "
		PROMPT_COLOR=$WHITE
		SEP_COLOR=$BLUE
		TXT_COLOR=$YELLOW
	elif [ $CONN = ssh -a $USR = priv ] ; then
  #		PS1="\[\033[01;35m\][\u@\h \W]\\$\[\033[00m\] "
		PROMPT_COLOR=$RED
		SEP_COLOR=$YELLOW
		TXT_COLOR=$PURPLE
	fi
}



PROMPT_COMMAND=prompt_command

function termwide {

	local GRAY="\[\033[1;30m\]"
	local LIGHT_GRAY="\[\033[0;37m\]"
	local WHITE="\[\033[1;37m\]"
	local NO_COLOUR="\[\033[0m\]"

	local LIGHT_BLUE="\[\033[1;34m\]"
	local YELLOW="\[\033[1;33m\]"


	prompt_color

	#case $TERM in
	#    xterm*)
	#        TITLEBAR='\[\033]0;\u@\h:\w\007\]'
	#        ;;
	#    *)
	#        TITLEBAR=""
	#        ;;
	#esac

	#PS1="$TITLEBAR\
PS1="$TXT_COLOR-$SEP_COLOR-(\
$TXT_COLOR\${usernam}$SEP_COLOR@$TXT_COLOR\${hostnam}\
${SEP_COLOR})-${TXT_COLOR}-\${fill}${SEP_COLOR}-(\
$TXT_COLOR\${newPWD}\${GIT_PROMPT}\
$SEP_COLOR)-$TXT_COLOR-\
\n\
$TXT_COLOR-$SEP_COLOR-(\
$TXT_COLOR\$(date -u +%H:%M)$SEP_COLOR:$TXT_COLOR\$(date \"+%a,%d %b %y\")\
$SEP_COLOR:$PROMPT_COLOR\$$SEP_COLOR)-\
$TXT_COLOR-\
$NO_COLOUR " 

echo "$PS1"

PS2="$SEP_COLOR-$TXT_COLOR-$TXT_COLOR-$NO_COLOUR "
}


########################################################################
# Matthew's Git Bash Prompt
########################################################################
function parse_git_branch {
  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  branch_pattern="^# On branch ([^${IFS}]*)"
  remote_pattern="# Your branch is (.*) of"
  diverge_pattern="# Your branch and (.*) have diverged"
  GIT_PROMPT="" 
  GIT_PROMPT_LEN=0
  if [[ ! ${git_status}} =~ "working directory clean" ]]; then
    state="${RED}⚡"
    let GIT_PROMPT_LEN+=1
  fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="${YELLOW}↑"
      remote="↑"
      let GIT_PROMPT_LEN+=1
    else
      remote="${YELLOW}↓"
      remote="↓"
      let GIT_PROMPT_LEN+=1
    fi
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${YELLOW}↕"
    remote="↕"
    let GIT_PROMPT_LEN+=1
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
    ##echo " (${branch})${remote}${state}"
    GIT_PROMPT=" (${branch})${remote}${state}"
    let GIT_PROMPT_LEN+=${#branch}+4
  fi
}

function git_dirty_flag {
  git status 2> /dev/null | grep -c : | awk '{if ($1 > 0) print "⚡"}'
}

function prompt_func() {
    previous_return_value=$?;
    #The lowercase w is the full current working directory
    #prompt="${TITLEBAR}${BLUE}[${RED}\w${GREEN}$(parse_git_branch)${BLUE}]${COLOR_NONE}"
    
    #Capital W is just the trailing part of the current working directory
    prompt="${TITLEBAR}${BLUE}[${RED}\W${GREEN}$(parse_git_branch)${BLUE}]${COLOR_NONE}"
    
    if test $previous_return_value -eq 0
    then
        PS1="${prompt}> "
    else
        PS1="${prompt}${RED}>${COLOR_NONE} "
    fi
}

##PROMPT_COMMAND=prompt_func



function reachable {
    hname=`ssh -o ConnectTimeout=10 $1 hostname 2>/dev/null`
    ##if [ $? -ne 0 ]; then echo "$1 Unreachable"; fi
    return $?
}

alias myip='echo -e "\n$(curl -s ifconfig.me/ip)\n"'
