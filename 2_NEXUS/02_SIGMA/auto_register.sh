#!/bin/bash
BASE="$HOME/RESONANTIA_MASTER"
NEXUS="$BASE/2_NEXUS"
LOG="$BASE/0_OPERATIONS/Logbook/NEXUS_LEDGER.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
TARGET="$1"

if [ -z "$TARGET" ]; then
    echo "⚠️ No target specified for registration." | tee -a "$LOG"
    exit 1
fi

echo "🔗 [$DATE] Registered module → $TARGET" | tee -a "$LOG"
echo "$TARGET" >> "$NEXUS/02_SIGMA/NEXUS_INDEX.txt"
