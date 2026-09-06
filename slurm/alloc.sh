#!/bin/bash
# alloc.sh - Unified SLURM resource allocation and SSH tunneling script
# Supports both interactive allocations and background SSH daemon jobs.
# Does not require any sudo/root privileges.

set -e

# --- Default Parameters ---
TYPE="interactive"       # [interactive | background | vscode | attach]
PARTITION="compute"      # [compute | long | etc.]
GPU="1"                  # Number of GPUs or specific GPU spec (e.g. 1, a100, rtx2080ti:2)
MEM="30000"              # Memory limit in MB
CPUS="4"                 # CPU cores per task
NODE=""                  # Optional specific node (e.g. g120)
TIME="1-00:00:00"        # Execution time limit (e.g. 1-00:00:00)
NAME="alloc_job"         # Job name identifier
MAIL="your email"
SSH_KEY="$HOME/.ssh/id_ed25519"
ATTACH_TARGET=""

# --- Parse Arguments ---
for arg in "$@"; do
    case "$arg" in
        TYPE=*)
            val="${arg#*=}"
            if [[ "$val" == "long" ]]; then
                PARTITION="long"
                TYPE="background"
                TIME="7-00:00:00"
            else
                TYPE="$val"
            fi
            ;;
        PARTITION=*) PARTITION="${arg#*=}" ;;
        GPU=*) GPU="${arg#*=}" ;;
        MEM=*) MEM="${arg#*=}" ;;
        CPUS=*) CPUS="${arg#*=}" ;;
        NODE=*) NODE="${arg#*=}" ;;
        TIME=*) TIME="${arg#*=}" ;;
        NAME=*) NAME="${arg#*=}" ;;
        MAIL=*) MAIL="${arg#*=}" ;;
        attach) TYPE="attach" ;;
        interactive) TYPE="interactive" ;;
        background) TYPE="background" ;;
        vscode) TYPE="vscode" ;;
        *)
            # Treat other positional arguments as potential attach target
            ATTACH_TARGET="$arg"
            ;;
    esac
done

# --- Format GPU string ---
if [[ -n "$GPU" && "$GPU" != "0" ]]; then
    if [[ "$GPU" =~ ^[0-9]+$ ]]; then
        GPUS_ARG="gpu:$GPU"
    elif [[ "$GPU" == *"gpu:"* ]]; then
        GPUS_ARG="$GPU"
    else
        GPUS_ARG="gpu:$GPU:1"
    fi
    GRES_ARG="--gres=$GPUS_ARG"
else
    GRES_ARG=""
fi

# --- Format Node string ---
NODE_ARG=""
if [[ -n "$NODE" ]]; then
    NODE_ARG="--nodelist=$NODE"
fi

# --- Action Execution ---
if [[ "$TYPE" == "interactive" ]]; then
    echo "Starting interactive SLURM session..."
    echo "Allocation: Partition=$PARTITION | CPUs=$CPUS | Mem=$MEM | GPU=$GRES_ARG $NODE_ARG"
    salloc \
        -p "$PARTITION" \
        -t "$TIME" \
        --cpus-per-task="$CPUS" \
        --mem="$MEM" \
        $GRES_ARG \
        $NODE_ARG \
        srun --pty bash -i

elif [[ "$TYPE" == "background" || "$TYPE" == "vscode" ]]; then
    if [[ "$TYPE" == "vscode" ]]; then
        NAME="vscode"
        CPUS="2"
        MEM="30000"
        TIME="2-00:00:00"
    fi

    # Ensure reports directory exists
    mkdir -p "$HOME/slurm_reports"

    # Define wrapper command that spawns sshd on a dynamically allocated free port
    WRAPPER_CMD="PORT=\$(python3 -c 'import socket; s=socket.socket(); s.bind((\"\", 0)); print(s.getsockname()[1]); s.close()'); "
    WRAPPER_CMD+="scontrol update JobId=\"\$SLURM_JOB_ID\" Comment=\"\$PORT\"; "
    WRAPPER_CMD+="echo \"Starting sshd on port \$PORT\"; "
    WRAPPER_CMD+="exec /usr/sbin/sshd -D -p \$PORT -f /dev/null -h \"$SSH_KEY\""

    echo "Submitting background SSH tunneling job '$NAME'..."
    echo "Allocation: Partition=$PARTITION | CPUs=$CPUS | Mem=$MEM | GPU=$GRES_ARG $NODE_ARG"
    
    JOB_ID=$(sbatch \
        -p "$PARTITION" \
        -t "$TIME" \
        --cpus-per-task="$CPUS" \
        --mem="$MEM" \
        $GRES_ARG \
        $NODE_ARG \
        -J "$NAME" \
        --mail-type=FAIL \
        --mail-user="$MAIL" \
        -o "$HOME/slurm_reports/slurm.%x.%j.out" \
        --parsable \
        --wrap="$WRAPPER_CMD")

    echo "Job submitted successfully. JobID: $JOB_ID"
    echo "Waiting for job to enter RUNNING state to connect..."

    # Poll status until running
    for i in {1..30}; do
        STATE=$(squeue -h -j "$JOB_ID" -O State 2>/dev/null | xargs)
        if [[ "$STATE" == "RUNNING" ]]; then
            break
        fi
        sleep 2
    done

    STATE=$(squeue -h -j "$JOB_ID" -O State 2>/dev/null | xargs)
    if [[ "$STATE" != "RUNNING" ]]; then
        echo "Job is currently in state ($STATE). Check logs at $HOME/slurm_reports/slurm.*.$JOB_ID.out"
        squeue -j "$JOB_ID"
        exit 0
    fi

    # Get node and dynamic port
    NODELIST=$(squeue -h -j "$JOB_ID" -O NodeList | xargs)
    PORT=$(squeue -h -j "$JOB_ID" -O Comment | xargs)

    if [[ -z "$PORT" || "$PORT" == "(null)" ]]; then
        echo "Waiting another 5 seconds for SSH port binding comment..."
        sleep 5
        PORT=$(squeue -h -j "$JOB_ID" -O Comment | xargs)
    fi

    echo "============================================="
    echo "Job is RUNNING on node: $NODELIST"
    echo "SSHD dynamic port: $PORT"
    echo "============================================="
    echo "Connecting via SSH..."
    ssh -o StrictHostKeyChecking=no -p "$PORT" "$USER@$NODELIST"

elif [[ "$TYPE" == "attach" ]]; then
    # Default to Name matching ATTACH_TARGET or fallback to looking up running jobs
    
    TARGET_NAME="${ATTACH_TARGET#ATTACH_TARGET=}"
    TARGET_NAME="${ATTACH_TARGET:-alloc_job}"

    # Check if target is a number (JobID) or name
    if [[ "$TARGET_NAME" =~ ^[0-9]+$ ]]; then
        JOB_FILTER="-j $TARGET_NAME"
    else
        JOB_FILTER="--name=$TARGET_NAME"
    fi

    NODELIST=$(squeue -u "$USER" $JOB_FILTER -h -O NodeList 2>/dev/null | xargs)
    PORT=$(squeue -u "$USER" $JOB_FILTER -h -O Comment 2>/dev/null | xargs)
    STATE=$(squeue -u "$USER" $JOB_FILTER -h -O State 2>/dev/null | xargs)

    if [[ -z "$NODELIST" || "$STATE" != "RUNNING" ]]; then
        echo "No running job found matching target: $TARGET_NAME"
        echo "Your current running jobs are:"
        squeue -u "$USER"
        exit 1
    fi

    echo "Attaching to job running on node $NODELIST at port $PORT..."
    ssh -o StrictHostKeyChecking=no -p "$PORT" "$USER@$NODELIST"

else
    echo "Unknown allocation type: $TYPE"
    exit 1
fi
