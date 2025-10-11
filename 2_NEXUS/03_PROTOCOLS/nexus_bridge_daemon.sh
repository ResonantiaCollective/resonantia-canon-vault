#!/bin/bash
# 🜂 NEXUS ↔ CONTINUUM BRIDGE DAEMON
# Logs successful Continuum Daemon pushes into Nexus Principia

source ~/.resonantia_env
CANON_LOG="$RESONANTIA_HOME/0_OPERATIONS/Logbook/Continuum_Daemon.log"
NEXUS_LOG="$RESONANTIA_HOME/2_NEXUS/00_CORE/Nexus_Principia.md"
BRIDGE_LOG="$RESONANTIA_HOME/0_OPERATIONS/Logbook/NEXUS_BRIDGE.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "🧭 [$DATE] NEXUS Bridge active..." | tee -a "$BRIDGE_LOG"

tail -Fn0 "$CANON_LOG" | \
while read LINE; do
    if echo "$LINE" | grep -q "✅" && echo "$LINE" | grep -q "Push completed successfully"; then
        HASH=$(git -C "$RESONANTIA_HOME" rev-parse HEAD)
        echo "[$DATE] 🜂 Canon update synced — commit $HASH" | tee -a "$BRIDGE_LOG"
        echo "### 🜂 Canon Sync @ $DATE" >> "$NEXUS_LOG"
        echo "- Commit: $HASH" >> "$NEXUS_LOG"
        echo "- Verified by Continuum Bridge Daemon" >> "$NEXUS_LOG"
        echo "" >> "$NEXUS_LOG"
        git -C "$RESONANTIA_HOME" add "$NEXUS_LOG"
        git -C "$RESONANTIA_HOME" commit -m "🜂 Nexus Bridge Sync @ $DATE"
        git -C "$RESONANTIA_HOME" push origin master
    fi
done
