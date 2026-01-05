#!/usr/bin/env bash

set -e

echo "🔍 Detecting operating system..."
OS="$(uname -s)"


git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


install_linux() {
  echo "Installing for Linux..."
  sudo apt update && sudo apt upgrade -y

  sudo apt install -y stow
  sudo apt install -y tmux

  # Add Linux-specific installation commands here
  # Example: sudo apt-get install some-package
}

install_macos() {
  echo "Installing for macOS..."
  # Add macOS-specific installation commands here
  # Example: brew install some-package
}

case "$OS" in
  Linux*)
    install_linux
    ;;
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