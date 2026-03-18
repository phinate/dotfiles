export CLAUDE_CODE_OAUTH_TOKEN=(security find-generic-password -a "$USER" -s "claude oauth" -w)

# Default to Sonnet for ~60% cost savings (switch to opus mid-session with /model opus when needed)
export ANTHROPIC_MODEL="claude-opus-4-6"
 
# Use Haiku for subagents — massive token savings on exploration/review tasks
export CLAUDE_CODE_SUBAGENT_MODEL="haiku"
 
# Trigger auto-compaction at 50% context instead of default ~83%
# Prevents the quality degradation that happens when context gets too full
export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50
 
# Cap thinking tokens for routine work (raise for architecture tasks)
export MAX_THINKING_TOKENS=10000
 
# Strip telemetry/analytics traffic to reduce noise
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

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
