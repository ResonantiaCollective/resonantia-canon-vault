#!/bin/bash
# 🜂 Resonantia CLI Dashboard — Continuum Visual Signal

source ~/.resonantia_env
LOG_DIR="$RESONANTIA_HOME/0_OPERATIONS/Logbook"
WATCHDOG_LOG="$LOG_DIR/Continuum_Watchdog.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

clear
echo "────────────────────────────────────────────"
echo "🜂 RESONANTIA CONTINUUM STATUS — $DATE"
echo "────────────────────────────────────────────"

# 1. Check for archives
if ls $RESONANTIA_ARCHIVE/*.gpg >/dev/null 2>&1; then
    echo "📦 Archives present:"
    for FILE in $RESONANTIA_ARCHIVE/*.gpg; do
        SIG="$FILE.sig"
        BASENAME=$(basename "$FILE")
        if [ -f "$SIG" ]; then
            gpg --verify "$SIG" "$FILE" >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "   🟢 Verified: $BASENAME"
            else
                echo "   🔴 Corrupted: $BASENAME"
            fi
        else
            echo "   🟡 Unsigned: $BASENAME"
        fi
    done
else
    echo "⚠️  No archives found in $RESONANTIA_ARCHIVE"
fi

# 2. Display watchdog heartbeat
if pgrep -f resonantia_watchdog.sh >/dev/null; then
    echo "💠 Watchdog: 🟢 Active"
else
    echo "💠 Watchdog: 🔴 Inactive"
fi

# 3. Show latest log tail
if [ -f "$WATCHDOG_LOG" ]; then
    echo "────────────────────────────────────────────"
    echo "🧭 Latest Watchdog Events:"
    tail -n 5 "$WATCHDOG_LOG"
else
    echo "⚠️  No watchdog log found."
fi

echo "────────────────────────────────────────────"
