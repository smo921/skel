# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

## Cleanup passwords from history file
mv $HOME/.bash_history $HOME/.bash_history.tmp
grep -v SUDOPWD $HOME/.bash_history.tmp > $HOME/.bash_history
rm $HOME/.bash_history.tmp

