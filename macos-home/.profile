# Lam changed to use gpg agent instead of macos ssh default agent
# the old value was SSH_AUTH_SOCK=/private/tmp/com.apple.launchd.HFFnABBlrf/Listeners
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# Lam: should I change to `gpg-agent --daemon`?
gpgconf --launch gpg-agent

# for go lang
export GOPATH=/opt/goworkspace
export GOBIN=$GOPATH/bin
export PATH="$GOBIN:$PATH"

# force default provider for vagrant
export VAGRANT_DEFAULT_PROVIDER=vmware_esxi
export PACKER_CACHE_DIR=~/.packer.d/packer_cache

export TERM=xterm-256color
# do not seperate for now -- to enable `vi` inside tmux
#[[ $TMUX != "" ]] && export TERM="screen-256color"

# MacPorts Installer addition on 2020-06-02_at_22:04:23: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH

# Add .NET Core SDK tools
export PATH="$PATH:/Users/alam/.dotnet/tools"

export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/Applications/VMware OVF Tool:$PATH"

# https://github.com/roxma/vim-hug-neovim-rpc/issues/47
export PATH="/usr/local/opt/openssl/bin:/local/bin:/usr/local/opt/python@3.8/bin:$PATH"
