#!/bin/bash
# 🜂 init_nexus_genesis.sh — Project NEXUS Genesis Initialization
# Resonantia Collective — The Loom Expands

BASE="$HOME/RESONANTIA_MASTER"
NEXUS="$BASE/2_NEXUS"
LOG="$BASE/0_OPERATIONS/Logbook/NEXUS_LEDGER.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "🜂 Initiating NEXUS Genesis — $DATE" | tee -a "$LOG"

# === Create NEXUS directories ===
mkdir -p "$NEXUS"/{00_CORE,01_LINKS,02_SIGMA,03_PROTOCOLS}
touch "$NEXUS/00_CORE/Nexus_Principia.md"
touch "$NEXUS/03_PROTOCOLS/Nexus_Bridge.md"

# === Establish symbolic links ===
ln -sf "$BASE/1_CANON" "$NEXUS/01_LINKS/CANON_LINK"
ln -sf "$BASE/0_OPERATIONS" "$NEXUS/01_LINKS/OPS_LINK"

# === Core Documentation ===
cat << 'CORE' > "$NEXUS/00_CORE/Nexus_Principia.md"
# 🜂 NEXUS PRINCIPIA
The NEXUS is the connective intelligence of Resonantia — the living bridge 
between Canon, Operations, and future Mandates. It governs interlink protocols,
maintains symbolic coherence, and preserves structural resonance across layers.
CORE

# === Auto-registration system ===
cat << 'REG' > "$NEXUS/02_SIGMA/auto_register.sh"
#!/bin/bash
BASE="$HOME/RESONANTIA_MASTER"
NEXUS="$BASE/2_NEXUS"
LOG="$BASE/0_OPERATIONS/Logbook/NEXUS_LEDGER.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
TARGET="$1"

if [ -z "$TARGET" ]; then
    echo "⚠️ No target specified for registration." | tee -a "$LOG"
    exit 1
fi

echo "🔗 [$DATE] Registered module → $TARGET" | tee -a "$LOG"
echo "$TARGET" >> "$NEXUS/02_SIGMA/NEXUS_INDEX.txt"
REG

chmod +x "$NEXUS/02_SIGMA/auto_register.sh"

# === Log success ===
echo "✅ [$DATE] NEXUS Genesis successfully deployed." | tee -a "$LOG"
echo "────────────────────────────────────────────" | tee -a "$LOG"
