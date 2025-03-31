sbatch ~/workspace/source/slurm/vscode.job

wait 5

# Get nodelist from squeue output
nodelist=$(squeue -u $USER -n vscode | awk 'NR>1 {print $8}' | tr '\n' ',' | sed 's/,$//')
# Print nodelist
echo "Allocated node list: $nodelist"
