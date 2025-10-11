#!/bin/bash
source ~/.resonantia_env
LATEST=\$(ls -t \$RESONANTIA_ARCHIVE/*.gpg 2>/dev/null | head -n 1)
SIG_FILE="\${LATEST}.sig"

if [ -f "\$LATEST" ] && [ -f "\$SIG_FILE" ]; then
    echo "🔍 Verifying \$LATEST..."
    gpg --verify "\$SIG_FILE" "\$LATEST"
    if [ \$? -eq 0 ]; then
        echo "✅ Signature valid: archive integrity confirmed." | tee -a "\$RESONANTIA_LOG"
    else
        echo "❌ Signature mismatch: archive integrity compromised." | tee -a "\$RESONANTIA_LOG"
    fi
else
    echo "⚠️ No valid archive/signature pair found." | tee -a "\$RESONANTIA_LOG"
fi
