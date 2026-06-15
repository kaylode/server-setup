#!/bin/bash

# Determine GPU resource allocation
if [[ -z "$1" ]]; then
    GPUs="gpu:1"  # Default to 1 GPU if no argument is provided
else
    GPUs="gpu:$1:1"  # Use the provided number of GPUs
fi

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sbatch "$SCRIPT_DIR/vscode.job"

wait 5

# Get nodelist from squeue output
nodelist=$(squeue -u $USER -n vscode | awk 'NR>1 {print $8}' | tr '\n' ',' | sed 's/,$//')
# Print nodelist
echo "Allocated node list: $nodelist"
