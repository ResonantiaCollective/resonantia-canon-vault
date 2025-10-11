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
bash ~/RESONANTIA_MASTER/5_INFRA/Services/key_lifecycle_monitor.sh

# === NEXUS LINK BIND ===
NEXUS_PROTOCOL="$HOME/RESONANTIA_MASTER/2_NEXUS/03_PROTOCOLS/activate_nexus_link.sh"
if [ -x "$NEXUS_PROTOCOL" ]; then
    echo "🜂 [$(date '+%Y-%m-%d %H:%M:%S')] Triggering Nexus↔Canon synchronization..." >> "$RESONANTIA_HOME/0_OPERATIONS/Logbook/Continuum_Daemon.log"
    bash "$NEXUS_PROTOCOL"
else
    echo "⚠️ [$(date '+%Y-%m-%d %H:%M:%S')] Nexus Protocol missing or not executable." >> "$RESONANTIA_HOME/0_OPERATIONS/Logbook/Continuum_Daemon.log"
fi
bash $HOME/RESONANTIA_MASTER/5_INFRA/Services/codex_push_lock.sh
