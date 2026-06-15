# SLURM Workspace Job Scheduling & Management

This directory contains scripts and batch templates to allocate compute resources (CPUs, GPUs), spawn SSH sessions on compute nodes, and manage SLURM jobs on the cluster.

## Script Overview

*   `init_workspace.sh`: A shell script that installs Zsh, Oh My Zsh, Powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting, and Micromamba to set up a clean workspace directory on the cluster.
*   `salloc.sh`: Allocates GPU/CPU resources interactively and starts an interactive terminal.
*   `salloc_long.sh` / `salloc.job`: Submits a background job to start a persistent SSH daemon on an allocated GPU node, retrieves the allocated node & port number, and SSHs directly into the workspace.
*   `attach.sh`: Re-attaches to a running SSH job by name.
*   `vsalloc.sh` / `vscode.job`: Allocates resources and configures a node specifically for remote VSCode connection.
*   `slurm.sh`: A command-line helper script to quickly inspect queue state, partition maxtime, node limits, user resource usage, and scancel jobs.
*   `SLURM.md`: Quick reference list of commonly used SLURM commands.

## Common Command Aliases

We recommend adding the following aliases to your `.zshrc` (adjust paths as necessary):

```bash
alias alloc="bash ~/workspace/source/slurm/salloc.sh"
alias vsalloc="bash ~/workspace/source/slurm/vsalloc.sh"
alias long_alloc="bash ~/workspace/source/slurm/salloc_long.sh"
alias attach="bash ~/workspace/source/slurm/attach.sh"
```

## Quick Reference Commands

### Interactive Allocations
To allocate a GPU node interactively:
```bash
salloc -P compute -J interactive --cpus-per-task=8 --gres=gpu:1 srun --pty bash -i
```

### Checking Cluster State
To check node status, memory allocations, partition maxtimes, and running jobs:
```bash
./slurm.sh info
```

### Kill All User Jobs
To cancel all jobs under your user account:
```bash
./slurm.sh kill
```
