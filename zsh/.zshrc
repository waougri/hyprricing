#!/usr/bin/env zsh
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║  ~/.zshrc — iustus@zenith                                               ║
# ║  Stack: zinit · fzf-tab · atuin · zoxide · starship                     ║
# ╚══════════════════════════════════════════════════════════════════════════╝
# Profiling: uncomment + add zmodload zsh/zprof as very first line
# trap 'zprof' EXIT

# =============================================================================
#  INSTANT PROMPT (starship compat — silence console output during init)
# =============================================================================
# Must be before any output-producing code

# =============================================================================
#  XDG
# =============================================================================
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# =============================================================================
#  ENVIRONMENT
# =============================================================================
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-RFXi --mouse'
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"

# Rust
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"

# Go
export GOPATH="${XDG_DATA_HOME}/go"

# Node
export NVM_DIR="${XDG_DATA_HOME}/nvm"
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME}/npm"

# Python
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/startup.py"
export PYTHONDONTWRITEBYTECODE=1
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"

# ROCm — RX 7700 XT (gfx1101)
export HIP_VISIBLE_DEVICES=0
export HSA_OVERRIDE_GFX_VERSION=11.0.1
export ROC_ENABLE_PRE_VEGA=0

# ripgrep
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"

# bat
export BAT_THEME='base16'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT='-c'

# delta
export GIT_PAGER='delta'
export DELTA_PAGER='less -RFX'

# =============================================================================
#  PATH
# =============================================================================
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "${CARGO_HOME}/bin"
  "${GOPATH}/bin"
  "${XDG_DATA_HOME}/npm/bin"
  "/usr/local/bin"
  $path
)
typeset -U path

# =============================================================================
#  ZINIT — auto-bootstrap
# =============================================================================
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
[[ ! -d $ZINIT_HOME ]] && {
  print -P "\n\e[38;2;110;86;175m  ⚡ Bootstrapping zinit...\e[0m\n"
  command mkdir -p "${ZINIT_HOME:h}"
  command git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
}
source "${ZINIT_HOME}/zinit.zsh"

# =============================================================================
#  COMPINIT — cached, max once per day
# =============================================================================
autoload -Uz compinit
local _zcomp="${XDG_CACHE_HOME}/zsh/zcompdump"
mkdir -p "${_zcomp:h}"
if [[ -f "$_zcomp" ]] && [[ -z $(find "$_zcomp" -mmin +1200 2>/dev/null) ]]; then
  compinit -C -d "$_zcomp"
else
  compinit -d "$_zcomp"
fi

# =============================================================================
#  PLUGINS
# =============================================================================

# Syntax highlighting — MUST load before fzf-tab, AFTER compinit
zinit light-mode for \
  zdharma-continuum/fast-syntax-highlighting

# Turbo — load after first prompt
zinit wait lucid light-mode for \
  atload'_zsh_autosuggest_start' \
    zsh-users/zsh-autosuggestions \
  blockf atload'zicdreplay' \
    zsh-users/zsh-completions \
  atload'
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
    bindkey "^[OA" history-substring-search-up
    bindkey "^[OB" history-substring-search-down
  ' \
    zsh-users/zsh-history-substring-search \
  hlissner/zsh-autopair

# fzf-tab — load AFTER compinit and completions
zinit wait'1' lucid light-mode for \
  Aloxaf/fzf-tab

# =============================================================================
#  HISTORY
# =============================================================================
mkdir -p "${XDG_STATE_HOME}/zsh"
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=200000
SAVEHIST=200000

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# =============================================================================
#  COMPLETION STYLES
# =============================================================================
zstyle ':completion:*'              menu no  # let fzf-tab handle menu
zstyle ':completion:*'              matcher-list \
  'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*'              list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*'              group-name ''
zstyle ':completion:*'              use-cache on
zstyle ':completion:*'              cache-path "${XDG_CACHE_HOME}/zsh/compcache"
zstyle ':completion:*:descriptions' format '%F{#6E56AF}── %d%f'
zstyle ':completion:*:warnings'     format '%F{#D9534F}── no matches%f'
zstyle ':completion:*:cd:*'         ignore-parents parent pwd
zstyle ':completion:*:git-checkout:*' sort false

# fzf-tab
zstyle ':fzf-tab:*'             use-fzf-default-opts yes
zstyle ':fzf-tab:*'             fzf-flags --height=50% --layout=reverse
zstyle ':fzf-tab:*'             switch-group '<' '>'
zstyle ':fzf-tab:complete:cd:*' fzf-preview \
  'eza --tree --color=always --icons -L 2 $realpath 2>/dev/null || ls --color=always $realpath'
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview \
  'man $word 2>/dev/null | bat -l man -p --color=always'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  'bat --color=always --style=numbers --line-range :100 $realpath 2>/dev/null || echo $realpath'

# =============================================================================
#  ZSH OPTIONS
# =============================================================================
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt CDABLE_VARS
setopt CORRECT
setopt INTERACTIVE_COMMENTS
setopt MULTIOS
setopt GLOB_DOTS
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB
setopt NO_BEEP
setopt RC_QUOTES

# =============================================================================
#  KEY BINDINGS
# =============================================================================
bindkey -e

# History search
bindkey '^[[A'    history-substring-search-up
bindkey '^[[B'    history-substring-search-down
bindkey '^[OA'    history-substring-search-up
bindkey '^[OB'    history-substring-search-down

# Word navigation
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H'      backward-kill-word
bindkey '^[[3;5~' kill-word

# Standard
bindkey '^[[3~'   delete-char
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line

# Autosuggestion
bindkey '^ '      autosuggest-accept

# Edit in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# =============================================================================
#  AUTOSUGGESTIONS
# =============================================================================
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#3D3060'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# =============================================================================
#  FAST SYNTAX HIGHLIGHTING
# =============================================================================
FAST_HIGHLIGHT[use_async]=1

# =============================================================================
#  HISTORY SUBSTRING SEARCH
# =============================================================================
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=#0E0E1E,bg=#73D216,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=#0E0E1E,bg=#D9534F,bold'
HISTORY_SUBSTRING_SEARCH_FUZZY=1
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# =============================================================================
#  FZF
# =============================================================================
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

export FZF_DEFAULT_OPTS="
  --color=fg:#DDDAEC,bg:#0E0E1E,hl:#73D216
  --color=fg+:#EDEAF8,bg+:#1E1E32,hl+:#90E83A
  --color=info:#6E56AF,prompt:#B48BFF,pointer:#D9534F
  --color=marker:#73D216,spinner:#6E56AF,header:#4A8EC2,border:#35334E
  --color=label:#DDDFFF,preview-bg:#0E0E1E,preview-border:#35334E
  --color=gutter:#0E0E1E,separator:#27273F,scrollbar:#61538D
  --border=rounded
  --border-label=' fzf '
  --border-label-pos=3
  --prompt='  '
  --pointer='▶ '
  --marker='✓ '
  --separator='─'
  --scrollbar='▐'
  --height=55%
  --layout=reverse
  --info=inline-right
  --scroll-off=3
  --cycle
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-u:preview-half-page-up'
  --bind 'ctrl-d:preview-half-page-down'
  --bind 'ctrl-a:select-all'
  --bind 'ctrl-y:execute-silent(echo -n {+} | wl-copy)'
"

export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers,changes --line-range :200 {} 2>/dev/null || cat {}'
  --preview-window=right:55%:wrap
"
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --icons --color=always -L 3 {} 2>/dev/null || ls --color=always {}'
"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window=down:3:wrap
  --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)'
"

eval "$(fzf --zsh)"

# =============================================================================
#  LS_COLORS
# =============================================================================
if command -v vivid &>/dev/null; then
  export LS_COLORS="$(vivid generate one-dark 2>/dev/null)"
elif command -v dircolors &>/dev/null; then
  eval "$(dircolors -b)"
fi

# =============================================================================
#  ALIASES — modern tools
# =============================================================================

# eza
alias ls='eza --icons=always --group-directories-first --color=always'
alias ll='eza -lah --icons=always --group-directories-first --git --git-repos --color=always --time-style=relative'
alias la='eza -a --icons=always --group-directories-first --color=always'
alias lt='eza -lah --icons=always --sort=modified --color=always --time-style=relative'
alias lS='eza -lah --icons=always --sort=size --reverse --color=always'
alias tree='eza --tree --icons=always --color=always -L 3'
alias tree2='eza --tree --icons=always --color=always -L 2'

# bat
alias cat='bat --style=plain --paging=never'
alias catt='bat --style=full --paging=always'

# ripgrep
alias grep='rg'
alias rga='rg --no-ignore --hidden'

# fd
alias fd='fd'   # don't alias find — breaks scripts

# dust / duf / procs
alias du='dust'
alias df='duf'
alias ps='procs'

# diff
alias diff='diff --color=auto'
alias ip='ip --color=auto'

# =============================================================================
#  ALIASES — paru / pacman
# =============================================================================
alias pup='paru -Syu'
alias pin='paru -S'
alias prm='paru -Rns'
alias pss='paru -Ss'
alias pqi='paru -Qi'
alias pql='paru -Ql'
alias porp='paru -Qdt'
alias pclean='paru -Sc'

# =============================================================================
#  ALIASES — navigation
# =============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias reload='exec zsh'
alias paths='print -l $path'
alias h='history -50'
alias clr='clear && printf "\e[3J"'

# =============================================================================
#  ALIASES — editors
# =============================================================================
alias vim='nvim'
alias v='nvim'
alias vf='nvim $(fzf)'
alias zshrc='nvim ~/.zshrc && reload'
alias nvimrc='nvim "${XDG_CONFIG_HOME}/nvim/init.lua"'
alias starshiprc='nvim "${XDG_CONFIG_HOME}/starship.toml"'
alias riverrc='nvim "${XDG_CONFIG_HOME}/river/init"'
alias kittyrc='nvim "${XDG_CONFIG_HOME}/kitty/kitty.conf"'

# =============================================================================
#  ALIASES — safety
# =============================================================================
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# =============================================================================
#  ALIASES — systemd
# =============================================================================
alias sc='sudo systemctl'
alias scu='systemctl --user'
alias jc='journalctl -xe'
alias jcf='journalctl -f'

# =============================================================================
#  ALIASES — git
# =============================================================================
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gap='git add -p'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'
alias gcae='git commit --amend'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull --rebase'
alias glog='git log --oneline --graph --decorate --color=always'
alias gloga='git log --oneline --graph --decorate --all --color=always'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git checkout'
alias gsw='git switch'
alias gsc='git switch -c'
alias gbr='git branch -a'
alias gst='git stash'
alias gstp='git stash pop'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gcp='git cherry-pick'
alias grh='git reset HEAD~1'
alias grhh='git reset --hard HEAD~1'
alias gwip='git add -A && git commit -m "wip: $(date +%H:%M)"'

# =============================================================================
#  ALIASES — cargo / rust
# =============================================================================
alias cb='cargo build'
alias cbr='cargo build --release'
alias cr='cargo run'
alias ct='cargo test'
alias cc='cargo check'
alias ccl='cargo clippy'
alias cbl='cargo build --release && cargo clippy'

# =============================================================================
#  FUNCTIONS
# =============================================================================

# cd → auto ls
cd() { builtin cd "$@" && ls }

# mkdir + cd
mkcd() { mkdir -p "$1" && cd "$1" }

# Extract anything
extract() {
  local f="$1"
  [[ ! -f $f ]] && { print -P "%F{#D9534F}✗ not a file: $f%f"; return 1 }
  case "$f" in
    *.tar.bz2|*.tbz2) tar xjf   "$f" ;;
    *.tar.gz|*.tgz)   tar xzf   "$f" ;;
    *.tar.xz|*.txz)   tar xJf   "$f" ;;
    *.tar.zst)         tar --zstd -xf "$f" ;;
    *.tar)             tar xf    "$f" ;;
    *.bz2)             bunzip2   "$f" ;;
    *.gz)              gunzip    "$f" ;;
    *.zip)             unzip     "$f" ;;
    *.7z)              7z x      "$f" ;;
    *.rar)             unrar x   "$f" ;;
    *.zst)             zstd -d   "$f" ;;
    *.lz4)             lz4 -d    "$f" ;;
    *) print -P "%F{#D9534F}✗ unknown format: $f%f"; return 1 ;;
  esac
}

# fzf process killer
fkill() {
  local pids
  pids=$(ps -eo pid,user,pcpu,pmem,comm --sort=-pcpu \
    | fzf --multi --header-lines=1 \
          --preview-window=down:3 \
    | awk '{print $1}')
  [[ -n $pids ]] && echo "$pids" | xargs kill -${1:-TERM} \
    && echo "sent ${1:-TERM} to: $pids"
}

# fzf cd
fj() {
  local dir
  dir=$(fd --type d --hidden --follow \
    --exclude .git --exclude node_modules --exclude .cargo \
    | fzf --preview 'eza --tree --icons --color=always -L 2 {}')
  [[ -n $dir ]] && cd "$dir"
}

# fzf git branch
gbf() {
  local branch
  branch=$(git branch --all --color=always \
    | grep -v HEAD \
    | fzf --ansi \
      --preview 'git log --oneline --color=always $(echo {} | sed "s/remotes\/origin\///" | tr -d "* ")' \
    | sed 's/remotes\/origin\///' | tr -d '* ')
  [[ -n $branch ]] && git switch "$branch"
}

# fzf git log
gshow() {
  git log --oneline --decorate --color=always \
    | fzf --ansi --no-sort --reverse --tiebreak=index \
          --preview 'git show --color=always $(echo {} | cut -d" " -f1)' \
          --preview-window=right:60% \
          --bind 'enter:execute(git show --color=always $(echo {} | cut -d" " -f1) | less -RFX)'
}

# HTTP server
serve() {
  local port="${1:-8000}"
  print -P "%F{#73D216}  serving $(pwd) → http://localhost:$port%f"
  python3 -m http.server "$port"
}

# Port usage
port() {
  [[ -z $1 ]] && { echo "usage: port <number>"; return 1 }
  ss -tulpn | grep ":$1" || echo "nothing on port $1"
}

# Find and replace
frep() {
  [[ -z $1 || -z $2 ]] && { echo "usage: frep <from> <to> [path]"; return 1 }
  rg -l "$1" ${3:-.} | while IFS= read -r f; do
    sed -i "s|${1}|${2}|g" "$f" && echo "  patched: $f"
  done
}

# Notify on done
nd() {
  "$@"
  local code=$?
  local icon=$([[ $code -eq 0 ]] && echo "✓" || echo "✗")
  local urgency=$([[ $code -eq 0 ]] && echo "normal" || echo "critical")
  command -v notify-send &>/dev/null && \
    notify-send -u "$urgency" "$icon $1" "exit $code"
  return $code
}

# Quick benchmark
bench() { hyperfine --warmup 3 "$@" }

# sysinfo
sysinfo() {
  local k="%F{#6E56AF}" v="%F{#DDDAEC}" r="%f"
  print -P "\n  ${k}os     ${r}${v}$(uname -sr)${r}"
  print -P "  ${k}kernel ${r}${v}$(uname -r)${r}"
  print -P "  ${k}shell  ${r}${v}zsh $ZSH_VERSION${r}"
  print -P "  ${k}uptime ${r}${v}$(uptime -p)${r}"
  print -P "  ${k}ram    ${r}${v}$(free -h | awk '/^Mem/{printf "%s / %s", $3, $2}')${r}"
  print -P "  ${k}disk   ${r}${v}$(df -h / | awk 'NR==2{printf "%s / %s (%s)", $3, $2, $5}')${r}"
  print -P "  ${k}pkgs   ${r}${v}$(pacman -Q | wc -l) (pacman)${r}"
  print
}

# =============================================================================
#  INTEGRATIONS
# =============================================================================

# zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh --no-cmd)" || true

# zoxide interactive wrapper
j() {
  if [[ $# -eq 0 ]]; then
    local dir
    dir=$(zoxide query --list --score \
      | fzf --no-sort \
            --preview 'eza --tree --icons --color=always -L 2 {2}' \
            --preview-window=right:50% \
      | awk '{print $2}')
    [[ -n $dir ]] && cd "$dir"
  else
    __zoxide_z "$@"
  fi
}

# atuin
command -v atuin &>/dev/null && eval "$(atuin init zsh --disable-up-arrow)"

# direnv
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# mise
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
else
  [[ -s "${NVM_DIR}/nvm.sh" ]] && {
    nvm()  { unfunction nvm node npm npx; source "${NVM_DIR}/nvm.sh"; nvm "$@" }
    node() { unfunction node; source "${NVM_DIR}/nvm.sh"; node "$@" }
    npm()  { unfunction npm;  source "${NVM_DIR}/nvm.sh"; npm "$@" }
    npx()  { unfunction npx;  source "${NVM_DIR}/nvm.sh"; npx "$@" }
  }
fi

# navi
command -v navi &>/dev/null && eval "$(navi widget zsh)"

# thefuck
command -v thefuck &>/dev/null && eval "$(thefuck --alias f)"

# =============================================================================
#  TERMINAL TITLE
# =============================================================================
_title_precmd()  { print -Pn '\e]0;%~\a' }
_title_preexec() { printf '\e]0;%s\a' "${1:0:60}" }
precmd_functions+=(_title_precmd)
preexec_functions+=(_title_preexec)

# =============================================================================
#  STARSHIP — must be last
# =============================================================================
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  PROMPT='%F{#6E56AF}%~%f %(?:%F{#73D216}❯%f:%F{#D9534F}❯%f) '
  RPROMPT='%F{#54487A}%*%f'
fi

