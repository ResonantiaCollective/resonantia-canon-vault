#!/bin/bash
# 🜂 init_codex_versioner.sh — Resonantia Codex Auto-Version System

CODEX_DIR="$HOME/RESONANTIA_MASTER/1_CANON"
ARCHIVE_DIR="$CODEX_DIR/ARCHIVE"
MAP_FILE="$CODEX_DIR/CODEX_MAP_v1.0.md"
DATE=$(date '+%Y-%m-%d_%H%M')
VERSION_FILE="$ARCHIVE_DIR/CODEX_MAP_$DATE.md"

mkdir -p "$ARCHIVE_DIR"

if [ -f "$MAP_FILE" ]; then
    cp "$MAP_FILE" "$VERSION_FILE"
    echo "🜂 Archived current CODEX_MAP → $VERSION_FILE"
else
    echo "⚠️ CODEX_MAP not found — skipping archive."
fi

# Log version creation
LOG_FILE="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook/Codex_History.log"
echo "🗝️ [$DATE] Codex Map version archived → $VERSION_FILE" >> "$LOG_FILE"
echo "────────────────────────────────────────────" >> "$LOG_FILE"
