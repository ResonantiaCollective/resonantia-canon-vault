#!/bin/bash
# 🜂 codex_push_guard.sh — Safe Git Commit/Push Queue with Cooldown
LOCKFILE="$HOME/RESONANTIA_MASTER/.git/.pushlock"
LOGFILE="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook/Continuum_Daemon.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

if [ -f "$LOCKFILE" ]; then
    echo "⚠️  [$DATE] Push skipped — lock active, waiting 60s." >> "$LOGFILE"
    sleep 60
    [ -f "$LOCKFILE" ] && echo "⚠️  [$DATE] Still locked — skipping to avoid conflict." >> "$LOGFILE" && exit 0
fi

touch "$LOCKFILE"
echo "🜂 [$DATE] Push lock acquired." >> "$LOGFILE"

cd "$HOME/RESONANTIA_MASTER" || exit 1
git add 0_OPERATIONS/Logbook/* > /dev/null 2>&1
git commit -m "🜂 Auto-update via Continuum Daemon @ $(date '+%Y-%m-%d %H:%M')" >> "$LOGFILE" 2>&1

if git push origin master >> "$LOGFILE" 2>&1; then
    echo "✅ [$DATE] Push completed successfully." >> "$LOGFILE"
else
    echo "❌ [$DATE] Push failed — pulling + retry..." >> "$LOGFILE"
    git pull --rebase >> "$LOGFILE" 2>&1
    git push origin master >> "$LOGFILE" 2>&1
fi

rm -f "$LOCKFILE"
echo "🜂 [$DATE] Lock released." >> "$LOGFILE"
sleep 30
