# cd / directory stack
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# completion
setopt AUTO_MENU
setopt ALWAYS_TO_END
setopt CORRECT
setopt NOMATCH

# safety
setopt NO_CLOBBER
setopt GLOB_DOTS

# history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
export HISTFILE=${HOME}/.zhistory
export HISTSIZE=1000
export SAVEHIST=2000

# beep
setopt NO_BEEP

# menu UI
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''

# nicer messages
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
zstyle ':completion:*:warnings' format '%F{red}%d%f'

# smarter matching
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Z}' \
  'r:|[-_]=* r:|=*'

# cache
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

# dirs
zstyle ':completion:*' list-dirs-first true
