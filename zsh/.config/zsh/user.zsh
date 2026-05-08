#  Startup 
#

# Añade estas líneas al final para que cargue la llave automáticamente
zstyle :omz:plugins:ssh-agent identities id_ed25519
zstyle :omz:plugins:ssh-agent lifetime 7d 
zstyle :omz:plugins:ssh-agent agent-forwarding yes

# Busca la línea de plugins y añade ssh-agent
plugins=(git zsh-autosuggestions ssh-agent)

export NVM_DIR="$HOME/.config/nvm"
export VTE_TERMINAL_FEATURES_2020=1
ZSH_THEME="agnoster"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

eval "$(mise activate zsh)"

alias mclone="magin-clone"

# Commands to execute on startup (before the prompt is shown)
# Check if the interactive shell option is set
if [[ $- == *i* && -z "$NVIM" ]]; then
    # This is a good place to load graphic/ascii art, display system information, etc.
 pokego --no-title -r 1,2,3,4,5,6,7,8 | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -
fi

if [ -d /var/lib/flatpak/exports/share ]; then
    export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
fi
if [ -d "$HOME/.local/share/flatpak/exports/share" ]; then
    export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"
fi

export PATH="$PATH:/opt/android-sdk/platform-tools" 

nv() {
  if [ -n "$1" ]; then
    cd "$1" && nvim .
  else 
    nvim .
  fi
}

