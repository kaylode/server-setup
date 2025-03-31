#!/bin/bash

# Exit on error to prevent unexpected failures
set -e

# Initialize job count and name
COUNT=1
JOB_NAME="interactive1"

# Check if a job with the given name already exists
NO_LINES=$(squeue -u "$USER" --name="$JOB_NAME" | wc -l)

# Increment job name until we find an available name, exit if count exceeds 3
while [[ $NO_LINES -gt 1 ]]
do
   COUNT=$(( COUNT + 1 ))
   if [[ $COUNT -gt 3 ]]; then
       echo "Error: Maximum job count exceeded (3). Exiting."
       exit 1
   fi
   JOB_NAME="interactive$COUNT"
   NO_LINES=$(squeue -u "$USER" --name="$JOB_NAME" | wc -l)
done

# Determine GPU resource allocation
if [[ -z "$1" ]]; then
    GPUs="gpu:1"  # Default to 1 GPU if no argument is provided
else
    GPUs="gpu:$1:2"  # Use the provided number of GPUs
fi

# Submit the Slurm job with the determined job name and GPU resources
sbatch --gres=$GPUs -J "$JOB_NAME" ~/workspace/source/slurm/salloc.job

# Wait a few seconds to ensure the job appears in the queue
sleep 5

# Print allocated node and port information
squeue -u "$USER" --name="$JOB_NAME"


# Retrieve job status and allocated resources
echo "Start SSH-ing into.."
State=$(squeue -u "$USER" --name="$JOB_NAME" -O State | awk 'END{print}')
Reason=$(squeue -u "$USER" --name="$JOB_NAME" -O Reason | awk 'END{print}')
nodelist=$(squeue -u "$USER" --name="$JOB_NAME" --states=R -h -O NodeList)
PORT=$(squeue -u "$USER" --name="$JOB_NAME" -h -O Comment)

echo "Allocated node list: $nodelist at port $PORT"

# Attempt to SSH into the allocated node if the job is running
if [[ "$State" -eq "RUNNING" ]]; then
    if [[ -n "$PORT" ]]; then
        ssh -o StrictHostKeychecking=no -p $PORT $USER@$nodelist
    else
        echo "Error: No valid port found for SSH."
    fi
else
    echo "Failed to SSH. Node status: ($State). Due to ($Reason)"
fi
