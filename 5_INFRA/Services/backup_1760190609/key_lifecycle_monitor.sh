#!/bin/bash
# 🜂 key_lifecycle_monitor.sh — SSH Key Integrity Watchdog

LOG_DIR="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook"
LOG_FILE="$LOG_DIR/Key_Audit.log"
KEY_PATH="$HOME/.ssh/resonantia_deploy"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

mkdir -p "$LOG_DIR"

if [ ! -f "$KEY_PATH" ]; then
  echo "⚠️ [$DATE] Deploy key missing at $KEY_PATH" >> "$LOG_FILE"
  exit 1
fi

# Check permissions
PERMS=$(stat -c "%a" "$KEY_PATH")
if [ "$PERMS" != "600" ]; then
  echo "⚠️ [$DATE] Incorrect permissions ($PERMS). Fixing to 600..." >> "$LOG_FILE"
  chmod 600 "$KEY_PATH"
else
  echo "✅ [$DATE] Key permissions verified (600)" >> "$LOG_FILE"
fi

# Check SSH-agent
if ! ssh-add -l | grep -q "$KEY_PATH"; then
  ssh-add "$KEY_PATH" >/dev/null 2>&1
  echo "🗝️ [$DATE] Key re-added to agent." >> "$LOG_FILE"
fi

# Verify GitHub connection
ssh -T git@github.com 2>&1 | grep -q "successfully authenticated" && \
  echo "🜂 [$DATE] GitHub connection verified." >> "$LOG_FILE" || \
  echo "❌ [$DATE] GitHub authentication failed." >> "$LOG_FILE"

echo "────────────────────────────────────────────" >> "$LOG_FILE"
