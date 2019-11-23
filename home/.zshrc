#antigen
source $HOME/antigen.zsh
    
# Load the oh-my-zsh's library
antigen use oh-my-zsh

antigen bundle <<EOBUNDLES
    # Bundles from the default repo (robbyrussell's oh-my-zsh)
    git
    docker

    # Syntax highlighting bundle.
    zsh-users/zsh-syntax-highlighting

    # Fish-like auto suggestions
    zsh-users/zsh-autosuggestions

    # Extra zsh completions
    zsh-users/zsh-completions
EOBUNDLES

# Load the theme
antigen theme denysdovhan/spaceship-prompt

# pyenv
export PATH="/home/claytonjy/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# pipenv
export PIPENV_VENV_IN_PROJECT=1
eval "$(pipenv --completion)"

# completions
source $HOME/.local/bin/aws_zsh_completer.sh  # aws-cli
eval "$(register-python-argcomplete pipx)"    # pipx
source <(kubectl completion zsh)              # kubectl
fpath=($fpath ~/.zsh/completion)              # eksctl

# Tell antigen that you're done
antigen apply

# start a tmux session if we aren't already in one
if [[ -z $TMUX ]]; then tmux; fi
