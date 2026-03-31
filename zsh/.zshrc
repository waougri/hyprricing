#!/usr/bin/env zsh
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║  GENTOO BLING — ZSH CONFIG                                              ║
# ║  Prompt: starship  |  Requires: Nerd Font, zsh 5.8+, 24-bit term       ║
# ╚══════════════════════════════════════════════════════════════════════════╝

# ═══════════════════════════════════════════════════════════════════════════
#  PLUGIN MANAGER — zinit (auto-bootstraps)
# ═══════════════════════════════════════════════════════════════════════════
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d $ZINIT_HOME ]]; then
  print -P "\n\e[38;2;110;86;175m  ⚡ Bootstrapping zinit...\e[0m\n"
  command mkdir -p "$(dirname $ZINIT_HOME)"
  command git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" 2>&1 \
    | while IFS= read -r line; do printf '  \e[38;2;84;72;122m│\e[0m %s\n' "$line"; done
  print
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-completions \
  zsh-users/zsh-history-substring-search

# ═══════════════════════════════════════════════════════════════════════════
#  COLOR HELPERS  (used by shell functions, not the prompt)
# ═══════════════════════════════════════════════════════════════════════════
_gfg() { printf '\e[38;2;%d;%d;%dm' $(( 16#${1:1:2} )) $(( 16#${1:3:2} )) $(( 16#${1:5:2} )); }
_gbg() { printf '\e[48;2;%d;%d;%dm' $(( 16#${1:1:2} )) $(( 16#${1:3:2} )) $(( 16#${1:5:2} )); }
_RST=$'\e[0m'
_BOLD=$'\e[1m'
_DIM=$'\e[2m'
_ITALIC=$'\e[3m'

# ═══════════════════════════════════════════════════════════════════════════
#  HISTORY
# ═══════════════════════════════════════════════════════════════════════════
local _hist_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
mkdir -p "$_hist_dir"
HISTFILE="${_hist_dir}/history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS HIST_VERIFY
setopt SHARE_HISTORY EXTENDED_HISTORY INC_APPEND_HISTORY_TIME

# ═══════════════════════════════════════════════════════════════════════════
#  COMPLETION
# ═══════════════════════════════════════════════════════════════════════════
autoload -Uz compinit
local _zcomp="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
mkdir -p "$(dirname $_zcomp)"
[[ -f ${_zcomp}(#qN.mh+20) ]] && compinit -d "$_zcomp" || compinit -C -d "$_zcomp"

zstyle ':completion:*'              menu select
zstyle ':completion:*'              matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*'              list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{#6E56AF}── %d ──%f'
zstyle ':completion:*:warnings'     format '%F{#D9534F}── no matches ──%f'
zstyle ':completion:*:messages'     format '%F{#61538D}%d%f'
zstyle ':completion:*'              group-name ''
zstyle ':completion:*:*:kill:*'     menu yes select
zstyle ':completion:*:kill:*'       force-list always
zstyle ':completion:*:cd:*'         ignore-parents parent pwd
zstyle ':completion:*:git-checkout:*' sort false

# ═══════════════════════════════════════════════════════════════════════════
#  ZSH OPTIONS
# ═══════════════════════════════════════════════════════════════════════════
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt CORRECT INTERACTIVE_COMMENTS MULTIOS
setopt GLOB_DOTS EXTENDED_GLOB NO_CASE_GLOB
setopt NO_BEEP

# ═══════════════════════════════════════════════════════════════════════════
#  SYNTAX HIGHLIGHTING  (Gentoo palette)
# ═══════════════════════════════════════════════════════════════════════════
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#73D216,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#6E56AF,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#61538D,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#6E56AF'
ZSH_HIGHLIGHT_STYLES[path]='fg=#DDDAEC,underline'
ZSH_HIGHLIGHT_STYLES[path_to_dir]='fg=#DDDFFF,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#DDDFFF'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#6E56AF'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#73D216'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#73D216'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#D9534F'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#6E56AF'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#DDDFFF,bold'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#FAFAFA'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#D9534F,bold,underline'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#54487A,italic'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#6E56AF,italic'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#DDDFFF,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#61538D,underline'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#DDDAEC'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#DDDFFF'
ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=#6E56AF'

# ═══════════════════════════════════════════════════════════════════════════
#  AUTOSUGGESTIONS
# ═══════════════════════════════════════════════════════════════════════════
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#3D3060'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
ZSH_AUTOSUGGEST_USE_ASYNC=true

# ═══════════════════════════════════════════════════════════════════════════
#  HISTORY SUBSTRING SEARCH
# ═══════════════════════════════════════════════════════════════════════════
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=#1E1630,bg=#73D216,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=#1E1630,bg=#D9534F,bold'
HISTORY_SUBSTRING_SEARCH_FUZZY=true

# ═══════════════════════════════════════════════════════════════════════════
#  KEY BINDINGS
# ═══════════════════════════════════════════════════════════════════════════
bindkey -e
bindkey '^[[A'    history-substring-search-up
bindkey '^[[B'    history-substring-search-down
bindkey '^[OA'    history-substring-search-up
bindkey '^[OB'    history-substring-search-down
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H'      backward-kill-word
bindkey '^[[3;5~' kill-word
bindkey '^[[3~'   delete-char
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line
bindkey '^ '      autosuggest-accept

# ═══════════════════════════════════════════════════════════════════════════
#  FZF
# ═══════════════════════════════════════════════════════════════════════════
export FZF_DEFAULT_OPTS="
  --color=fg:#DDDAEC,bg:#120F1E,hl:#73D216
  --color=fg+:#FAFAFA,bg+:#1E1630,hl+:#73D216
  --color=info:#6E56AF,prompt:#6E56AF,pointer:#D9534F
  --color=marker:#73D216,spinner:#6E56AF,header:#61538D,border:#54487A
  --color=label:#DDDFFF,preview-bg:#120F1E,preview-border:#54487A
  --border=rounded
  --border-label=' ❯ fzf '
  --border-label-pos=3
  --prompt='  '
  --pointer='▶'
  --marker='✓'
  --height=55%
  --layout=reverse
  --info=inline
  --scroll-off=3
  --cycle
"
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers,changes {} 2>/dev/null || cat {}'
  --preview-window=right:55%:wrap
  --border-label=' ❯ files '
"
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --icons --color=always --level=2 {} 2>/dev/null || ls --color=always {}'
  --border-label=' ❯ cd '
"
export FZF_CTRL_R_OPTS="
  --border-label=' ❯ history '
  --preview 'echo {}'
  --preview-window=down:3:wrap
"

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
command -v fzf &>/dev/null && eval "$(fzf --zsh 2>/dev/null)" 2>/dev/null

# ═══════════════════════════════════════════════════════════════════════════
#  TERMINAL TITLE
# ═══════════════════════════════════════════════════════════════════════════
_title_precmd()  { print -Pn '\e]0;%n@%m: %~\a' }
_title_preexec() { printf '\e]0;%s\a' "${(q)1}" }
precmd_functions+=(_title_precmd)
preexec_functions+=(_title_preexec)

# ═══════════════════════════════════════════════════════════════════════════
#  LS / EZA
# ═══════════════════════════════════════════════════════════════════════════
if command -v eza &>/dev/null; then
  alias ls='eza --icons=always --group-directories-first --color=always'
  alias ll='eza -lah --icons=always --group-directories-first --git --color=always'
  alias la='eza -a --icons=always --group-directories-first --color=always'
  alias lt='eza -lah --icons=always --sort=modified --color=always'
  alias lS='eza -lah --icons=always --sort=size --reverse --color=always'
  alias tree='eza --tree --icons=always --color=always -L 3'
elif command -v lsd &>/dev/null; then
  alias ls='lsd --group-dirs first --icon always'
  alias ll='lsd -lah --group-dirs first --icon always'
  alias tree='lsd --tree'
fi

command -v bat &>/dev/null && {
  alias cat='bat --style=plain --paging=never'
  alias catt='bat --style=full'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT='-c'
}

command -v delta &>/dev/null && export GIT_PAGER='delta'

# ═══════════════════════════════════════════════════════════════════════════
#  ALIASES
# ═══════════════════════════════════════════════════════════════════════════
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias reload='exec zsh'
alias paths='echo $PATH | tr ":" "\n" | nl'
alias h='history 0 | tail -50'
alias clr='clear && printf "\e[3J"'

# Git
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gap='git add -p'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias glog='git log --oneline --graph --decorate --color=always'
alias gloga='git log --oneline --graph --decorate --all --color=always'
alias gdiff='git diff --color=always'
alias gco='git checkout'
alias gsw='git switch'
alias gbr='git branch -a'
alias gstash='git stash'
alias grb='git rebase'
alias gcp='git cherry-pick'

# ═══════════════════════════════════════════════════════════════════════════
#  FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

# cd → auto-ls
cd() { builtin cd "$@" && ls }

# mkdir + cd
mkcd() { mkdir -p "$1" && cd "$1" }

# Extract anything
extract() {
  if [[ ! -f $1 ]]; then
    printf '%s✗ File not found: %s%s\n' "$(_gfg '#D9534F')" "$1" "$_RST"
    return 1
  fi
  case "$1" in
    *.tar.bz2) tar xjf "$1"        ;; *.tar.gz)  tar xzf "$1"        ;;
    *.tar.xz)  tar xJf "$1"        ;; *.tar.zst) tar --zstd -xf "$1" ;;
    *.tar)     tar xf  "$1"        ;; *.tgz)     tar xzf "$1"        ;;
    *.bz2)     bunzip2 "$1"        ;; *.gz)      gunzip  "$1"        ;;
    *.zip)     unzip   "$1"        ;; *.7z)      7z x    "$1"        ;;
    *.rar)     unrar x "$1"        ;;
    *) printf '%s✗ Unknown format: %s%s\n' "$(_gfg '#D9534F')" "$1" "$_RST" ;;
  esac
}

# Grep through history
hist() { history 0 | grep -i "${1:-.}" | tail -${2:-60} }

# Show listening ports
ports() { ss -tulpn 2>/dev/null | grep LISTEN | sort -t: -k2 -n }

# Quick HTTP server in current dir
serve() { python3 -m http.server "${1:-8000}" }

# ── Spinner ───────────────────────────────────────────────────────────────
typeset -a _SP_FRAMES=('⣾' '⣽' '⣻' '⢿' '⡿' '⣟' '⣯' '⣷')
typeset -a _SP_COLS=('#54487A' '#61538D' '#6E56AF' '#6E56AF' '#73D216' '#6E56AF' '#61538D' '#54487A')

spin() {
  local msg="${1:-Working}"
  local pid=$!
  local i=0
  while kill -0 $pid 2>/dev/null; do
    printf '\r%s%s%s %s' \
      "$(_gfg ${_SP_COLS[$((i % ${#_SP_COLS[@]}))]})" \
      "${_SP_FRAMES[$((i % ${#_SP_FRAMES[@]}))]}" \
      "$_RST" "$msg"
    sleep 0.07
    (( i++ ))
  done
  printf '\r\e[2K'
}

# ── Gradient banner ───────────────────────────────────────────────────────
banner() {
  local text="${*:-GENTOO}"
  local -a cols=(
    '#54487A' '#61538D' '#6E56AF' '#6E56AF'
    '#DDDFFF' '#73D216' '#DDDFFF' '#6E56AF'
    '#6E56AF' '#61538D' '#54487A'
  )
  printf '\n  '
  local i
  for (( i = 0; i < ${#text}; i++ )); do
    printf '%s%s%s%s' "$_BOLD" \
      "$(_gfg ${cols[$((i % ${#cols[@]}))]})" \
      "${text[$((i+1))]}" "$_RST"
  done
  printf '\n'
}

# ── System summary ────────────────────────────────────────────────────────
sysinfo() {
  local c1="$(_gfg '#6E56AF')$_BOLD"
  local c2="$(_gfg '#54487A')"
  local cv="$(_gfg '#DDDAEC')"
  printf '\n'
  printf '  %sSYSTEM%s\n'        "$c1" "$_RST"
  printf '  %s%-10s%s %s%s%s\n' "$c2" "OS"     "$_RST" "$cv" "$(uname -sr)"            "$_RST"
  printf '  %s%-10s%s %s%s%s\n' "$c2" "Shell"  "$_RST" "$cv" "zsh $ZSH_VERSION"        "$_RST"
  printf '  %s%-10s%s %s%s%s\n' "$c2" "User"   "$_RST" "$cv" "$(whoami)@$(hostname -s)" "$_RST"
  printf '  %s%-10s%s %s%s%s\n' "$c2" "Uptime" "$_RST" "$cv" \
    "$(uptime -p 2>/dev/null || uptime | sed 's/.*up \([^,]*\).*/up \1/')" "$_RST"
  command -v free &>/dev/null && \
    printf '  %s%-10s%s %s%s%s\n' "$c2" "Memory" "$_RST" "$cv" \
      "$(free -h | awk '/^Mem/{printf "%s / %s", $3, $2}')" "$_RST"
  command -v df &>/dev/null && \
    printf '  %s%-10s%s %s%s%s\n' "$c2" "Disk"   "$_RST" "$cv" \
      "$(df -h / | awk 'NR==2{printf "%s used / %s total (%s)", $3, $2, $5}')" "$_RST"
  printf '\n'
}

# ── fzf process kill ──────────────────────────────────────────────────────
fkill() {
  local pid
  pid=$(ps -ef | grep -v '^UID' \
    | fzf --header='select process to kill' --border-label=' ❯ processes ' \
    | awk '{print $2}')
  [[ -n $pid ]] && kill -${1:-9} "$pid" && echo "killed $pid"
}

# ── fzf cd into pushd stack ───────────────────────────────────────────────
fcd() {
  local dir
  dir=$(dirs -l -p | fzf --border-label=' ❯ pushd stack ') && cd "$dir"
}

# ═══════════════════════════════════════════════════════════════════════════
#  INTEGRATIONS
# ═══════════════════════════════════════════════════════════════════════════
command -v direnv  &>/dev/null && eval "$(direnv hook zsh)"
command -v zoxide  &>/dev/null && eval "$(zoxide init zsh --cmd j)"
command -v thefuck &>/dev/null && eval "$(thefuck --alias)"

# nvm — lazy loaded so it doesn't tank startup
[[ -s "$HOME/.nvm/nvm.sh" ]] && {
  export NVM_DIR="$HOME/.nvm"
  nvm()  { unfunction nvm;       source "$NVM_DIR/nvm.sh"; nvm  "$@" }
  node() { unfunction node npm npx; source "$NVM_DIR/nvm.sh"; node "$@" }
  npm()  { unfunction npm;       source "$NVM_DIR/nvm.sh"; npm  "$@" }
  npx()  { unfunction npx;       source "$NVM_DIR/nvm.sh"; npx  "$@" }
}

command -v pyenv &>/dev/null && eval "$(pyenv init -)"
command -v rbenv &>/dev/null && eval "$(rbenv init - zsh)"

# ── zest available as a pipe utility (not wired into the prompt) ─────────
#   echo "done!" | zest shine
#   ( build_cmd ) | zest flames --duration 800

# ═══════════════════════════════════════════════════════════════════════════
#  LS_COLORS
# ═══════════════════════════════════════════════════════════════════════════
if command -v vivid &>/dev/null; then
  export LS_COLORS="$(vivid generate molokai 2>/dev/null)"
elif command -v dircolors &>/dev/null; then
  eval "$(dircolors -b)"
fi

# ═══════════════════════════════════════════════════════════════════════════
#  PATH
# ═══════════════════════════════════════════════════════════════════════════
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ═══════════════════════════════════════════════════════════════════════════
#  STARSHIP  — install: curl -sS https://starship.rs/install.sh | sh
#              config:  ~/.config/starship.toml
# ═══════════════════════════════════════════════════════════════════════════
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  PROMPT='%F{#6E56AF}╰─❯%f '
  print -P "%F{#D9534F}  starship not found.%f  %F{#73D216}curl -sS https://starship.rs/install.sh | sh%f\n"
fi

# Uncomment both lines below to profile startup time:
# zmodload zsh/zprof  ← also add at very top of this file
# zprof

