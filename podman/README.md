# Podman Container Stacks Setup & Control

This directory contains utility scripts to manage FSDS container stacks using rootless Podman.

## Contained Files

*   `run_podman.sh`: The centralized controller script to run Podman compose commands (`up`, `down`, `ps`, etc.) for different container stacks.
*   `build_spark_image.sh`: Builds local Spark image.
*   `build_airflow_image.sh`: Builds local Airflow image.
*   `build_inference_image.sh`: Builds inference service container image.
*   `fix_deadlock.sh`: Helper script to address potential Linux lockups or cgroups deadlock issues when running rootless containers.

## Configuration & Usage

The control script (`run_podman.sh`) manages different service stacks (e.g. `core`, `airflow`, `datahub`) with common Docker Compose commands:

```bash
# Start the core stack
./run_podman.sh core up -d

# Stop the core stack
./run_podman.sh core down

# Start the Airflow stack
./run_podman.sh airflow up -d

# Show running containers
./run_podman.sh ps
```

### Script Internals

*   The script reads environment variables from a `.env` file in the project root.
*   It configures local socket directories under `/tmp/fsds-run-$USER`.
*   It automatically attempts to pull pre-built images from remote registries or falls back to compiling them locally if missing.
*   It uses virtual environment or system-installed `podman-compose` automatically.
