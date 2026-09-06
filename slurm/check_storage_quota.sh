#!/usr/bin/env bash
# Script to check CephFS storage quotas and current usage for user paths
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

uv run --quiet python3 - "$@" << 'PYEOF'
import os
import sys

# Default paths to check if no arguments provided
default_paths = [f'/home/{os.environ["USER"]}', f'/spinning/{os.environ["USER"]}']
paths = sys.argv[1:] if len(sys.argv) > 1 else default_paths

# Terminal ANSI colors
GREEN = '\033[92m'
YELLOW = '\033[93m'
RED = '\033[91m'
BOLD = '\033[1m'
RESET = '\033[0m'

# Check if stdout is interactive (tty) for colors
use_color = sys.stdout.isatty()

def fmt_color(text, color):
    return f"{color}{text}{RESET}" if use_color else text

print(f"\n{BOLD}{'Directory':<22} {'Used (GB)':<12} {'Quota (GB)':<12} {'Usage':<8} {'Progress Bar':<24} {'Files':<10}{RESET}")
print("─" * 92)

for p in paths:
    p_clean = os.path.abspath(p)
    if not os.path.exists(p_clean):
        print(f"{p_clean:<22} Directory not found")
        continue
    try:
        rbytes = int(os.getxattr(p_clean, 'ceph.dir.rbytes'))
        rfiles = int(os.getxattr(p_clean, 'ceph.dir.rfiles'))
    except Exception as e:
        print(f"{p_clean:<22} {fmt_color(f'Error reading xattrs: {e}', RED)}")
        continue
    
    try:
        max_bytes = int(os.getxattr(p_clean, 'ceph.quota.max_bytes'))
    except Exception:
        max_bytes = 0

    used_gb = rbytes / 1e9
    used_str = f"{used_gb:.2f}"
    
    if max_bytes > 0:
        quota_gb = max_bytes / 1e9
        quota_str = f"{quota_gb:.2f}"
        pct = (rbytes / max_bytes) * 100
        pct_str = f"{pct:.1f}%"
        
        # Color coding based on usage percentage
        if pct >= 90:
            pct_colored = fmt_color(f"{pct_str:<8}", RED + BOLD)
            color_bar = RED
        elif pct >= 75:
            pct_colored = fmt_color(f"{pct_str:<8}", YELLOW + BOLD)
            color_bar = YELLOW
        else:
            pct_colored = fmt_color(f"{pct_str:<8}", GREEN)
            color_bar = GREEN

        bar_len = 20
        filled = int(bar_len * (rbytes / max_bytes))
        filled = min(max(filled, 0), bar_len)
        raw_bar = '[' + '█' * filled + '░' * (bar_len - filled) + ']'
        bar_colored = fmt_color(raw_bar, color_bar)
    else:
        quota_str = "Unlimited"
        pct_colored = f"{'N/A':<8}"
        bar_colored = fmt_color('[' + '░' * 20 + ']', GREEN)

    files_str = f"{rfiles:,}"
    print(f"{p_clean:<22} {used_str:<12} {quota_str:<12} {pct_colored} {bar_colored:<24} {files_str:<10}")

print()
PYEOF
