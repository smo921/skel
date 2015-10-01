# base-files version 3.7-1

SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    $SSHAGENT | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps auxwww | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi 
                                                                

# source the system wide bashrc if it exists
if [ -e /etc/bash.bashrc ] ; then
  source /etc/bash.bashrc
fi


[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh

########## Build up our path ############
grepcmd='egrep'

for testdir in                 \
    /usr/sfw/bin               \
    /usr/sfw/sbin              \
    /sbin                      \
    /bin                       \
    /usr/sbin                  \
    /usr/bin                   \
    /usr/local/sbin            \
    /usr/local/bin             \
    /usr/ccs/bin               \
    $HOME/bin                  \
    $HOME/.rbenv/bin           \
    /data/rbenv/bin            \
  ; do
    echo -n "PATHADD ... "
    if [ -d "${testdir}" ]
      then
        if ! echo "${PATH}" | ${grepcmd} "^${testdir}:|^${testdir}$|:${testdir}$|:${testdir}:" > /dev/null
          then
            echo "adding: ${testdir} to path"
            # directory not already in path
            export PATH="${testdir}:${PATH}"
          else
            echo "skipping: ${testdir} (already in path)"
        fi
      else
        echo "skipping: ${testdir} (not present on system)"
    fi
  done
echo

for testdir in .; do
        echo "adding: ${testdir} to path"
        # directory not already in path
        export PATH="${testdir}:${PATH}"
done

########## Build up our library path ############
grepcmd='egrep'

for testdir in                 \
    /lib                      \
    /usr/lib                  \
    /usr/local/lib             \
  ; do
    echo -n "LD PATHADD ... "
    if [ -d "${testdir}" ]
      then
        if ! echo "${LD_LIBRARY_PATH}" | ${grepcmd} "^${testdir}:|^${testdir}$|:${testdir}$|:${testdir}:" > /dev/null
          then
            echo "adding: ${testdir} to ld path"
            # directory not already in path
            export LD_LIBRARY_PATH="${testdir}:${LD_LIBRARY_PATH}"
          else
            echo "skipping: ${testdir} (already in ld path)"
        fi
      else
        echo "skipping: ${testdir} (not present on system)"
    fi
  done
echo

for testdir in .; do
        echo "adding: ${testdir} to path"
        # directory not already in path
        export LD_LIBRARY_PATH="${testdir}:${LD_LIBRARY_PATH}"
done

# source the users bashrc if it exists
if [ -e "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi


## Setup rbenv
if [ -d /data/rbenv ]; then
  export RBENV_ROOT="/data/rbenv"
elif [ -d /usr/local/var/rbenv ]; then
  export RBENV_ROOT=/usr/local/var/rbenv
fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export PATH="/opt/chefdk/bin:$PATH"

echo "SSH Keys loaded:"
ssh-add -ls

