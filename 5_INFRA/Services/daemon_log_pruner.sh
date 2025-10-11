#!/bin/bash
# ⚙️ daemon_log_pruner.sh — Automatic Log Compaction
LOGDIR="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook"
MAXSIZE=1048576  # 1 MB per log file

for FILE in "$LOGDIR"/*.log; do
    if [ -f "$FILE" ]; then
        SIZE=$(stat -c%s "$FILE")
        if (( SIZE > MAXSIZE )); then
            echo "🧹 $(date '+%Y-%m-%d %H:%M:%S') Pruning $(basename "$FILE") (size: $SIZE bytes)" >> "$FILE"
            tail -n 500 "$FILE" > "${FILE}.tmp" && mv "${FILE}.tmp" "$FILE"
        fi
    fi
done
