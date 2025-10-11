#!/bin/bash
# 🜂 fix_sign_verify.sh — Clean & correct syntax for signing scripts

BASE_DIR="$HOME/RESONANTIA_MASTER/5_INFRA/Services"

# --- fix resonantia_sign.sh ---
cat << 'SIGN' > "$BASE_DIR/resonantia_sign.sh"
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
SIGN

# --- fix resonantia_verify.sh ---
cat << 'VERIFY' > "$BASE_DIR/resonantia_verify.sh"
#!/bin/bash
source ~/.resonantia_env
LATEST=$(ls -t $RESONANTIA_ARCHIVE/*.gpg 2>/dev/null | head -n 1)
SIG_FILE="${LATEST}.sig"

if [ -f "$LATEST" ] && [ -f "$SIG_FILE" ]; then
    echo "🔍 Verifying $LATEST..."
    gpg --verify "$SIG_FILE" "$LATEST"
    if [ $? -eq 0 ]; then
        echo "✅ Signature valid: archive integrity confirmed." | tee -a "$RESONANTIA_LOG"
    else
        echo "❌ Signature mismatch: archive integrity compromised." | tee -a "$RESONANTIA_LOG"
    fi
else
    echo "⚠️ No valid archive/signature pair found." | tee -a "$RESONANTIA_LOG"
fi
VERIFY

chmod +x "$BASE_DIR"/resonantia_*.sh
echo "✅ Syntax corrected and scripts rebuilt."
