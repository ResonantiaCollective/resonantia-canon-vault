#!/bin/bash
# 🜂 continuum_loop.sh — Resonantia Canon Sync System

REPO_DIR="$HOME/RESONANTIA_MASTER"
LOG_FILE="$REPO_DIR/0_OPERATIONS/Logbook/Command_Log_Continuum.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
VERSION_TAG="v$(date '+%y.%m.%d_%H%M')"

cd "$REPO_DIR" || exit 1

echo "⚙️ [$DATE] Continuum Loop Initiated" >> "$LOG_FILE"

# Git integrity check
if [ ! -d ".git" ]; then
    echo "❌ Git repo not initialized — aborting sync." | tee -a "$LOG_FILE"
    exit 1
fi

# Stage all modified and new files
git add -A

# Commit changes
if git diff --cached --quiet; then
    echo "🜂 No new changes detected — skipping commit." | tee -a "$LOG_FILE"
else
    git commit -m "🜂 Canon Continuum Update — $DATE" >> "$LOG_FILE" 2>&1
    echo "✅ Committed updates to local Canon." | tee -a "$LOG_FILE"
fi

# Push to GitHub
git push origin master >> "$LOG_FILE" 2>&1
if [ $? -eq 0 ]; then
    echo "🛰️ Synced successfully with GitHub." | tee -a "$LOG_FILE"
else
    echo "⚠️ Push failed — check authentication or network." | tee -a "$LOG_FILE"
fi

# Version tag (optional, for snapshotting)
git tag -a "$VERSION_TAG" -m "Automated Continuum Sync $DATE" >> "$LOG_FILE" 2>&1
git push origin "$VERSION_TAG" >> "$LOG_FILE" 2>&1

echo "🗝️ [$DATE] Continuum Sync complete — tag: $VERSION_TAG" >> "$LOG_FILE"
echo "────────────────────────────────────────────" >> "$LOG_FILE"
