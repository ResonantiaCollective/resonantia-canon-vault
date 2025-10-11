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
