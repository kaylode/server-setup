#!/bin/bash

case "$1" in
    info)
        echo ">> Maxtime: "
        sinfo -s
        echo "----------------------------------------"
        echo ">> Node information:"
        sinfo -eO "CPUs:8,Memory:9,Gres:14,NodeAIOT:16,NodeList:50"
        echo "----------------------------------------"
        echo ">> Resources usage:"
        squeue --Format=NodeList | tail -n +2 | sort | uniq -c | sort -nr
        echo "----------------------------------------"
        echo ">> Job information:"
        squeue -u $USER
        ;;
    kill)
        scancel -u $USER
        ;;
    new)
        SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        if [ -f "$SCRIPT_DIR/gpu_new.sh" ]; then
            bash "$SCRIPT_DIR/gpu_new.sh" "$2" "$3"
        else
            bash ~/cli/gpu_new.sh "$2" "$3"
        fi
        ;;
    find)
        SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        if [ -f "$SCRIPT_DIR/gpu_find.sh" ]; then
            bash "$SCRIPT_DIR/gpu_find.sh" "$2" "$3"
        else
            bash ~/cli/gpu_find.sh "$2" "$3"
        fi
        ;;
    *)
        echo "Usage: $0 {info|kill|new|find}"
        exit 1
        ;;
esac
