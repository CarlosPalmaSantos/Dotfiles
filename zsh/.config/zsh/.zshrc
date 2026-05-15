export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

DEFAULT_USER="$USER"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi --height 40% --layout=reverse --border"

plugins=(
  git 
  sudo 
  archlinux  
  zsh-autosuggestions
  fzf-tab
)

source $ZSH/oh-my-zsh.sh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh


