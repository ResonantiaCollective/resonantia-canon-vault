#!/bin/bash
source ~/.resonantia_env
DATE=\$(date '+%Y-%m-%d_%H%M')
KEY_FILE="\$RESONANTIA_ARCHIVE/key_\$DATE.asc"

echo "🔐 Generating Resonantia encryption keypair..."
gpg --batch --quick-gen-key "\$RESONANTIA_GPG_KEY" rsa4096 encr
gpg --export-secret-keys "\$RESONANTIA_GPG_KEY" > "\$KEY_FILE"
chmod 600 "\$KEY_FILE"
echo "✅ Key archived at \$KEY_FILE" | tee -a "\$RESONANTIA_LOG"
