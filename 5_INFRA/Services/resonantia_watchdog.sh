#!/bin/bash
# 🜂 Resonantia Watchdog — Integrity Guardian

source ~/.resonantia_env
LOG="$RESONANTIA_HOME/0_OPERATIONS/Logbook/Continuum_Watchdog.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "🧭 [$DATE] Resonantia Watchdog active..." >> "$LOG"

for FILE in $RESONANTIA_ARCHIVE/*.gpg; do
    SIG="$FILE.sig"
    if [ -f "$FILE" ]; then
        if [ -f "$SIG" ]; then
            gpg --verify "$SIG" "$FILE" > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "✅ [$DATE] Verified: $(basename "$FILE")" >> "$LOG"
            else
                echo "❌ [$DATE] WARNING: Signature mismatch for $(basename "$FILE")" >> "$LOG"
            fi
        else
            echo "⚠️ [$DATE] Missing signature for $(basename "$FILE")" >> "$LOG"
        fi
    fi
done

echo "────────────────────────────────────────────" >> "$LOG"
