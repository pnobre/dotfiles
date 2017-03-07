export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

plugins=(git)


export PATH=$HOME/bin:/usr/local/bin:$PATH:/c/users/pnobre/.dnx/bin

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

if [ -f "$HOME/.bashrc" ]; then
   . "$HOME/.bashrc"
fi

if [ -f "/c/users/pnobre/.dnx/bin/dnvm.sh" ]; then
  source /c/users/pnobre/.dnx/bin/dnvm.sh
fi

export PATH=/c/tools/python27:/c/tools/python27/scripts:"/C/Program Files/Docker/Docker/Resources/bin/":$PATH
export PYTHON="c:\tools\python27\python.exe"

SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
	eval `$SSHAGENT $SSHAGENTARGS`
	trap "kill $SSH_AGENT_PID" 0
fi

