#!/bin/sh
set -e

# ─── Logging ────────────────────────────────────────────────────────────────
info()  { printf "\x1b[34m>> %s\x1b[0m\n"        "$1"; }
warn()  { printf "\033[33m>> %s\x1b[0m\n"        "$1"; }
error() { printf "\x1b[31m>> ERROR: %s\x1b[0m\n" "$1"; exit 1; }

# ─── Helpers ─────────────────────────────────────────────────────────────────

# Installs a package via yay if the command is not already present.
# Usage: install_pkg <command> [package-name]
#   If package-name is omitted, the command name is used as the package name.
install_pkg() {
    CMD="$1"
    PKG="${2:-$1}"
    if command -v "$CMD" >/dev/null 2>&1; then
        warn "'$CMD' is already installed."
    else
        info "Installing '$PKG'..."
        yay -S --needed --noconfirm "$PKG"
        info "'$PKG' installed successfully."
    fi
}

# Clones and installs a ZSH plugin into oh-my-zsh/custom/plugins if not present.
# Usage: install_zsh_plugin <name> <repo-url>
install_zsh_plugin() {
    NAME="$1"
    REPO_URL="$2"
    PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$NAME"
    if [ -d "$PLUGIN_DIR" ]; then
        warn "ZSH plugin '$NAME' is already installed."
    else
        info "Installing ZSH plugin '$NAME'..."
        git clone --depth=1 "$REPO_URL" "$PLUGIN_DIR"
        info "Plugin '$NAME' installed successfully."
    fi
}

# ─── Paths ───────────────────────────────────────────────────────────────────
ROOT_DIR="$PWD"
TMP_DIR="$ROOT_DIR/tmp"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# ─── Dependencies ────────────────────────────────────────────────────────────
info "Updating system and installing base dependencies..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel git

mkdir -p "$TMP_DIR"

# ─── AUR helper (yay) ────────────────────────────────────────────────────────
# yay must be bootstrapped with makepkg, so it needs its own block.
if command -v yay >/dev/null 2>&1; then
    warn "'yay' is already installed."
else
    info "Installing 'yay'..."
    git clone https://aur.archlinux.org/yay-bin.git "$TMP_DIR/yay-bin"
    (cd "$TMP_DIR/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$TMP_DIR/yay-bin"
    info "'yay' installed successfully."
fi

# ─── Tools ───────────────────────────────────────────────────────────────────
install_pkg bat
install_pkg stow

# ─── ZSH ─────────────────────────────────────────────────────────────────────
install_pkg zsh

# Change default shell to zsh
if [ "$SHELL" = "/usr/bin/zsh" ] || [ "$SHELL" = "/bin/zsh" ]; then
    warn "Zsh is already your default shell."
else
    info "Changing default shell to zsh..."
    chsh -s "$(command -v zsh)"
    info "Default shell changed to zsh."
fi

# Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    warn "Oh My Zsh is already installed."
else
    info "Installing Oh My Zsh..."
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
    info "Oh My Zsh installed successfully."
fi

# ZSH plugins
install_zsh_plugin "zsh-autosuggestions"     "https://github.com/zsh-users/zsh-autosuggestions"
install_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"

# ─── Apps ────────────────────────────────────────────────────────────────────
install_pkg neovim
install_pkg kitty

# ─── KDE ─────────────────────────────────────────────────────────────────────
info "Configuring KDE..."

# Set kitty as default terminal
kwriteconfig6 --file kdeglobals --group General --key TerminalApplication kitty
kwriteconfig6 --file kdeglobals --group General --key TerminalService kitty.desktop

# Free up Ctrl+Alt+T from Konsole
kwriteconfig6 --file kglobalshortcutsrc \
    --group "org.kde.konsole.desktop" \
    --key "_launch" \
    "none,none,Konsole"

# Bind Ctrl+Alt+T to kitty
kwriteconfig6 --file kglobalshortcutsrc \
    --group "kitty-shortcut.desktop" \
    --key "_launch" \
    "Ctrl+Alt+T,none,Kitty Terminal"

# Reload shortcuts daemon
kquitapp6 kglobalaccel && kglobalaccel6 &

info "KDE configured successfully."

# ─── Dotfiles ─────────────────────────────────────────────────────────────────
info "Deploying dotfiles with GNU Stow..."
cd "$ROOT_DIR"
stow -R zsh   -t "$HOME"
stow -R nvim  -t "$HOME"
stow -R kitty -t "$HOME"
info "Dotfiles linked successfully."

# ─── Cleanup ──────────────────────────────────────────────────────────────────
info "Cleaning up temporary files..."
rm -rf "$TMP_DIR"
info "Done."
