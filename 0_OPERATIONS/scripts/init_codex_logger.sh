#!/bin/bash
# 🜂 init_codex_logger.sh — Resonantia Codex Logging System

LOG_DIR="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook"
LOG_FILE="$LOG_DIR/Codex_History.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

mkdir -p "$LOG_DIR"

echo "📜 [$DATE] Codex Update Logged" >> "$LOG_FILE"

# Optionally attach details from most recent map or file changes
if [ -f "$HOME/RESONANTIA_MASTER/1_CANON/CODEX_MAP_v1.0.md" ]; then
    echo "🜂 CODEX_MAP Snapshot:" >> "$LOG_FILE"
    grep -E "^\•|^🜂|^────────────────" "$HOME/RESONANTIA_MASTER/1_CANON/CODEX_MAP_v1.0.md" >> "$LOG_FILE"
fi

echo "────────────────────────────────────────────" >> "$LOG_FILE"
echo "✅ Codex update recorded in: $LOG_FILE"
