#!/bin/bash
# 🜂 verify_continuum_integrity.sh — Codex Continuum Integrity Sentinel

REPO_DIR="$HOME/RESONANTIA_MASTER"
LOG_FILE="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook/Continuum_Verification.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "🧭 [$DATE] Initiating Resonantia Continuum Integrity Check..." >> "$LOG_FILE"

# Check for running daemon
if systemctl is-active --quiet codex-continuum.service; then
    echo "✅ Daemon active and watching filesystem." >> "$LOG_FILE"
else
    echo "⚠️ Daemon inactive — attempting restart..." >> "$LOG_FILE"
    sudo systemctl restart codex-continuum.service
    sleep 3
    if systemctl is-active --quiet codex-continuum.service; then
        echo "🟢 Restart successful." >> "$LOG_FILE"
    else
        echo "🔴 Restart failed. Manual intervention required." >> "$LOG_FILE"
    fi
fi

# Check Git synchronization
cd "$REPO_DIR" || exit 1
git fetch origin >> "$LOG_FILE" 2>&1
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @ @{u})

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "✅ Local and remote branches are synchronized." >> "$LOG_FILE"
elif [ "$LOCAL" = "$BASE" ]; then
    echo "⚠️ Local branch behind remote — pulling updates..." >> "$LOG_FILE"
    git pull >> "$LOG_FILE" 2>&1
elif [ "$REMOTE" = "$BASE" ]; then
    echo "⚠️ Local ahead of remote — pushing commits..." >> "$LOG_FILE"
    git push >> "$LOG_FILE" 2>&1
else
    echo "⚠️ Local and remote have diverged — manual merge needed." >> "$LOG_FILE"
fi

echo "────────────────────────────────────────────" >> "$LOG_FILE"
echo "🜂 Continuum Integrity Check Complete."
echo "Log stored at: $LOG_FILE"
