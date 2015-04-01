[[ -f /etc/bash_completion ]] && . /etc/bash_completion

export TZ=EST5EDT
export PAGER=less
export EDITOR=vi
#export MANPATH=/opt/local/share/man:$MANPATH

if [ -f $HOME/.bash_functions ]; then
	. $HOME/.bash_functions
	termwide
else
	export PS1='[(\@) (\j)] \u@\h:$($HOME/.prompt)\$ '
fi




if [ `uname` == "CYGWIN_NT-5.1" ]; then
	alias ls='ls --color'
	TERM=xterm
elif [ `uname` == 'Linux' ]; then
	alias ls='ls --color'
	TERM=xterm
elif [ `uname` == 'Darwin' ]; then
	alias ls='ls -G'
	TERM=xterm
elif [ `uname` == 'FreeBSD' ]; then
	alias ls='ls -G'
	TERM=xterm-color
else
	TERM=vt100
fi

export TERM

alias vi=vim
alias fixterm='resize > /tmp/blah ; . /tmp/blah ; rm /tmp/blah'
alias less='less -R'
alias xterm='xterm -bg black -fg green'
alias augtool='augtool -I $HOME/projects/augeas/lenses/'
alias ta='tmux attach -t'
alias tls='tmux list-sessions'

[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"
[ -s "$HOME/ansible/hacking/env-setup" ] && source "$HOME/ansible/hacking/env-setup" -q


