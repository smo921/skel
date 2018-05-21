[[ -f /etc/bash_completion ]] && . /etc/bash_completion

export TZ=EST5EDT
export PAGER=less
export EDITOR=vi
#export MANPATH=/opt/local/share/man:$MANPATH

/usr/bin/which brew > /dev/null 2>&1
HAVE_BREW=$?

[ -f $HOME/.bash_functions ] && . $HOME/.bash_functions

if [[ $HAVE_BREW -eq 0 && -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]]; then
  GIT_PROMPT_THEME=Custom
  source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
elif [ -f $HOME/.bash-git-prompt/gitprompt.sh ]; then
  GIT_PROMPT_THEME=Custom
  source $HOME/.bash-git-prompt/gitprompt.sh
elif [ -f $HOME/.bash_prompt ]; then
  . $HOME/.bash_prompt
  termwide
else
  export PS1='[(\@) (\j)] \u@\h:$($HOME/.prompt)\$ '
fi

if [ -f "$HOME/.brewrc.local" ]; then
  . $HOME/.brewrc.local
fi


if [ `uname` == "CYGWIN_NT-5.1" ]; then
  alias ls='ls --color'
  TERM=xterm-256color
elif [ `uname` == 'Linux' ]; then
  alias ls='ls --color -F'
  TERM=xterm-256color
elif [ `uname` == 'Darwin' ]; then
  alias ls='ls -GF'
  TERM=xterm-256color
elif [ `uname` == 'FreeBSD' ]; then
  alias ls='ls -GF'
  TERM=xterm-256color
else
  TERM=vt100
fi

export TERM
export GPG_TTY=$(tty)

[ -f '/usr/local/bin/hub' ] && alias git=hub
alias augtool='augtool -I $HOME/projects/augeas/lenses/'
alias be='bundle exec'
alias curl-trace='curl -w "@$HOME/.curl-trace" -o /dev/null -s'
alias fixmouse='xinput --set-prop 13 286 12 15 255' # Synaptics Finger low, high, press
alias fixterm='resize > /tmp/blah ; . /tmp/blah ; rm /tmp/blah'
alias kitchen='bundle exec kitchen'
alias less='less -R'
alias myip='echo -e "\n$(curl -s ifconfig.me/ip)\n"'
alias ta='tmux attach -t'
alias tls='tmux list-sessions'
alias rake='bundle exec rake'
alias rgrep='egrep -R'
alias vi=vim
alias xterm='xterm -bg black -fg green'

[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"
[ -s "$HOME/ansible/hacking/env-setup" ] && source "$HOME/ansible/hacking/env-setup" -q

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

if [ -f $HOME/.kube/config ]; then
  export KUBECONFIG=$HOME/.kube/config
fi

cd $HOME

# added by travis gem
[ -f /Users/soberther/.travis/travis.sh ] && source /Users/soberther/.travis/travis.sh
