#!/bin/bash
# Install NVM (Node Version Manager) and Node.js/NPM LTS

set -e

echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# Load NVM into current shell session for verification/installation
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo "Installing Node.js LTS (includes npm)..."
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

echo "Verification:"
echo "Node version: $(node -v)"
echo "NPM version: $(npm -v)"
echo "NVM installed successfully and Node.js LTS setup complete."
