#!/bin/bash
# ⚙️ init_local_git.sh — Resonantia Canon Loop Initializer

REPO_DIR="$HOME/RESONANTIA_MASTER"
LOG_FILE="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook/Command_Log_GitInit.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

cd "$REPO_DIR" || exit 1

echo "🜂 Initializing Resonantia Canon Git Loop..."
echo "[$DATE] — Initializing local git repository in $REPO_DIR" >> "$LOG_FILE"

# Configure user identity
git config --global user.name "Commandant Resonantia"
git config --global user.email "commandant.resonantia@proton.me"

# Initialize repository if not already
if [ ! -d ".git" ]; then
    git init >> "$LOG_FILE" 2>&1
    echo "✅ Git repository initialized." >> "$LOG_FILE"
else
    echo "⚙️ Git repository already exists — skipping init." >> "$LOG_FILE"
fi

# Stage and commit all files
git add . >> "$LOG_FILE" 2>&1
git commit -m "🜂 INITIAL CANON SNAPSHOT — Genesis of Resonantia Master System" >> "$LOG_FILE" 2>&1

# Add remote (without push)
git remote remove origin 2>/dev/null
git remote add origin https://github.com/ResonantiaCollective/resonantia-canon-vault.git
echo "🔗 Remote origin set to: ResonantiaCollective/resonantia-canon-vault" >> "$LOG_FILE"

echo "────────────────────────────────────────────" >> "$LOG_FILE"
echo "✅ Canon Git Loop established locally at $DATE" >> "$LOG_FILE"
echo "────────────────────────────────────────────"
echo "🜂 Resonantia Canon Git Loop — Ready for first push."
