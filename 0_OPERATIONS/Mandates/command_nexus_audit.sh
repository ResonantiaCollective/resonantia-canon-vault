#!/bin/bash
# 🜂 COMMAND NEXUS AUDITOR v1.0 — Resonantia Core Integrity Check

MANDATE_DIR="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Mandates"
OUTPUT="$MANDATE_DIR/Command_Nexus_Status.md"
TS=$(date '+%Y-%m-%d %H:%M:%S')

declare -A FILES=(
  ["Sovereign_Blueprint_v1.3.md"]="🜂 Sovereign Law"
  ["Aegis_Protocol_v1.0.md"]="⚔️ Operator Protection"
  ["Harmony_Protocol_v1.0.md"]="🜃 Cognitive Balance"
  ["Legacy_Protocol_v1.0.md"]="🜔 Continuity & Archive"
  ["Command_Lattice_v1.0.md"]="⚙️ System Interlink"
)

echo "🧭 COMMAND NEXUS STATUS — $TS" > "$OUTPUT"
echo "" >> "$OUTPUT"
echo "| Mandate | File | Status | Path |" >> "$OUTPUT"
echo "|----------|------|---------|------|" >> "$OUTPUT"

for file in "${!FILES[@]}"; do
  path="$MANDATE_DIR/$file"
  if [ -f "$path" ]; then
    echo "| ${FILES[$file]} | $file | ✅ Found | $path |" >> "$OUTPUT"
  else
    echo "| ${FILES[$file]} | $file | ❌ Missing | $path |" >> "$OUTPUT"
  fi
done

echo "" >> "$OUTPUT"
echo "🜂 Command Nexus verified at: $TS" >> "$OUTPUT"
echo "Results stored in $OUTPUT"
