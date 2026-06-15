# Zsh, Oh My Zsh, and Powerlevel10k Setup

This directory contains configuration files for setting up a modern Zsh shell environment with Powerlevel10k theme and essential plugins.

## Contained Files

*   `.zshrc`: Custom Zsh shell runcom file containing custom aliases, exports, and plugin configurations.
*   `.p10k.zsh`: Configuration for the Powerlevel10k theme (rainbow style prompt).

## Prerequisites

Ensure you have Zsh installed. If not, see the Zsh installation section in the SLURM directory (`init_workspace.sh`) or install via package manager:
```bash
sudo apt install zsh -y # Debian/Ubuntu
# or
sudo dnf install zsh -y # Fedora/RHEL
```

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
