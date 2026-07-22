# Some envs
export XDG_CONFIG_HOME="$HOME/.config"
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# Helpers
# =============================================================================

path_prepend() {
  [[ -n "$1" ]] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

path_append() {
  [[ -n "$1" ]] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$PATH:$1" ;;
  esac
}

zsh_warn() {
  [[ -o interactive ]] || return 0
  print -u2 "zsh warning: $*"
}

# =============================================================================
# Platform
# =============================================================================

OS="$(uname)"
case "$OS" in
  Linux)
    OS="Linux"
    alias ls='ls --color=auto'
    ;;
  FreeBSD)
    OS="FreeBSD"
    alias ls='ls -G'
    ;;
  WindowsNT)
    OS="Windows"
    ;;
  Darwin)
    OS="Mac"
    ;;
  SunOS)
    OS="Solaris"
    ;;
esac
export OS

# =============================================================================
# Environment and PATH
# =============================================================================

export HOME_PATH="$HOME"
export PROJECTS_PATH="$HOME/Documents/projects"
export WORK_PATH="$HOME/Documents/corgi"
export BLOCKCHAIN_PATH="$WORK_PATH/blockchain"
export BCH_MONOREPO_PATH="$BLOCKCHAIN_PATH/bch-monorepo"
export MY_MAIN_EDITOR="code"

export KUBECONFIG="$HOME/.kube/alt-dev.yaml:$HOME/.kube/shimbo-prod.json:$HOME/.kube/dev.json:$HOME/.kube/simpleswap-prod.json:$HOME/.kube/kyc-prod.yaml"

path_append "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/go/bin"
path_append "$HOME/.lmstudio/bin"

export PNPM_HOME="$HOME/Library/pnpm"
path_prepend "$PNPM_HOME"

export BUN_INSTALL="$HOME/.bun"
path_prepend "$BUN_INSTALL/bin"

# =============================================================================
# Oh My Zsh
# =============================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

plugins=(
  git
  npm
  node
  yarn
  ubuntu
  docker
  zsh-syntax-highlighting
  zsh-autosuggestions
  aws
  kubectl
  macos
  colorize
  vi-mode
  pnpm-shell-completion
  autoupdate
)

if [[ -s "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  zsh_warn "oh-my-zsh not found at $ZSH"
fi

# =============================================================================
# Aliases
# =============================================================================

alias zshconfig="vim ~/.zshrc"
alias zshreload="source ~/.zshrc"
alias szsh="source ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias snippets="vim ~/.snippets"
alias guides="vim ~/.guides"
alias oo="opencode ."
alias ooempty="cd $PROJECTS_PATH/empty && opencode ."
alias emptyopencode="cd $PROJECTS_PATH/empty && opencode ."
alias opencodeconfig="vim ~/.config/opencode/opencode.json"
alias ghostconfig='vim "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"'
alias ghosttyconfig='vim "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"'
alias suggest="gh copilot suggest -- bash"
alias lintf="npm run lint:fix"
alias startd="npm run start:dev"
alias llmconfig="code ~/llm-configs"

# Dotfiles bare repository helper.
alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# Git.
alias gi="git init"
alias gs="git status -sbu"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gp="git push"
alias gm="git merge"
alias ga="git add ."
alias gcm="git commit -m"
alias gfp="git fetch && git pull"
alias gst="git stash"
alias gstl="git stash list"
alias glg='git log --graph --oneline --decorate --all'
alias gcdev='git checkout develop'
alias gpuh='git push -u origin HEAD'
alias gback='git checkout -'

# Docker.
alias dgrep="docker ps | grep"

# Claude.
alias claude-dev-ce='claude --plugin-dir ~/code/compound-engineering-plugin/plugins/compound-engineering'
claude() {
  HTTPS_PROXY="$CLAUDE_HTTPS_PROXY" command claude "$@"
}

# =============================================================================
# Project-specific
# =============================================================================

alias start_corgi_services="cd $PROJECTS_PATH/deploy-local && docker-compose up"

declare -A monorepo_apps=(
  [daemon_worker]="daemon-worker"
  [daemon_controller]="daemon-controller"
  [d-controller]="d-controller"
  [user-deposit]="user-deposit"
  [sender]="tx-sender"
  [event-handler]="event-handler"
  [compliance]="compliance"
  [mempool]="mempool"
  [bchprovider]="blockchain-provider"
  [chain_clients]="chains-client"
  [generator]="address-generator"
  [confirmations]="confirmations"
)

for key in "${(@k)monorepo_apps}"; do
  alias "code_$key"="$MY_MAIN_EDITOR $BCH_MONOREPO_PATH/apps/${monorepo_apps[$key]}"
done

alias code_monorepo="$MY_MAIN_EDITOR $BLOCKCHAIN_PATH/blockchain_monorepo"
alias monorepo="$MY_MAIN_EDITOR $BLOCKCHAIN_PATH/blockchain_monorepo"
alias cdrepo="cd $BLOCKCHAIN_PATH/blockchain_monorepo"

# Quick SQLite query on remote server.
dbq() {
  ssh macbook-server "sqlite3 /Users/sharingan/.openclaw/workspace/repos/blockchain/apps/balance-crawler/database.sqlite \"$1\""
}

# =============================================================================
# Tools
# =============================================================================

# NVM.
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
elif [[ "$OS" == "Mac" ]] && command -v brew >/dev/null 2>&1; then
  nvm_prefix="$(brew --prefix nvm 2>/dev/null)"
  [[ -s "$nvm_prefix/nvm.sh" ]] && source "$nvm_prefix/nvm.sh"
  unset nvm_prefix
fi
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# GVM.
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Google Cloud SDK.
export GOOGLE_SDK_PATH="$HOME/Downloads/google-cloud-sdk"
[[ -f "$GOOGLE_SDK_PATH/path.zsh.inc" ]] && source "$GOOGLE_SDK_PATH/path.zsh.inc"
[[ -f "$GOOGLE_SDK_PATH/completion.zsh.inc" ]] && source "$GOOGLE_SDK_PATH/completion.zsh.inc"

# Bun completions.
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# pyenv.
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init - zsh)"
fi

# =============================================================================
# Keybindings
# =============================================================================

bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# =============================================================================
# Validation
# =============================================================================

zsh_validate_env() {
  [[ "${ZSH_VALIDATE_ENV:-1}" == "1" ]] || return 0

  local name value kube_file
  for name in HOME_PATH PROJECTS_PATH WORK_PATH BLOCKCHAIN_PATH BCH_MONOREPO_PATH MY_MAIN_EDITOR KUBECONFIG PNPM_HOME BUN_INSTALL; do
    value="${(P)name}"
    [[ -n "$value" ]] || zsh_warn "$name is not set"
  done

  if [[ -n "$KUBECONFIG" ]]; then
    for kube_file in "${(@ps/:/)KUBECONFIG}"; do
      [[ -f "$kube_file" ]] || zsh_warn "KUBECONFIG file not found: $kube_file"
    done
  fi

  command -v zoxide >/dev/null 2>&1 || zsh_warn "zoxide is not installed; cd history jump will not work"
  command -v pyenv >/dev/null 2>&1 || zsh_warn "pyenv is not installed; Python version switching will not work"

  if [[ -z "$CLAUDE_HTTPS_PROXY" ]]; then
    zsh_warn "CLAUDE_HTTPS_PROXY is not set; claude will run without proxy"
  fi
}

zsh_validate_env

# =============================================================================
# Prompt and final hooks
# =============================================================================

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zoxide should stay near the end of the shell configuration.
export _ZO_DOCTOR=0
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/milex/.lmstudio/bin"
# End of LM Studio CLI section
