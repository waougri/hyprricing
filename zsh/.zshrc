#!/usr/bin/env zsh
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║  ~/.zshrc  —  performance-first, practical, a little bling              ║
# ║  Stack: zinit turbo · fsh · fzf-tab · atuin · zoxide · starship         ║
# ╚══════════════════════════════════════════════════════════════════════════╝
# Benchmark startup: time zsh -i -c exit

# ── profiling (uncomment both lines) ──────────────────────────────────────
# zmodload zsh/zprof   ← also needs to be first line of this file
# trap 'zprof' EXIT

# =============================================================================
#  EARLY ENVIRONMENT  (before anything loads)
# =============================================================================
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-RFXi --mouse'
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"

# Gentoo / Portage
export EMERGE_DEFAULT_OPTS='--ask --verbose --keep-going=y'
export PORTAGE_ELOG_CLASSES='log warn error qa'

# ROCm (your 7700 XT)
export HIP_VISIBLE_DEVICES=0
export HSA_OVERRIDE_GFX_VERSION=11.0.1
export ROC_ENABLE_PRE_VEGA=0

# Rust
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"

# Go
export GOPATH="${XDG_DATA_HOME}/go"

# Node — defer nvm entirely (lazy below)
export NVM_DIR="${XDG_DATA_HOME}/nvm"

# Python
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/startup.py"
export PYTHONDONTWRITEBYTECODE=1

# PATH — ordered by priority
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "${CARGO_HOME}/bin"
  "${GOPATH}/bin"
  "${XDG_DATA_HOME}/npm/bin"
  "/usr/local/bin"
  $path
)
typeset -U path   # deduplicate

# =============================================================================
#  ZINIT  (auto-bootstraps)
# =============================================================================
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

if [[ ! -d $ZINIT_HOME ]]; then
  print -P "\n\e[38;2;110;86;175m  ⚡ Bootstrapping zinit...\e[0m\n"
  command mkdir -p "${ZINIT_HOME:h}"
  command git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# --------------------------------------------------------------------------
#  COMPINIT  (run early, cached — rebuilt at most once per day)
# --------------------------------------------------------------------------
autoload -Uz compinit
local _zcomp="${XDG_CACHE_HOME}/zsh/zcompdump"
mkdir -p "${_zcomp:h}"
# -C skips security check on cached dump; rebuild if dump is >20h old
if [[ -f "$_zcomp" && $(find "$_zcomp" -mmin +1200 2>/dev/null) ]]; then
  compinit -d "$_zcomp"
elif [[ ! -f "$_zcomp" ]]; then
  compinit -d "$_zcomp"
else
  compinit -C -d "$_zcomp"
fi

# --------------------------------------------------------------------------
#  IMMEDIATE plugins  (needed before first prompt)
# --------------------------------------------------------------------------
# fast-syntax-highlighting: rewritten in C, 10× faster than zsh-s-h
zinit light-mode for \
  zdharma-continuum/fast-syntax-highlighting

# --------------------------------------------------------------------------
#  TURBO plugins  (load after first prompt — zero startup cost)
# --------------------------------------------------------------------------
zinit wait lucid light-mode for \
  atload'_zsh_autosuggest_start' \
    zsh-users/zsh-autosuggestions \
  blockf atload'zicdreplay' \
    zsh-users/zsh-completions \
  atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down; bindkey "^[OA" history-substring-search-up; bindkey "^[OB" history-substring-search-down' \
    zsh-users/zsh-history-substring-search

# fzf-tab: replaces zsh menu completion with fzf (must load after compinit)
zinit wait lucid light-mode for \
  Aloxaf/fzf-tab

# autopair: auto-close brackets, quotes
zinit wait lucid light-mode for \
  hlissner/zsh-autopair

# =============================================================================
#  HISTORY
# =============================================================================
local _hist_dir="${XDG_STATE_HOME}/zsh"
mkdir -p "$_hist_dir"
HISTFILE="${_hist_dir}/history"
HISTSIZE=200000
SAVEHIST=200000

setopt HIST_EXPIRE_DUPS_FIRST  # expire duplicates first when trimming
setopt HIST_FIND_NO_DUPS       # don't show duplicates when searching
setopt HIST_IGNORE_ALL_DUPS    # delete old duplicate on new entry
setopt HIST_IGNORE_SPACE       # don't save commands starting with space
setopt HIST_SAVE_NO_DUPS       # don't write duplicates to file
setopt HIST_VERIFY             # show expanded history before executing
setopt SHARE_HISTORY           # share history across sessions immediately
setopt EXTENDED_HISTORY        # save timestamp + duration

# =============================================================================
#  COMPLETION
# =============================================================================
# zicompinit_fast (zinit's fast compinit) is called in the turbo block above.
# These styles are read lazily so it's fine to set them now.

zstyle ':completion:*'              menu select
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

# fzf-tab styles
zstyle ':fzf-tab:*'               fzf-flags --height=40% --layout=reverse
zstyle ':fzf-tab:complete:cd:*'   fzf-preview 'eza --tree --color=always --icons -L 2 $realpath 2>/dev/null || ls --color=always $realpath'
zstyle ':fzf-tab:complete:*:*'    fzf-preview 'bat --color=always --style=numbers --line-range :100 $realpath 2>/dev/null || echo $realpath'
zstyle ':fzf-tab:*'               switch-group '<' '>'   # tab/shift-tab to switch groups

# =============================================================================
#  ZSH OPTIONS
# =============================================================================
setopt AUTO_CD              # type a dir name to cd into it
setopt AUTO_PUSHD           # cd pushes old dir onto stack
setopt PUSHD_IGNORE_DUPS    # no duplicate dirs in stack
setopt PUSHD_SILENT         # no stack output on cd
setopt CDABLE_VARS          # can cd into $VAR

setopt CORRECT              # suggest corrections for typos
setopt INTERACTIVE_COMMENTS # allow # comments in interactive shell
setopt MULTIOS              # multiple redirections
setopt GLOB_DOTS            # glob dotfiles without leading dot
setopt EXTENDED_GLOB        # extended globbing patterns
setopt NO_CASE_GLOB         # case-insensitive globbing
setopt NO_BEEP              # silence
setopt RC_QUOTES            # allow '' for ' inside single quotes

# =============================================================================
#  KEY BINDINGS
# =============================================================================
bindkey -e   # emacs mode (Ctrl-A/E, etc.)

# Arrow keys → history substring search (bound in turbo block above as well)
bindkey '^[[A'    history-substring-search-up
bindkey '^[[B'    history-substring-search-down
bindkey '^[OA'    history-substring-search-up
bindkey '^[OB'    history-substring-search-down

# Word navigation (Ctrl+arrow)
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H'      backward-kill-word
bindkey '^[[3;5~' kill-word

# Standard keys
bindkey '^[[3~'   delete-char
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line

# Accept autosuggestion with Ctrl+Space
bindkey '^ '      autosuggest-accept
# Accept one word of autosuggestion with Ctrl+→
bindkey '^[[1;5C' forward-word

# Edit command in $EDITOR (Ctrl+X Ctrl+E)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# =============================================================================
#  AUTOSUGGESTIONS
# =============================================================================
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#3D3060'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=true   # faster rebinding

# =============================================================================
#  SYNTAX HIGHLIGHTING  (fast-syntax-highlighting uses themes)
# =============================================================================
# FSH ini-style config — runs after plugin loads
FAST_HIGHLIGHT[use_async]=1

# =============================================================================
#  HISTORY SUBSTRING SEARCH
# =============================================================================
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=#0E0E1E,bg=#73D216,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=#0E0E1E,bg=#D9534F,bold'
HISTORY_SUBSTRING_SEARCH_FUZZY=true
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true

# =============================================================================
#  FZF
# =============================================================================
# Use fd for FZF file listing — respects .gitignore, much faster than find
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
  --bind 'ctrl-y:execute-silent(echo -n {+} | xclip -sel clip 2>/dev/null || echo -n {+} | wl-copy)'
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
  --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy 2>/dev/null || echo -n {2..} | xclip -sel clip)'
"

# Source fzf keybindings (fzf --zsh is newer, falls back to sourcing file)
if command -v fzf &>/dev/null; then
  if fzf --zsh &>/dev/null; then
    eval "$(fzf --zsh)"
  elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
  elif [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
  fi
fi

# =============================================================================
#  MODERN TOOL ALIASES
# =============================================================================

# eza (modern ls)
if command -v eza &>/dev/null; then
  alias ls='eza --icons=always --group-directories-first --color=always --hyperlink'
  alias ll='eza -lah --icons=always --group-directories-first --git --git-repos --color=always --time-style=relative'
  alias la='eza -a --icons=always --group-directories-first --color=always'
  alias lt='eza -lah --icons=always --sort=modified --color=always --time-style=relative'
  alias lS='eza -lah --icons=always --sort=size --reverse --color=always'
  alias lx='eza -lah --icons=always --sort=extension --color=always'
  alias tree='eza --tree --icons=always --color=always -L 3'
  alias tree2='eza --tree --icons=always --color=always -L 2'
fi

# bat (modern cat)
if command -v bat &>/dev/null; then
  alias cat='bat --style=plain --paging=never'
  alias catt='bat --style=full --paging=always'
  alias batp='bat --style=full'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT='-c'
  export BAT_THEME='base16'
fi

# ripgrep
if command -v rg &>/dev/null; then
  export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"
  alias grep='rg'   # rg is drop-in compatible for most use cases
  alias rga='rg --no-ignore --hidden'   # search everything
fi

# fd (modern find)
command -v fd &>/dev/null && alias find='fd'

# delta (git diff pager)
if command -v delta &>/dev/null; then
  export GIT_PAGER='delta'
  export DELTA_PAGER='less -RFX'
fi

# dust (modern du)
command -v dust &>/dev/null && alias du='dust'

# duf (modern df)
command -v duf &>/dev/null && alias df='duf'

# procs (modern ps)
command -v procs &>/dev/null && alias ps='procs'

# tokei (code stats)
# just 'tokei' — no alias needed, it's already good

# hyperfine — benchmark commands
# just 'hyperfine "cmd"'

# =============================================================================
#  GENERAL ALIASES
# =============================================================================
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias reload='exec zsh'
alias paths='print -l $path'
alias h='history -50'
alias clr='clear && printf "\e[3J"'
alias vim='nvim'
alias v='nvim'
alias vf='nvim $(fzf)'

# safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# quick edit configs
alias zshrc='nvim ~/.zshrc && reload'
alias nvimrc='nvim "${XDG_CONFIG_HOME}/nvim/init.lua"'
alias starshiprc='nvim "${XDG_CONFIG_HOME}/starship.toml"'

# systemd (on non-systemd Gentoo with openrc, these won't exist — harmless)
alias sc='sudo systemctl'
alias scu='systemctl --user'
alias jc='journalctl -xe'

# Portage / Gentoo
alias emerge='sudo emerge'
alias eup='sudo emerge --ask --verbose --update --deep --newuse @world'
alias esync='sudo emaint -a sync'
alias eclean='sudo eclean-dist -d && sudo eclean-pkg -d'
alias epkg='eix'
alias edepclean='sudo emerge --ask --depclean && sudo revdep-rebuild'
alias einfo='emerge --info'
alias elog='sudo elogv'

# Git
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
#  FUNCTIONS
# =============================================================================

# cd → auto ls (only in interactive shells)
[[ -o interactive ]] && cd() { builtin cd "$@" && ls }

# mkdir + cd
mkcd() { mkdir -p "$1" && cd "$1" }

# Extract anything
extract() {
  local f="$1"
  [[ ! -f $f ]] && { print -P "%F{#D9534F}✗ not a file: $f%f"; return 1 }
  case "$f" in
    *.tar.bz2|*.tbz2) tar xjf  "$f" ;;
    *.tar.gz|*.tgz)   tar xzf  "$f" ;;
    *.tar.xz|*.txz)   tar xJf  "$f" ;;
    *.tar.zst)         tar --zstd -xf "$f" ;;
    *.tar)             tar xf   "$f" ;;
    *.bz2)             bunzip2  "$f" ;;
    *.gz)              gunzip   "$f" ;;
    *.zip)             unzip    "$f" ;;
    *.7z)              7z x     "$f" ;;
    *.rar)             unrar x  "$f" ;;
    *.zst)             zstd -d  "$f" ;;
    *.lz4)             lz4 -d   "$f" ;;
    *) print -P "%F{#D9534F}✗ unknown format: $f%f"; return 1 ;;
  esac
}

# fzf-powered process killer
fkill() {
  local pids
  pids=$(ps -eo pid,user,pcpu,pmem,comm --sort=-pcpu \
    | fzf --multi --header-lines=1 \
           --preview 'echo {} | awk "{print \$1}" | xargs -I{} ps --pid={} -o pid,ppid,user,stat,cmd --no-headers 2>/dev/null' \
           --preview-window=down:3 \
    | awk '{print $1}')
  [[ -n $pids ]] && echo "$pids" | xargs kill -${1:-TERM} && echo "sent ${1:-TERM} to: $pids"
}

# fzf cd into any subdir (uses fd)
fj() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude .cargo \
    | fzf --preview 'eza --tree --icons --color=always -L 2 {}') \
    && cd "$dir"
}

# fzf git branch switcher
gbf() {
  local branch
  branch=$(git branch --all --color=always \
    | grep -v HEAD \
    | fzf --ansi --preview 'git log --oneline --color=always $(echo {} | sed "s/remotes\/origin\///" | tr -d "* ")' \
    | sed 's/remotes\/origin\///' | tr -d '* ')
  [[ -n $branch ]] && git switch "$branch"
}

# fzf git log browser
gshow() {
  git log --oneline --decorate --color=always \
    | fzf --ansi --no-sort --reverse --tiebreak=index \
          --preview 'git show --color=always $(echo {} | cut -d" " -f1)' \
          --preview-window=right:60% \
          --bind 'enter:execute(git show --color=always $(echo {} | cut -d" " -f1) | less -RFX)'
}

# Quick HTTP server
serve() {
  local port="${1:-8000}"
  print -P "%F{#73D216}  Serving %F{#DDDAEC}$(pwd)%F{#6E56AF} → http://localhost:$port%f"
  python3 -m http.server "$port"
}

# Show which process is using a port
port() {
  local p="$1"
  [[ -z $p ]] && { echo "usage: port <number>"; return 1 }
  ss -tulpn | grep ":$p" || echo "nothing on port $p"
}

# Quick system stats (no bling, just data)
sysinfo() {
  local k="%F{#6E56AF}" v="%F{#DDDAEC}" r="%f"
  print -P "\n  ${k}os        ${r}${v}$(uname -sr)${r}"
  print -P "  ${k}shell     ${r}${v}zsh $ZSH_VERSION${r}"
  print -P "  ${k}user      ${r}${v}$(whoami)@$(hostname -s)${r}"
  print -P "  ${k}uptime    ${r}${v}$(uptime -p 2>/dev/null || uptime | sed 's/.*up \([^,]*\).*/\1/')${r}"
  command -v free &>/dev/null && \
    print -P "  ${k}ram       ${r}${v}$(free -h | awk '/^Mem/{printf "%s / %s (%.0f%%)", $3, $2, $3/$2*100}')${r}"
  print -P "  ${k}disk      ${r}${v}$(df -h / | awk 'NR==2{printf "%s / %s (%s)", $3, $2, $5}')${r}"
  command -v emerge &>/dev/null && \
    print -P "  ${k}pkgs      ${r}${v}$(qlist -I 2>/dev/null | wc -l) installed${r}"
  print
}

# Run cmd and notify when done (for long builds)
notify_done() {
  "$@"
  local exit_code=$?
  if command -v notify-send &>/dev/null; then
    if [[ $exit_code -eq 0 ]]; then
      notify-send -u normal "✓ Done" "$1 finished"
    else
      notify-send -u critical "✗ Failed" "$1 exited $exit_code"
    fi
  fi
  return $exit_code
}
alias nd='notify_done'

# Find and replace in files (rg + sed)
frep() {
  local from="$1" to="$2"
  [[ -z $from || -z $to ]] && { echo "usage: frep <from> <to> [path]"; return 1 }
  local files
  files=$(rg -l "$from" ${3:-.}) || return 0
  echo "$files" | while IFS= read -r f; do
    sed -i "s|${from}|${to}|g" "$f" && echo "  patched: $f"
  done
}

# zoxide wrapper that shows where you're jumping
j() {
  if [[ $# -eq 0 ]]; then
    local dir
    dir=$(zoxide query --list --score | fzf --no-sort \
      --preview 'eza --tree --icons --color=always -L 2 {2}' \
      --preview-window=right:50% | awk '{print $2}')
    [[ -n $dir ]] && cd "$dir"
  else
    __zoxide_z "$@"
  fi
}

# =============================================================================
#  INTEGRATIONS  (all guarded, safe to have even if not installed)
# =============================================================================

# zoxide — smarter cd (replaces autojump/z)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh --no-cmd)" || true

# atuin — shell history with search, sync, stats (replaces CTRL-R)
# Install: curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
  # atuin replaces CTRL-R with its own UI; up-arrow still does substring search
fi

# direnv — per-directory .envrc loading
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# mise — polyglot version manager (replaces nvm/pyenv/rbenv/asdf)
# Install: curl https://mise.run | sh
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
else
  # Fallback: lazy-load nvm only when actually called
  if [[ -s "${NVM_DIR}/nvm.sh" ]]; then
    nvm()  { unfunction nvm node npm npx yarn pnpm; source "${NVM_DIR}/nvm.sh"; nvm "$@" }
    node() { unfunction nvm node npm npx yarn pnpm; source "${NVM_DIR}/nvm.sh"; node "$@" }
    npm()  { unfunction npm;  source "${NVM_DIR}/nvm.sh"; npm "$@" }
    npx()  { unfunction npx;  source "${NVM_DIR}/nvm.sh"; npx "$@" }
  fi
  # lazy pyenv
  if command -v pyenv &>/dev/null; then
    pyenv() { unfunction pyenv; eval "$(command pyenv init -)"; pyenv "$@" }
  fi
fi

# navi — interactive cheatsheet (Ctrl+G)
# Install: cargo install navi  OR  emerge dev-util/navi
if command -v navi &>/dev/null; then
  eval "$(navi widget zsh)"
fi

# thefuck — command correction
command -v thefuck &>/dev/null && eval "$(thefuck --alias f)"

# =============================================================================
#  LS_COLORS
# =============================================================================
if command -v vivid &>/dev/null; then
  export LS_COLORS="$(vivid generate one-dark 2>/dev/null)"
elif command -v dircolors &>/dev/null; then
  eval "$(dircolors -b)"
fi

# =============================================================================
#  TERMINAL TITLE
# =============================================================================
_title_precmd()  { print -Pn '\e]0;%~\a' }
_title_preexec() { printf '\e]0;%s\a' "${1:0:60}" }
precmd_functions+=(_title_precmd)
preexec_functions+=(_title_preexec)

# =============================================================================
#  STARSHIP  (must be last — it hooks precmd/preexec)
#  Install: curl -sS https://starship.rs/install.sh | sh
#  Config:  ~/.config/starship.toml
# =============================================================================
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  # Minimal fallback prompt (no external deps)
  PROMPT='%F{#6E56AF}%~%f %(?:%F{#73D216}❯%f:%F{#D9534F}❯%f) '
  RPROMPT='%F{#54487A}%*%f'
  print -P "%F{#D9534F}  starship not found — run:%f %F{#73D216}curl -sS https://starship.rs/install.sh | sh%f"
fi

eval "$(/home/starlith/.local/bin/mise activate zsh)"

