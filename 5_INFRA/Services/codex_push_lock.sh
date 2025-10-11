#!/bin/bash
# 🜂 codex_push_lock.sh — Prevent concurrent Git pushes
LOCKFILE="$HOME/RESONANTIA_MASTER/.git/.pushlock"
TIMEOUT=30  # seconds

# If a push is in progress, skip
if [ -f "$LOCKFILE" ]; then
    LAST=$(stat -c %Y "$LOCKFILE")
    NOW=$(date +%s)
    if (( NOW - LAST < TIMEOUT )); then
        echo "⚠️  Git push skipped (cool-down active)." >> "$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook/Continuum_Daemon.log"
        exit 0
    fi
fi

touch "$LOCKFILE"

# Perform push safely
cd "$HOME/RESONANTIA_MASTER"
git add 0_OPERATIONS/Logbook/* > /dev/null 2>&1
git commit -m "🜂 Auto-update via Continuum Daemon @ $(date '+%Y-%m-%d %H:%M')" > /dev/null 2>&1
git push origin master >> "$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook/Continuum_Daemon.log" 2>&1

rm -f "$LOCKFILE"
