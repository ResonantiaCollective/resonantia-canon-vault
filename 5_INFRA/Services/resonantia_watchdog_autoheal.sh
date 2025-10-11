#!/bin/bash
# 🜂 Resonantia Watchdog Auto-Heal — Autonomous Archive Integrity Restoration
# Integrates with: resonantia_watchdog.sh + resonantia_sign.sh

source ~/.resonantia_env
LOG="$RESONANTIA_HOME/0_OPERATIONS/Logbook/Continuum_Watchdog.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "🧬 [$DATE] Auto-Heal Watchdog scanning..." >> "$LOG"

for FILE in "$RESONANTIA_ARCHIVE"/*.gpg; do
    [ -f "$FILE" ] || continue
    SIG="$FILE.sig"

    # If missing signature, auto-sign
    if [ ! -f "$SIG" ]; then
        echo "⚠️ [$DATE] Missing signature — healing $(basename "$FILE")..." >> "$LOG"
        gpg --batch --yes --local-user "$RESONANTIA_GPG_KEY" --output "$SIG" --detach-sign "$FILE"
        echo "✅ [$DATE] Re-signed $(basename "$FILE")" >> "$LOG"
    else
        # Verify existing signature
        gpg --verify "$SIG" "$FILE" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "❌ [$DATE] Signature mismatch — re-signing $(basename "$FILE")..." >> "$LOG"
            rm -f "$SIG"
            gpg --batch --yes --local-user "$RESONANTIA_GPG_KEY" --output "$SIG" --detach-sign "$FILE"
            echo "✅ [$DATE] Signature restored for $(basename "$FILE")" >> "$LOG"
        else
            echo "🟢 [$DATE] Verified: $(basename "$FILE")" >> "$LOG"
        fi
    fi
done

echo "────────────────────────────────────────────" >> "$LOG"
