# Zsh, Oh My Zsh, and Powerlevel10k Setup

This directory contains configuration files for setting up a modern Zsh shell environment with Powerlevel10k theme and essential plugins.

## Contained Files

*   `.zshrc`: Custom Zsh shell runcom file containing custom aliases, exports, and plugin configurations.
*   `.p10k.zsh`: Configuration for the Powerlevel10k theme (rainbow style prompt).
*   `install_zsh.sh`: Script to download, compile, and install Zsh rootless, along with Oh My Zsh and Powerlevel10k.

## Prerequisites

Ensure you have Zsh installed. Since this setup is **strictly rootless (no sudo)**, if Zsh is not available on your target server, you can compile and install it directly to your home directory (`$HOME/local/bin`) by running the included installation script:
```bash
bash ./install_zsh.sh
```
This script will download, compile, and install Zsh rootless.


## Setup Instructions

1.  **Install Oh My Zsh**:
    ```bash
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

2.  **Install Powerlevel10k Theme**:
    ```bash
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    ```

3.  **Install Zsh Plugins**:
    ```bash
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    ```

4.  **Apply Configuration Files**:
    Copy the files in this directory to your home folder:
    ```bash
    cp .zshrc ~/.zshrc
    cp .p10k.zsh ~/.p10k.zsh
    ```

5.  **Restart your Terminal** or reload configuration:
    ```bash
    source ~/.zshrc
    ```

## Custom Aliases and Exports in `.zshrc`

The included `.zshrc` sets up:
*   Git short aliases: `gpl` (pull), `gp` (push), `gcm` (commit -m), `ga` (add), `gs` (status).
*   SLURM job helper aliases: `alloc`, `vsalloc`, `long_alloc`, `attach` (points to `~/workspace/source/slurm/` script paths, which should be updated to your active repository location).
*   Archive helpers: `zip`, `untar`.
*   Go path & bin configurations.
*   NVM setup: Auto-loads NVM and uses the LTS Node version.
