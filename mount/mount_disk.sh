#!/bin/bash
# mount_disk.sh - Rootless User-space FUSE mounting tool
# Does not require sudo/root privileges.

MOUNT_SRC=$1
MOUNT_DST=$2
MOUNT_TYPE=$3

if [ -z "$MOUNT_SRC" ] || [ -z "$MOUNT_DST" ] || [ -z "$MOUNT_TYPE" ]; then
    echo "Usage: mount_disk.sh <source> <destination> <type>"
    echo "Types (Rootless FUSE):"
    echo "  sshfs   - Mount remote folder over SSH (e.g. user@host:/path)"
    echo "  rclone  - Mount rclone remote (e.g. remote:bucket/path)"
    exit 1
fi

# Check if the destination directory exists/create it
mkdir -p "$MOUNT_DST"

echo "Mounting $MOUNT_SRC to $MOUNT_DST using rootless FUSE ($MOUNT_TYPE)..."

case "$MOUNT_TYPE" in
    sshfs)
        if ! command -v sshfs &> /dev/null; then
            echo "Error: sshfs is not installed."
            echo "Install rootless via Conda/Micromamba: 'micromamba install sshfs -c conda-forge'"
            exit 1
        fi
        sshfs "$MOUNT_SRC" "$MOUNT_DST" -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
        ;;
    rclone)
        if ! command -v rclone &> /dev/null; then
            echo "Error: rclone is not installed."
            echo "Download binary rootless: 'curl https://rclone.org/install.sh | bash /dev/stdin --user'"
            exit 1
        fi
        rclone mount "$MOUNT_SRC" "$MOUNT_DST" --daemon
        ;;
    *)
        echo "Unsupported rootless mount type: $MOUNT_TYPE"
        echo "If you have root access and want to use standard mount, run:"
        echo "  sudo mount -t $MOUNT_TYPE $MOUNT_SRC $MOUNT_DST"
        exit 1
        ;;
esac

echo "Mount request completed."
