#!/usr/bin/env zsh
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║       GENTOO BLING — ZSH CONFIG — MAXIMUM OVERDRIVE                    ║
# ║  Palette: Gentoo Brand  |  Requires: Nerd Font, zsh 5.8+, 24-bit term  ║
# ╚══════════════════════════════════════════════════════════════════════════╝

# ── Load datetime module first (needed for EPOCHREALTIME) ─────────────────
zmodload zsh/datetime 2>/dev/null

# ═══════════════════════════════════════════════════════════════════════════
#  PLUGIN MANAGER — zinit (auto-bootstraps on first run)
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

# ── Plugins (light-mode = no tracking, fastest load) ─────────────────────
zinit light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-completions \
  zsh-users/zsh-history-substring-search

# ═══════════════════════════════════════════════════════════════════════════
#  COLOR HELPERS  (Gentoo brand palette)
# ═══════════════════════════════════════════════════════════════════════════
#  hex → ANSI 24-bit fg/bg escape sequences
_gfg() { printf '\e[38;2;%d;%d;%dm' $(( 16#${1:1:2} )) $(( 16#${1:3:2} )) $(( 16#${1:5:2} )); }
_gbg() { printf '\e[48;2;%d;%d;%dm' $(( 16#${1:1:2} )) $(( 16#${1:3:2} )) $(( 16#${1:5:2} )); }
_RST=$'\e[0m'
_BOLD=$'\e[1m'
_DIM=$'\e[2m'
_ITALIC=$'\e[3m'

# ═══════════════════════════════════════════════════════════════════════════
#  STARTUP ANIMATION
# ═══════════════════════════════════════════════════════════════════════════
_bling_intro() {
  [[ -z $PS1 ]]            && return   # non-interactive
  [[ -n $INSIDE_EMACS ]]   && return
  [[ -n $_BLING_SHOWN ]]   && return   # already ran this session
  export _BLING_SHOWN=1

  # ── ASCII logo (ANSI Shadow style) ───────────────────────────────────────
  local -a LOGO=(
    "  ░██████╗░███████╗███╗░░██╗████████╗░█████╗░░█████╗░"
    "  ██╔════╝░██╔════╝████╗░██║╚══██╔══╝██╔══██╗██╔══██╗"
    "  ██║░░██╗░█████╗░░██╔██╗██║░░░██║░░░██║░░██║██║░░██║"
    "  ██║░░╚██╗██╔══╝░░██║╚████║░░░██║░░░██║░░██║██║░░██║"
    "  ╚██████╔╝███████╗██║░╚███║░░░██║░░░╚█████╔╝╚█████╔╝"
    "  ░╚═════╝░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░░╚════╝░░╚════╝░"
  )

  # Gradient: dark purple → light purple → bright purple
  local -a GRAD=(
    '#2A1F4A' '#3A2D62' '#4A3A7A'
    '#54487A' '#61538D' '#6E56AF'
  )

  printf '\n'
  local i=0
  for line in "${LOGO[@]}"; do

    printf '%s%s%s%s\n' "$(_gfg ${GRAD[$((i % ${#GRAD[@]}))]})" "$_BOLD" "$line" "$_RST"

    sleep 0.055
    (( i++ ))
  done

  # ── Subtitle ─────────────────────────────────────────────────────────────
  printf '\n  %s%s  ❯  zsh %s  ❯  bling edition%s\n' \
    "$(_gfg '#DDDFFF')$_DIM$_ITALIC" \
    "$(uname -sr)" "$ZSH_VERSION" "$_RST"

  # ── Gradient loading bar ─────────────────────────────────────────────────
  printf '\n  '
  local bar_w=52
  for (( i=0; i<=bar_w; i++ )); do
    local pct=$(( i * 100 / bar_w ))
    if   (( pct < 40 )); then printf '%s█' "$(_gfg '#54487A')"
    elif (( pct < 70 )); then printf '%s█' "$(_gfg '#6E56AF')"
    else                      printf '%s█' "$(_gfg '#73D216')"
    fi
    sleep 0.012
  done
  printf '%s\n' "$_RST"

  # ── System strip ─────────────────────────────────────────────────────────
  local upstr
  upstr=$(uptime -p 2>/dev/null || uptime | sed 's/.*up \([^,]*\).*/up \1/')
  printf '\n  %s%s%s  @  %s%s%s    %s%s%s\n\n' \
    "$(_gfg '#73D216')$_BOLD" "$(whoami)"    "$_RST" \
    "$(_gfg '#61538D')$_BOLD" "$(hostname -s)" "$_RST" \
    "$(_gfg '#7A7090')$_DIM"  "$upstr"       "$_RST"

  sleep 0.08
}

_bling_intro

# ═══════════════════════════════════════════════════════════════════════════
#  EXECUTION TIMER + EXIT CODE TRACKING
# ═══════════════════════════════════════════════════════════════════════════
typeset -g _bt_ts=0
typeset -g _bt_elapsed=''
typeset -g _bt_exit=0

_bt_preexec() { _bt_ts=$EPOCHREALTIME }

_bt_precmd() {
  _bt_exit=$?
  if (( _bt_ts > 0 )); then
    local e=$(( EPOCHREALTIME - _bt_ts ))
    if   (( e >= 3600 )); then _bt_elapsed=" $(( e/3600 ))h$(( (e%3600)/60 ))m"
    elif (( e >= 60   )); then _bt_elapsed=" $(( e/60 ))m$(( e%60 ))s"
    elif (( e >= 5    )); then _bt_elapsed=" $(( e ))s"
    elif (( e >= 1    )); then _bt_elapsed=" $(printf '%.1f' $e)s"
    else                        _bt_elapsed=''
    fi
  fi
  _bt_ts=0
}
preexec_functions+=(_bt_preexec)
precmd_functions+=(_bt_precmd)

# ═══════════════════════════════════════════════════════════════════════════
#  GIT STATUS  (cached per repo root, very fast on re-render)
# ═══════════════════════════════════════════════════════════════════════════
typeset -g _git_cache_root=''
typeset -g _git_cache_val=''

_git_seg() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || return

  # Return cached value for same repo
  [[ $root == $_git_cache_root ]] && { echo $_git_cache_val; return; }

  local branch staged dirty untracked ahead behind stash
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) \
    || branch="$(git rev-parse --short HEAD 2>/dev/null)…"

  local -a lines=("${(@f)$(git status --porcelain=v1 2>/dev/null)}")
  staged=0; dirty=0; untracked=0
  for l in "${lines[@]}"; do
    [[ ${l:0:2} == '??' ]] && (( untracked++ )) && continue
    [[ ${l:0:1} != ' ' && ${l:0:1} != '?' ]] && (( staged++ ))
    [[ ${l:1:1} != ' ' && ${l:1:1} != '?' ]] && (( dirty++ ))
  done

  ahead=$(git rev-list '@{upstream}..HEAD' --count 2>/dev/null || echo 0)
  behind=$(git rev-list 'HEAD..@{upstream}' --count 2>/dev/null || echo 0)
  stash=$(git stash list 2>/dev/null | wc -l | tr -d ' ')

  local info=" $branch"
  (( staged    > 0 )) && info+="%F{#73D216}+${staged}%f"
  (( dirty     > 0 )) && info+="%F{#DDDFFF}~${dirty}%f"
  (( untracked > 0 )) && info+="%F{#DDDAEC}?${untracked}%f"
  (( ahead     > 0 )) && info+="%F{#6E56AF}⇡${ahead}%f"
  (( behind    > 0 )) && info+="%F{#D9534F}⇣${behind}%f"
  (( stash     > 0 )) && info+="%F{#54487A}≡${stash}%f"

  _git_cache_root="$root"
  _git_cache_val="$info"
  echo "$info"
}

# ═══════════════════════════════════════════════════════════════════════════
#  PROMPT
# ═══════════════════════════════════════════════════════════════════════════
setopt PROMPT_SUBST

# Shorten path smartly: ~/very/deep/path → ~/very/…/path
_short_pwd() {
  local p="${PWD/#$HOME/~}"
  if (( ${#p} > 34 )); then
    local head="${p%%/*}"
    local tail="${p##*/}"
    local mid="${${p%/*}##*/}"
    [[ $mid == $head ]] && echo "${head}/…/${tail}" || echo "${head}/…/${mid}/${tail}"
  else
    echo "$p"
  fi
}

# Venv / conda indicator
_venv_seg() {
  [[ -n $VIRTUAL_ENV        ]] && echo " %F{#73D216}$(basename $VIRTUAL_ENV)%f"
  [[ -n $CONDA_DEFAULT_ENV && $CONDA_DEFAULT_ENV != base ]] \
    && echo " %F{#73D216}conda:${CONDA_DEFAULT_ENV}%f"
}

_build_prompt() {
  # zsh %F{#hex} requires zsh ≥ 5.7 with 24-bit support
  local P2='%F{#54487A}'
  local PL='%F{#61538D}'
  local PL2='%F{#6E56AF}'
  local GR='%F{#DDDAEC}'
  local BL='%F{#DDDFFF}'
  local GN='%F{#73D216}'
  local RD='%F{#D9534F}'
  local DM='%F{#7A7090}'
  local R='%f'

  # Exit badge
  local exit_badge
  if (( _bt_exit == 0 )); then
    exit_badge="${GN}✓${R}"
  else
    exit_badge="${RD}✗${_bt_exit}${R}"
  fi

  # Git
  local git_raw="$(_git_seg)"
  local git_part=''
  [[ -n $git_raw ]] && git_part=" ${PL2}─${R}[${PL}${git_raw}${R}]"

  # Venv
  local venv_raw="$(_venv_seg)"
  local venv_part=''
  [[ -n $venv_raw ]] && venv_part=" ${PL2}─${R}[${venv_raw}]"

  # Timer
  local timer_part=''
  [[ -n $_bt_elapsed ]] && timer_part=" ${DM}⏱${_bt_elapsed}${R}"

  # ── Line 1 ───────────────────────────────────────────────────────────────
  PROMPT="${PL2}╭─${R}[${exit_badge}]"
  PROMPT+=" ${PL2}─${R}[${PL2}%n${DM}@${PL}%m${R}]"
  PROMPT+=" ${PL2}─${R}[${GR}$(_short_pwd)${R}]"
  PROMPT+="${git_part}${venv_part}${timer_part}"
  PROMPT+=$'\n'

  # ── Line 2 ───────────────────────────────────────────────────────────────
  # Background jobs indicator on line 2
  local jobs_part='%(1j. ${DM}[%j]${R}.)'
  PROMPT+="${PL2}╰─%(?.${PL2}.${RD})❯${R} "
}

precmd_functions+=(_build_prompt)

# Right prompt: background jobs + clock
RPROMPT='%(1j.%F{#6E56AF} %j%f .)%F{#54487A}%D{%H:%M:%S}%f'

# ═══════════════════════════════════════════════════════════════════════════
#  TERMINAL TITLE
# ═══════════════════════════════════════════════════════════════════════════
_title_precmd()  { print -Pn '\e]0;%n@%m: %~\a' }
_title_preexec() { printf '\e]0;%s\a' "${(q)1}" }
precmd_functions+=(_title_precmd)
preexec_functions+=(_title_preexec)

# ═══════════════════════════════════════════════════════════════════════════
#  COMPLETION SYSTEM
# ═══════════════════════════════════════════════════════════════════════════
autoload -Uz compinit
local _zcomp="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
mkdir -p "$(dirname $_zcomp)"
# Regenerate dump only if older than 20 hours
if [[ -f ${_zcomp}(#qN.mh+20) ]]; then
  compinit -d "$_zcomp"
else
  compinit -C -d "$_zcomp"
fi

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

# ═══════════════════════════════════════════════════════════════════════════
#  SYNTAX HIGHLIGHTING (Gentoo palette)
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

# ═══════════════════════════════════════════════════════════════════════════
#  AUTOSUGGESTIONS
# ═══════════════════════════════════════════════════════════════════════════
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#4A3D6A'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
ZSH_AUTOSUGGEST_USE_ASYNC=true

# ═══════════════════════════════════════════════════════════════════════════
#  HISTORY SUBSTRING SEARCH COLOURS
# ═══════════════════════════════════════════════════════════════════════════
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=#1E1630,bg=#73D216,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=#1E1630,bg=#D9534F,bold'
HISTORY_SUBSTRING_SEARCH_FUZZY=true

# ═══════════════════════════════════════════════════════════════════════════
#  FZF
# ═══════════════════════════════════════════════════════════════════════════
export FZF_DEFAULT_OPTS="
  --color=fg:#DDDAEC,bg:#1E1630,hl:#73D216
  --color=fg+:#FAFAFA,bg+:#2D2147,hl+:#73D216
  --color=info:#6E56AF,prompt:#6E56AF,pointer:#D9534F
  --color=marker:#73D216,spinner:#6E56AF,header:#61538D,border:#54487A
  --color=label:#DDDFFF
  --border=rounded
  --border-label=' ❯ fzf '
  --border-label-pos=3
  --prompt='  '
  --pointer='▶'
  --marker='✓'
  --height=50%
  --layout=reverse
  --info=inline
"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers {} 2>/dev/null || cat {}'"
export FZF_ALT_C_OPTS="--preview 'ls --color=always {}'"
export FZF_CTRL_R_OPTS="--border-label=' ❯ history '"

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
command -v fzf &>/dev/null && eval "$(fzf --zsh 2>/dev/null)" 2>/dev/null

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
#  ZSH OPTIONS
# ═══════════════════════════════════════════════════════════════════════════
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt CORRECT INTERACTIVE_COMMENTS MULTIOS
setopt GLOB_DOTS EXTENDED_GLOB NO_CASE_GLOB
setopt NO_BEEP

# ═══════════════════════════════════════════════════════════════════════════
#  KEY BINDINGS
# ═══════════════════════════════════════════════════════════════════════════
bindkey -e
# Up/down: history substring search (loaded above)
bindkey '^[[A'  history-substring-search-up
bindkey '^[[B'  history-substring-search-down
bindkey '^[OA'  history-substring-search-up
bindkey '^[OB'  history-substring-search-down
# Word navigation
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H'      backward-kill-word
bindkey '^[[3;5~' kill-word
bindkey '^[[3~'   delete-char
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line
# Accept autosuggestion with Ctrl+Space
bindkey '^ '    autosuggest-accept

# ═══════════════════════════════════════════════════════════════════════════
#  LS / EZA
# ═══════════════════════════════════════════════════════════════════════════
if command -v eza &>/dev/null; then
  alias ls='eza --icons=always --group-directories-first --color=always'
  alias ll='eza -lah --icons=always --group-directories-first --git --color=always'
  alias la='eza -a --icons=always --group-directories-first --color=always'
  alias lt='eza -lah --icons=always --sort=modified --color=always'
  alias tree='eza --tree --icons=always --color=always -L 3'
elif command -v lsd &>/dev/null; then
  alias ls='lsd --group-dirs first --icon always'
  alias ll='lsd -lah --group-dirs first --icon always'
  alias tree='lsd --tree'
fi

# ── bat / cat ──────────────────────────────────────────────────────────────
command -v bat &>/dev/null && {
  alias cat='bat --style=plain --paging=never'
  alias catt='bat --style=full'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export BAT_THEME="Solarized (dark)"
}

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

# Git
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias glog='git log --oneline --graph --decorate --color=always'
alias gdiff='git diff --color=always'
alias gco='git checkout'
alias gbr='git branch -a'
alias gstash='git stash'

# ═══════════════════════════════════════════════════════════════════════════
#  FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

# cd → auto-ls
cd() { builtin cd "$@" && ls }

# mkdir + cd
mkcd() { mkdir -p "$1" && cd "$1" }

# Extract anything
extract() {
  case "$1" in
    *.tar.bz2) tar xjf "$1"          ;;  *.tar.gz)  tar xzf "$1"  ;;
    *.tar.xz)  tar xJf "$1"          ;;  *.tar.zst) tar --zstd -xf "$1" ;;
    *.bz2)     bunzip2 "$1"          ;;  *.gz)      gunzip "$1"   ;;
    *.zip)     unzip "$1"            ;;  *.7z)      7z x "$1"     ;;
    *.rar)     unrar x "$1"          ;;  *.tar)     tar xf "$1"   ;;
    *.tgz)     tar xzf "$1"          ;;
    *) printf '%s✗ Unknown format: %s%s\n' "$(_gfg '#D9534F')" "$1" "$_RST" ;;
  esac
}

# Grep through history
hist() { history 0 | grep -i "${1:-.}" | tail -${2:-60} }

# ── Spinner — wrap a background command ──────────────────────────────────
#  Usage:  some_slow_command & spin "message"
typeset -a _SP_FRAMES=('⣾' '⣽' '⣻' '⢿' '⡿' '⣟' '⣯' '⣷')
typeset -a _SP_COLS=('#54487A' '#61538D' '#6E56AF' '#6E56AF' '#61538D' '#54487A' '#54487A' '#61538D')

spin() {
  local msg="${1:-Working}"
  local pid=$!
  local i=0
  while kill -0 $pid 2>/dev/null; do
    printf '\r%s%s%s %s' "$(_gfg ${_SP_COLS[$((i % 8))]})" "${_SP_FRAMES[$((i % 8))]}" "$_RST" "$msg"
    sleep 0.08
    (( i++ ))
  done
  printf '\r\e[2K'
}

# ── Gentoo gradient banner ────────────────────────────────────────────────
banner() {
  local text="${*:-BLING}"
  local -a cols=('#54487A' '#61538D' '#6E56AF' '#DDDFFF' '#73D216' '#DDDFFF' '#6E56AF' '#61538D')
  printf '\n  '
  for (( i=0; i<${#text}; i++ )); do
    printf '%s%s%s%s' "$_BOLD" "$(_gfg ${cols[$((i % ${#cols[@]}))]})" "${text:$i:1}" "$_RST"
  done
  printf '\n'
}

# ── Pretty system summary ────────────────────────────────────────────────
sysinfo() {
  printf '\n'
  printf '  %s%s%s\n'         "$(_gfg '#6E56AF')$_BOLD" "System" "$_RST"
  printf '  %s%-12s%s %s\n'   "$(_gfg '#54487A')" "OS"     "$_RST" "$(uname -sr)"
  printf '  %s%-12s%s %s\n'   "$(_gfg '#54487A')" "Shell"  "$_RST" "zsh $ZSH_VERSION"
  printf '  %s%-12s%s %s\n'   "$(_gfg '#54487A')" "Uptime" "$_RST" "$(uptime -p 2>/dev/null || uptime)"
  printf '  %s%-12s%s %s\n'   "$(_gfg '#54487A')" "User"   "$_RST" "$(whoami)@$(hostname -s)"
  command -v free &>/dev/null && \
    printf '  %s%-12s%s %s\n' "$(_gfg '#54487A')" "Memory" "$_RST" \
      "$(free -h | awk '/^Mem/{print $3"/"$2" used"}')"
  printf '\n'
}

# ── fpath / plugin path inspection ──────────────────────────────────────
zsh-info() {
  printf '\n%s  fpath entries:%s\n' "$(_gfg '#6E56AF')" "$_RST"
  print -l $fpath | while read p; do
    printf '  %s• %s%s\n' "$(_gfg '#54487A')" "$p" "$_RST"
  done
  printf '\n'
}

# ═══════════════════════════════════════════════════════════════════════════
#  INTEGRATIONS  (only if installed)
# ═══════════════════════════════════════════════════════════════════════════
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
command -v zoxide &>/dev/null && eval "$(zoxide init zsh --cmd cd)"
command -v thefuck &>/dev/null && eval "$(thefuck --alias)"

# Node version manager
[[ -s "$HOME/.nvm/nvm.sh" ]] && {
  export NVM_DIR="$HOME/.nvm"
  # Lazy-load nvm for speed
  nvm() { unfunction nvm; source "$NVM_DIR/nvm.sh"; nvm "$@" }
}

# pyenv
command -v pyenv &>/dev/null && eval "$(pyenv init -)"

# ═══════════════════════════════════════════════════════════════════════════
#  LS_COLORS
# ═══════════════════════════════════════════════════════════════════════════
if command -v vivid &>/dev/null; then
  export LS_COLORS="$(vivid generate molokai 2>/dev/null)"
elif command -v dircolors &>/dev/null; then
  eval "$(dircolors -b)"
fi

# ═══════════════════════════════════════════════════════════════════════════
#  PATH  (add your custom bins here)
# ═══════════════════════════════════════════════════════════════════════════
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ── Uncomment to profile startup time ─────────────────────────────────────
# zmodload zsh/zprof   # put at very top too
# zprof               # put at very bottom

