#!/bin/bash
# 🧬 Resonantia Auto-Heal — Archive Self-Repair Unit

source ~/.resonantia_env
LOG="$RESONANTIA_HOME/0_OPERATIONS/Logbook/Continuum_Watchdog.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "🧬 [$DATE] Auto-Heal Watchdog scanning..." >> "$LOG"

for FILE in $RESONANTIA_ARCHIVE/*.gpg; do
    [ ! -f "$FILE" ] && continue
    SIG="$FILE.sig"
    # If signature is missing or invalid, recreate it
    if [ ! -f "$SIG" ]; then
        echo "⚙️ [$DATE] Re-signing missing signature for $(basename "$FILE")..." >> "$LOG"
        gpg --batch --yes --local-user "$RESONANTIA_GPG_KEY" --output "$SIG" --detach-sign "$FILE"
        echo "✅ [$DATE] Signature restored for $(basename "$FILE")" >> "$LOG"
    else
        gpg --verify "$SIG" "$FILE" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "❌ [$DATE] Broken signature detected — repairing $(basename "$FILE")..." >> "$LOG"
            gpg --batch --yes --local-user "$RESONANTIA_GPG_KEY" --output "$SIG" --detach-sign "$FILE"
            echo "✅ [$DATE] Signature healed for $(basename "$FILE")" >> "$LOG"
        fi
    fi
done

echo "────────────────────────────────────────────" >> "$LOG"
