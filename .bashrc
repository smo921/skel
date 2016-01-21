[[ -f /etc/bash_completion ]] && . /etc/bash_completion

export TZ=EST5EDT
export PAGER=less
export EDITOR=vi
#export MANPATH=/opt/local/share/man:$MANPATH

/usr/bin/which brew > /dev/null 2>&1
HAVE_BREW=$?

if [[ $HAVE_BREW -eq 0 && -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]]; then
  GIT_PROMPT_THEME=Default
  source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
elif [ -f $HOME/.bash-git-prompt ]; then
  GIT_PROMPT_THEME=Default
  source $HOME/.bash-git-prompt
elif [ -f $HOME/.bash_functions ]; then
  . $HOME/.bash_functions
  termwide
else
  export PS1='[(\@) (\j)] \u@\h:$($HOME/.prompt)\$ '
fi

if [ -f "$HOME/.brewrc.local" ]; then
  . $HOME/.brewrc.local
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

[ -f '/usr/local/bin/hub' ] && alias git=hub
alias vi=vim
alias fixterm='resize > /tmp/blah ; . /tmp/blah ; rm /tmp/blah'
alias less='less -R'
alias xterm='xterm -bg black -fg green'
alias augtool='augtool -I $HOME/projects/augeas/lenses/'
alias ta='tmux attach -t'
alias tls='tmux list-sessions'
alias kitchen='bundle exec kitchen'
alias rake='bundle exec rake'

[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"
[ -s "$HOME/ansible/hacking/env-setup" ] && source "$HOME/ansible/hacking/env-setup" -q

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# added by travis gem
[ -f /Users/soberther/.travis/travis.sh ] && source /Users/soberther/.travis/travis.sh
