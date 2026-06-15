if [ -z "$1" ]
    then
        GPUs="gpu:1"
    else
        GPUs="gpu:$1:1"
fi
#--nodelist=g121,g122,g123
salloc  \
    --cpus-per-task=2 \
    --mem=1000000 \
    --gres=$GPUs \
    srun --pty bash -i

