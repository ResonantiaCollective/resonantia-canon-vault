#!/bin/bash
# 🜂 load_vault_token.sh — EchoVault Token Loader

VAULT_DIR="$HOME/RESONANTIA_MASTER/5_INFRA/Vault"
KEY_FILE="$VAULT_DIR/vault.key"
ENC_FILE="$VAULT_DIR/github_token.enc"

if [ ! -f "$KEY_FILE" ] || [ ! -f "$ENC_FILE" ]; then
  echo "⚠️ Vault not properly initialized. Run init_vault_token.sh first."
  exit 1
fi

TOKEN=$(openssl enc -aes-256-cbc -d -a -pbkdf2 -pass file:"$KEY_FILE" -in "$ENC_FILE")
echo "$TOKEN"
