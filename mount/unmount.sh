#!/bin/bash
# unmount.sh - Rootless User-space FUSE unmount tool
# Does not require sudo.

MOUNT_DST=$1

if [ -z "$MOUNT_DST" ]; then
    echo "Usage: unmount.sh <destination_directory>"
    exit 1
fi

echo "Unmounting $MOUNT_DST rootless using fusermount..."

if command -v fusermount &> /dev/null; then
    fusermount -u "$MOUNT_DST"
elif command -v fusermount3 &> /dev/null; then
    fusermount3 -u "$MOUNT_DST"
else
    echo "fusermount not found. Attempting generic umount..."
    umount "$MOUNT_DST"
fi

if [ -d "$MOUNT_DST" ]; then
    rmdir "$MOUNT_DST" 2>/dev/null || echo "Directory $MOUNT_DST could not be removed (might not be empty)."
fi