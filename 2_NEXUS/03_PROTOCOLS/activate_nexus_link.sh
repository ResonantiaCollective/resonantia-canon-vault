#!/bin/bash
# 🜂 activate_nexus_link.sh — Nexus↔Canon Synchronization Protocol
source ~/.resonantia_env

NEXUS="$HOME/RESONANTIA_MASTER/2_NEXUS"
CANON="$HOME/RESONANTIA_MASTER/1_CANON"
LOG="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook/NEXUS_LEDGER.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "🧭 [$DATE] Activating Nexus↔Canon link..." | tee -a "$LOG"

# Check symbolic links
if [ -L "$NEXUS/01_LINKS/CANON_LINK" ] && [ -L "$NEXUS/01_LINKS/OPS_LINK" ]; then
    echo "✅ Links verified." | tee -a "$LOG"
else
    echo "❌ Symbolic link failure detected." | tee -a "$LOG"
    exit 1
fi

# Generate and log Canon summary hash
HASH=$(find "$CANON" -type f -exec sha256sum {} \; | sha256sum | cut -d ' ' -f1)
echo "🜂 Canon Integrity Hash: $HASH" | tee -a "$LOG"

# Store hash snapshot
echo "$DATE | $HASH" >> "$NEXUS/00_CORE/Canon_Hash_History.log"

# Optional: Trigger Watchdog re-verification
if [ -x "$HOME/RESONANTIA_MASTER/5_INFRA/Services/resonantia_watchdog.sh" ]; then
    bash "$HOME/RESONANTIA_MASTER/5_INFRA/Services/resonantia_watchdog.sh"
    echo "🜂 Watchdog sync initiated." | tee -a "$LOG"
fi

echo "✅ [$DATE] Nexus Link Protocol active and verified." | tee -a "$LOG"
echo "────────────────────────────────────────────" >> "$LOG"
