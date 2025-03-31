#!/bin/bash

# Exit on error to prevent unexpected failures
set -e

# Initialize job count and name
COUNT=$1
JOB_NAME="interactive${COUNT}"

# Print allocated node and port information
squeue -u "$USER" --name="$JOB_NAME"

# Retrieve job status and allocated resources
State=$(squeue -u "$USER" --name="$JOB_NAME" -O State | awk 'END{print}')
Reason=$(squeue -u "$USER" --name="$JOB_NAME" -O Reason | awk 'END{print}')
nodelist=$(squeue -u "$USER" --name="$JOB_NAME" --states=R -h -O NodeList)
PORT=$(squeue -u "$USER" --name="$JOB_NAME" -h -O Comment)

echo "Start SSH-ing into.. node=$nodelist port=$PORT"

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