# SLURM Workspace Job Scheduling & Management

This directory contains scripts and batch templates to allocate compute resources (CPUs, GPUs), spawn SSH sessions on compute nodes, and manage SLURM jobs on the cluster.

## Script Overview

*   `alloc.sh`: The consolidated, unified resource allocation script. It manages interactive allocations, background SSH daemon tunnels, VSCode remote tunnels, and reattaching to active jobs.
*   `SLURM.md`: Quick reference list of commonly used SLURM commands.

## Common Command Aliases

We recommend adding the following alias to your `.zshrc`:

```bash
alias alloc="bash \$SERVER_SETUP_DIR/slurm/alloc.sh"
```

also add quota checking to bin

```bash
ln -s $SERVER_SETUP_DIR/slurm/stq_script.sh ~/.local/bin/stq
chmod +x ~/.local/bin/stq
```

## How to use the `alloc` command

The unified script accepts arguments as `KEY=VALUE` pairs or subcommands:

### 1. Default Interactive Allocation
```bash
alloc
```
*(Default settings: partition `compute`, 4 CPUs, 30GB RAM, 1 GPU)*

### 2. Long Partition / Long-Running Background Jobs
Spawns a background SLURM job running an SSH daemon on a dynamic port, waits for it to start, and automatically SSH connects you into it:
```bash
alloc TYPE=long
```

### 3. Customize GPU Resources
Specify the number of GPUs or target hardware type:
```bash
alloc GPU=2            # Request 2 default GPUs
alloc GPU=a100         # Request 1 a100 GPU
alloc GPU=rtx2080ti:2  # Request 2 rtx2080ti GPUs
```

### 4. Customize Memory and CPU Allocations
```bash
alloc MEM=100000       # Request 100GB of RAM memory
alloc CPUS=8           # Request 8 CPU cores
```

### 5. Target a Specific Node
```bash
alloc NODE=g120        # Forces allocation on node g120
```

### 6. VSCode Remote Development allocation
Preconfigured for VSCode tunnels:
```bash
alloc TYPE=vscode
```

### 7. Attach to an Active Job
Re-opens an SSH connection to an active background job by Job ID or Job Name:
```bash
alloc attach 123456
alloc attach alloc_job
```
