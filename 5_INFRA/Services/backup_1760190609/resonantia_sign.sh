#!/bin/bash
source ~/.resonantia_env
DATE=$(date '+%Y-%m-%d_%H%M')
LATEST=$(ls -t $RESONANTIA_ARCHIVE/*.gpg 2>/dev/null | head -n 1)
SIG_FILE="${LATEST}.sig"

if [ -f "$LATEST" ]; then
    echo "🔏 Signing archive $LATEST..."
    gpg --batch --yes --local-user "$RESONANTIA_GPG_KEY" --output "$SIG_FILE" --detach-sign "$LATEST"
    echo "✅ [$DATE] Signed $LATEST → $SIG_FILE" | tee -a "$RESONANTIA_LOG"
else
    echo "⚠️ No encrypted archive found to sign." | tee -a "$RESONANTIA_LOG"
fi
