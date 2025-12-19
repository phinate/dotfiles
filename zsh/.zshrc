export CLAUDE_CODE_OAUTH_TOKEN=(security find-generic-password -a "$USER" -s "claude oauth" -w)
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/nsimpson/.lmstudio/bin"
# End of LM Studio CLI section

# ls alias for color, directories and all dotfiles
alias ls='ls -GpA'

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

zstyle ':omz:update' mode disabled

plugins=(
  git
  brew
  gh
  macos
)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

eval "$(starship init zsh)"

[ -f "/Users/nsimpson/.ghcup/env" ] && . "/Users/nsimpson/.ghcup/env" # ghcup-env
