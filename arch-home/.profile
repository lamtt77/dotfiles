export EDITOR='vim'
export PATH=~/.local/bin:~/.gem/ruby/2.7.0/bin:$PATH

alias l='ls -a'
alias ll='ls -lAh'		# A: almost all except . and ..
alias la='ls -laF'

[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# LamT: gpg-agent will need to enable ssh support and allow pubkey in sshcontrol
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
