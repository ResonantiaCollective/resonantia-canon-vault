#!/bin/bash
# 🜂 codex_push_guard.sh — Safe Git Commit/Push Queue
LOCKFILE="$HOME/RESONANTIA_MASTER/.git/.pushlock"
LOGFILE="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook/Continuum_Daemon.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

if [ -f "$LOCKFILE" ]; then
    echo "⚠️  [$DATE] Push skipped — lock active, retrying in 45s." >> "$LOGFILE"
    sleep 45
    if [ -f "$LOCKFILE" ]; then
        echo "⚠️  [$DATE] Still locked, skipping push to prevent collision." >> "$LOGFILE"
        exit 0
    fi
fi

touch "$LOCKFILE"
echo "🜂 [$DATE] Push lock acquired." >> "$LOGFILE"

cd "$HOME/RESONANTIA_MASTER" || exit 1
git add 0_OPERATIONS/Logbook/* > /dev/null 2>&1
git commit -m "🜂 Auto-update via Continuum Daemon @ $(date '+%Y-%m-%d %H:%M')" >> "$LOGFILE" 2>&1

# Try push safely
if git push origin master >> "$LOGFILE" 2>&1; then
    echo "✅ [$DATE] Push completed successfully." >> "$LOGFILE"
else
    echo "❌ [$DATE] Push failed — retrying once after 30s..." >> "$LOGFILE"
    sleep 30
    git pull --rebase >> "$LOGFILE" 2>&1
    git push origin master >> "$LOGFILE" 2>&1
fi

rm -f "$LOCKFILE"
echo "🜂 [$DATE] Lock released." >> "$LOGFILE"
