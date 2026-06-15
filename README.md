# New Server Setup

This repository contains scripts and configuration templates to assist in setting up a clean, high-performance developer workspace on a new GPU/CPU server. **All scripts and tools are designed to run in userspace (rootless), requiring absolutely no `sudo` or root privileges.**

## Directory Structure

*   **`dotfiles/`**: Zsh source installer (`install_zsh.sh`), Zsh and Powerlevel10k configuration files (`.zshrc`, `.p10k.zsh`), and setup documentation.
*   **`slurm/`**: Cluster job scheduling scripts, node tunneling configurations, and quick diagnostic utilities.
*   **`podman/`**: Scripts for building and running application/orchestration stacks (Spark, Airflow, Inference) under rootless Podman.
*   **`installations/`**: Software setup guides and installation scripts.
    - `install_npm.sh`: Script to automatically install NVM (Node Version Manager) and Node.js/NPM LTS.
    - `install_micromamba.sh`: Script to install Conda/Micromamba rootless.
    - `gdrive.md`: Guide to setting up Google Drive CLI client.
    - `udocker.md`: Running Docker containers as a rootless user.
    - `miniforge.sh`: Script for installing Conda/Miniforge.
    - `wsl_gpu.md`: Setup configurations for GPU in WSL.
*   **`cli/`**: Miscellaneous command-line helpers.
    - `active.sh`: CUDA activation script.
    - `disk.sh`: Quick depth-1 disk usage analyzer.
    - `hfd.sh` / `hfd.md`: Multi-process Hugging Face model downloader.
    - `gpu_new.sh` / `gpu_find.sh`: Helpers for locating/starting GPU jobs.
*   **`mount/`**: Script files for mounting/unmounting disks.

## Getting Started

1.  **Zsh Shell & Dotfiles**: Go to the [dotfiles](dotfiles/README.md) directory to set up Zsh, Oh My Zsh, Powerlevel10k, and copy your custom `.zshrc`.
2.  **Node/NPM Setup**: Run `./installations/install_npm.sh` to install NVM and Node LTS.
3.  **SLURM Job Setup**: Use scripts inside the [slurm](slurm/README.md) folder to configure interactive or background nodes.
4.  **Podman Stack**: See the [podman](podman/README.md) directory to build and run containerized services.
