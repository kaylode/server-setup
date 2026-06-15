
- Check storage use:
```
du -h -a --max-depth 0 $HOME
```

- Submit a job
```
sbatch example.job --gres=gpu:rtx2080ti:2
```

- Interactive mode
```
salloc -P compute -J kaylode --cpus-per-task=8 --gres=gpu:1 srun --pty bash -i
```

- Working directory of current job
```
scontrol show job <job_id>
```

--gres=gpu:rtx2080ti:{n}
--gres=gpu:rtxa6000:{n}
--gres=gpu:a100:{n}