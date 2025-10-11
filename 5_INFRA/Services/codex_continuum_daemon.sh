#!/bin/bash
# 🜂 Codex Continuum Daemon v1.0 — Auto Commit & Push Loop
REPO="$HOME/RESONANTIA_MASTER"
LOG="$REPO/0_OPERATIONS/Logbook/Continuum_Daemon.log"

cd "$REPO" || exit 1
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Daemon start." >> "$LOG"

while inotifywait -r -e modify,create,delete,move "$REPO"; do
  DATE=$(date '+%Y-%m-%d %H:%M')
  git add -A
  git commit -m "🜂 Auto-update via Continuum Daemon @ $DATE" >> "$LOG" 2>&1
  git push origin master >> "$LOG" 2>&1
  echo "[$DATE] Push completed." >> "$LOG"
done
