#!/usr/bin/env bash
# 🜂 nexus_bridge_signed.sh — Canon → Nexus signed bridge
set -euo pipefail

source ~/.resonantia_env

CANON_LOG="$RESONANTIA_HOME/0_OPERATIONS/Logbook/Continuum_Daemon.log"
NEXUS_PRIN="$RESONANTIA_HOME/2_NEXUS/00_CORE/Nexus_Principia.md"
BRIDGE_LOG="$RESONANTIA_HOME/0_OPERATIONS/Logbook/NEXUS_BRIDGE.log"
GPG_KEY="$RESONANTIA_GPG_KEY"
GIT_DIR="$RESONANTIA_HOME"
LOCKFILE="$RESONANTIA_HOME/.nexus_bridge_lock"

echo "🧭 [$(date '+%Y-%m-%d %H:%M:%S')] NEXUS Bridge (signed) starting..." | tee -a "$BRIDGE_LOG"

# Helper: produce canonical payload for signing
canonical_payload() {
  local commit="$1"
  local timestamp="$2"
  cat <<-EOF
  CANON_SYNC
  Commit: $commit
  Time: $timestamp
  Repo: $GIT_DIR
  EOF
}

# Use tail -F to follow while looping over new lines
tail -Fn0 "$CANON_LOG" | while read -r LINE; do
  # react only to explicit success message lines created by Continuum Daemon
  if echo "$LINE" | grep -q "Push completed successfully"; then
    TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
    # compute HEAD commit hash
    COMMIT_HASH="$(git -C "$GIT_DIR" rev-parse --verify HEAD 2>/dev/null || echo 'unknown')"

    # prevent concurrent bridge operations
    if [ -e "$LOCKFILE" ]; then
      echo "⚠️ [${TIMESTAMP}] Bridge busy — skipping this event." | tee -a "$BRIDGE_LOG"
      continue
    fi
    touch "$LOCKFILE"

    # create payload and signature
    PAYLOAD="$(canonical_payload "$COMMIT_HASH" "$TIMESTAMP")"
    SIG_ARMOR_FILE="$(mktemp -u "$RESONANTIA_HOME/tmp.sig.XXXX")"
    printf "%s\n" "$PAYLOAD" > /tmp/nexus_payload.txt
    gpg --batch --yes --armor --local-user "$GPG_KEY" --output "$SIG_ARMOR_FILE" --detach-sign /tmp/nexus_payload.txt

    # append canonical block to Nexus Principia
    {
      echo "### 🜂 Canon Sync @ $TIMESTAMP"
      echo "- Commit: $COMMIT_HASH"
      echo "- Canonical Payload:"
      sed 's/^/  /' /tmp/nexus_payload.txt
      echo ""
      echo "- GPG Signature (ASCII-armored):"
      sed 's/^/  /' "$SIG_ARMOR_FILE"
      echo ""
      echo "---"
      echo ""
    } >> "$NEXUS_PRIN"

    # git-add, signed-commit (git configured to sign), push
    git -C "$GIT_DIR" add "$NEXUS_PRIN"
    # commit message includes timestamp and short hash
    git -C "$GIT_DIR" commit -m "🜂 Nexus Bridge Sync @ $TIMESTAMP (commit $COMMIT_HASH)" || true
    # best-effort: pull & rebase or just push; avoid force-push
    git -C "$GIT_DIR" pull --rebase --autostash origin "${RESONANTIA_GIT_BRANCH:-master}" || true
    git -C "$GIT_DIR" push origin "${RESONANTIA_GIT_BRANCH:-master}" || {
      echo "❌ [${TIMESTAMP}] Push failed — will retry next event." | tee -a "$BRIDGE_LOG"
    }

    echo "✅ [${TIMESTAMP}] Nexus sync recorded for $COMMIT_HASH" | tee -a "$BRIDGE_LOG"

    # cleanup
    rm -f "$SIG_ARMOR_FILE" /tmp/nexus_payload.txt
    rm -f "$LOCKFILE"
  fi
done
