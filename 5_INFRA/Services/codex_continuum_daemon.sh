#!/usr/bin/env bash
# 🜂 Resonantia Codex Continuum Daemon (v5.1)
# Purpose: Monitors changes, auto-commits, and safely pushes updates.
# Features:
#  - Single-instance locking
#  - Git-safe sync queue
#  - Retry logic for remote rejects
#  - Nexus & Watchdog aware

# === Environment ===
export HOME="/home/commandant"
export USER="commandant"
source "$HOME/.resonantia_env"

LOGFILE="$RESONANTIA_HOME/0_OPERATIONS/Logbook/Continuum_Daemon.log"
WATCHDIR="$RESONANTIA_HOME/0_OPERATIONS/Logbook"
LOCKFILE="$HOME/.codex_continuum.lock"
PIDFILE="$HOME/.codex_continuum.pid"
REPO="$RESONANTIA_HOME"

# === Safety: Allow only one instance ===
if [[ -f "$LOCKFILE" ]]; then
    OLD_PID=$(cat "$LOCKFILE")
    if ps -p "$OLD_PID" &>/dev/null; then
        echo "⚠️  [$(date '+%Y-%m-%d %H:%M:%S')] Daemon already running (PID $OLD_PID) — exiting." | tee -a "$LOGFILE"
        exit 0
    fi
fi
echo $$ > "$LOCKFILE"

# Clean exit on shutdown
trap 'rm -f "$LOCKFILE" "$PIDFILE"; echo "🜂 [$(date '+%Y-%m-%d %H:%M:%S')] Daemon exiting." | tee -a "$LOGFILE"; exit 0' SIGINT SIGTERM
echo $$ > "$PIDFILE"

echo "🜂 [$(date '+%Y-%m-%d %H:%M:%S')] Continuum daemon starting. Watching: $WATCHDIR" | tee -a "$LOGFILE"

# === Git-safe push function ===
safe_push() {
    local DATE="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "🜂 [$DATE] FS event detected — preparing to sync..." | tee -a "$LOGFILE"

    cd "$REPO" || exit 1

    # Stage changes
    git add -A
    git commit -m "🜂 Auto-update via Continuum Daemon @ $DATE" >> "$LOGFILE" 2>&1 || true

    # Attempt to sync safely
    git fetch origin master --quiet
    git rebase origin/master >> "$LOGFILE" 2>&1 || git merge --strategy-option=ours origin/master >> "$LOGFILE" 2>&1

    # Retry logic for push
    for attempt in {1..3}; do
        git push origin master >> "$LOGFILE" 2>&1 && {
            echo "✅ [$DATE] Push completed successfully." | tee -a "$LOGFILE"
            return 0
        }
        echo "⚠️  [$DATE] Push failed (attempt $attempt). Retrying in 10s..." | tee -a "$LOGFILE"
        sleep 10
    done

    echo "❌ [$DATE] Push permanently failed after retries." | tee -a "$LOGFILE"
}

# === File monitoring loop ===
inotifywait -m -r -e modify,create,move,delete "$WATCHDIR" --format '%w%f' | while read FILE; do
    DATE=$(date '+%Y-%m-%d %H:%M:%S')
    echo "🜂 [$DATE] FS event: $FILE" | tee -a "$LOGFILE"

    # Prevent multiple rapid triggers
    if [[ -f "$LOCKFILE.active" ]]; then
        echo "⚠️  [$DATE] Push skipped — another operation in progress." | tee -a "$LOGFILE"
        continue
    fi
    touch "$LOCKFILE.active"

    safe_push
    rm -f "$LOCKFILE.active"
done
