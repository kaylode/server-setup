#!/bin/bash
# install_micromamba.sh - Install Micromamba rootless in the home directory

set -e

echo "Downloading and extracting Micromamba..."
mkdir -p "$HOME/bin"
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj -C "$HOME" bin/micromamba

export MAMBA_ROOT_PREFIX="$HOME/micromamba"
echo "Initializing Micromamba shell hook for Zsh..."
"$HOME/bin/micromamba" shell init -s zsh -r "$MAMBA_ROOT_PREFIX"

# Append conda-forge channel
echo "Configuring conda-forge channel..."
"$HOME/bin/micromamba" config append channels conda-forge

echo "Micromamba installed successfully. Please restart your shell or run 'source ~/.zshrc' to use it."
