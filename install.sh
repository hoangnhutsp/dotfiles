#!/usr/bin/env bash

set -e

echo "🔍 Detecting operating system..."
OS="$(uname -s)"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_macos() {
  echo "Installing for macOS..."

  if ! command -v brew >/dev/null 2>&1; then
    echo "❌ Homebrew is required. Install it from https://brew.sh and rerun this script."
    exit 1
  fi

  brew install stow tmux neovim fzf bat zoxide kubectl go nvm
  brew install --cask wezterm font-inconsolata-nerd-font temurin@21

  mkdir -p "$HOME/.tmux/plugins"
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi

  # The Zsh config expects Oh My Zsh and its plugins in these locations.
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  fi
  mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git \
      "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  fi
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
  fi

  # Homebrew's nvm package is loaded by the existing ~/.nvm paths in .zshrc.
  mkdir -p "$HOME/.nvm"
  if [ ! -e "$HOME/.nvm/nvm.sh" ]; then
    ln -s "$(brew --prefix nvm)/nvm.sh" "$HOME/.nvm/nvm.sh"
  fi
  if [ ! -e "$HOME/.nvm/bash_completion" ]; then
    ln -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" \
      "$HOME/.nvm/bash_completion"
  fi

  (cd "$DOTFILES_DIR" && stow --target="$HOME" zsh tmux wezterm)

  defaults write com.apple.finder _FXShowPosixPathInTitle -bool NO
  killall Finder
}

case "$OS" in
  Darwin*)
    install_macos
    ;;
  *)
    echo "❌ Unsupported OS: $OS"
    exit 1
    ;;
esac

echo "================================="
echo "✅ Installed successfully"
