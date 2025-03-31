if [ -z "$1" ]
    then
        GPUs="gpu:1"
    else
        GPUs="gpu:$1:1"
fi

    # --nodelist=g128 \
salloc  \
    --cpus-per-task=16 \
    --mem=250000 \
    --partition=compute \
    --gres=$GPUs \
    srun --pty bash -i
