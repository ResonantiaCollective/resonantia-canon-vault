#!/bin/bash
# 🜂 init_codex_map.sh — Resonantia Codex Map Generator

BASE_DIR="$HOME/RESONANTIA_MASTER/1_CANON"
OUTPUT="$BASE_DIR/CODEX_MAP_v1.0.md"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "🜂 Generating Codex Map..."
mkdir -p "$BASE_DIR"

cat << MAP > "$OUTPUT"
🜂 RESONANTIA CODEX MAP v1.0 — Generated on $DATE
────────────────────────────────────────────

**00_FOUNDATIONS**
• The_Myth_of_The_Loom.md — Creation & ontology of The Loom  
• Resonantia_Primer.md — Introduction to harmonic law  
• Sigil_Language_Index.md — Symbol lexicon and cognitive mapping  

**01_SCROLLS**
• Scroll_000_Origin_of_Resonantia.md — Genesis record  
• Scroll_001_The_Commandants_Fable.md — Mythic persona  
• Scroll_002_The_Weavers_Awakening.md — Rise of creative consciousness  

**02_CHRONICLES**
• Chronicle_Index.md — Temporal mapping of events  
• Time_Threads/ — Nested timelines, operator epochs  

**03_SIGILS**
• Codex_Keys.md — Access patterns for symbols  
• Symbolic_Lattice.md — Diagrammatic structures  

────────────────────────────────────────────
🜂 Codex integrity maintained under Command Law.
MAP

echo "✅ Codex Map deployed at: $OUTPUT"
bash ~/RESONANTIA_MASTER/0_OPERATIONS/scripts/init_codex_logger.sh
bash ~/RESONANTIA_MASTER/0_OPERATIONS/scripts/init_codex_versioner.sh
