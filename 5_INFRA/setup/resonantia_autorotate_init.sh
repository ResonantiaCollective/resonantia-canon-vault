#!/bin/bash
# 🜂 Resonantia Auto-Rotation & Encryption Setup
# Creates ~/.resonantia_env and all supporting scripts

BASE="$HOME/RESONANTIA_MASTER"
SETUP_DIR="$BASE/5_INFRA/Services"
LOG_DIR="$BASE/0_OPERATIONS/Logbook"
ARCHIVE_DIR="$BASE/4_ASSETS/Archive/Encrypted"

mkdir -p "$SETUP_DIR" "$LOG_DIR" "$ARCHIVE_DIR"

# --- Create environment file ---
cat << 'ENV' > ~/.resonantia_env
# 🜂 Resonantia Environment Variables
RESONANTIA_HOME="$HOME/RESONANTIA_MASTER"
RESONANTIA_LOG="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook/Continuum_Rotation.log"
RESONANTIA_GPG_KEY="resonantia_ops@the-loom"
RESONANTIA_ARCHIVE="$HOME/RESONANTIA_MASTER/4_ASSETS/Archive/Encrypted"
RESONANTIA_GIT_BRANCH="master"
ENV

# --- Key Generation Script ---
cat << 'KEYGEN' > "$SETUP_DIR/resonantia_keygen.sh"
#!/bin/bash
source ~/.resonantia_env
DATE=\$(date '+%Y-%m-%d_%H%M')
KEY_FILE="\$RESONANTIA_ARCHIVE/key_\$DATE.asc"

echo "🔐 Generating Resonantia encryption keypair..."
gpg --batch --quick-gen-key "\$RESONANTIA_GPG_KEY" rsa4096 encr
gpg --export-secret-keys "\$RESONANTIA_GPG_KEY" > "\$KEY_FILE"
chmod 600 "\$KEY_FILE"
echo "✅ Key archived at \$KEY_FILE" | tee -a "\$RESONANTIA_LOG"
KEYGEN

# --- Auto-Rotation Script ---
cat << 'ROTATE' > "$SETUP_DIR/resonantia_autorotate.sh"
#!/bin/bash
source ~/.resonantia_env
DATE=\$(date '+%Y-%m-%d_%H:%M:%S')
echo "🔄 [\$DATE] Starting auto-rotation..." | tee -a "\$RESONANTIA_LOG"

# Generate new keys
bash \$RESONANTIA_HOME/5_INFRA/Services/resonantia_keygen.sh

# Encrypt Codex Archive
tar -czf /tmp/codex_\$DATE.tar.gz -C \$RESONANTIA_HOME 1_CANON
gpg --encrypt --recipient "\$RESONANTIA_GPG_KEY" /tmp/codex_\$DATE.tar.gz
mv /tmp/codex_\$DATE.tar.gz.gpg \$RESONANTIA_ARCHIVE/
rm /tmp/codex_\$DATE.tar.gz

echo "🗝️ Codex encrypted and archived." | tee -a "\$RESONANTIA_LOG"
ROTATE

# --- Cronloop Script ---
cat << 'CRON' > "$SETUP_DIR/resonantia_cronloop.sh"
#!/bin/bash
# Adds auto-rotation to cron (every 12 hours)
( crontab -l 2>/dev/null; echo "0 */12 * * * bash \$HOME/RESONANTIA_MASTER/5_INFRA/Services/resonantia_autorotate.sh" ) | crontab -
echo "🕰️ Auto-rotation scheduled every 12h via cron."
CRON

chmod +x "$SETUP_DIR"/*.sh
echo "✅ Setup complete. Review ~/.resonantia_env and scripts in $SETUP_DIR before running."
