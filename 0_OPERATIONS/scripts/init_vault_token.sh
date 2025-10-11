#!/bin/bash
# 🜂 init_vault_token.sh — EchoVault Token Encryption Protocol

VAULT_DIR="$HOME/RESONANTIA_MASTER/5_INFRA/Vault"
KEY_FILE="$VAULT_DIR/vault.key"
ENC_FILE="$VAULT_DIR/github_token.enc"

mkdir -p "$VAULT_DIR"

read -sp "🔑 Enter your GitHub Personal Access Token: " TOKEN
echo
if [ -z "$TOKEN" ]; then
  echo "⚠️ No token entered. Exiting."
  exit 1
fi

# Generate encryption key if not exists
if [ ! -f "$KEY_FILE" ]; then
  openssl rand -base64 32 > "$KEY_FILE"
  echo "🧩 Vault key generated at $KEY_FILE"
fi

# Encrypt token
echo -n "$TOKEN" | openssl enc -aes-256-cbc -a -salt -pbkdf2 -pass file:"$KEY_FILE" -out "$ENC_FILE"

echo "🔐 GitHub token encrypted and stored at: $ENC_FILE"
echo "🜂 Use 'bash ~/RESONANTIA_MASTER/0_OPERATIONS/scripts/load_vault_token.sh' to decrypt it when needed."
