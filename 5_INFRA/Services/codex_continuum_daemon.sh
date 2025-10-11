#!/bin/bash
set -euo pipefail

LOCK="$HOME/.codex_continuum.lock"
PIDFILE="$HOME/.codex_continuum.pid"
LOG="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook/Continuum_Daemon.log"
WATCH="$HOME/RESONANTIA_MASTER/0_OPERATIONS/Logbook"
DEBOUNCE_SECONDS=8
DATE() { date '+%Y-%m-%d %H:%M:%S'; }

# single-instance guard (fd 200 locks the LOCK path)
exec 200>"$LOCK"
if ! flock -n 200; then
  echo "⚠️ [$(DATE)] Daemon already running — exiting." >> "$LOG"
  exit 0
fi
echo $$ > "$PIDFILE"
trap 'rm -f "$PIDFILE"; echo "🜂 [$(DATE)] Daemon exiting." >> "$LOG"; exit' INT TERM EXIT

echo "🜂 [$(DATE)] Continuum daemon starting. Watching: $WATCH" >> "$LOG"

# Use inotifywait to watch the log directory.
# Debounce: after the first event, wait $DEBOUNCE_SECONDS to coalesce more events.
inotifywait -m -r -e modify,create,delete --format '%w%f' "$WATCH" | \
while read -r eventfile; do
  echo "🜂 [$(DATE)] FS event: $eventfile" >> "$LOG"
  # coalesce rapid events
  sleep "$DEBOUNCE_SECONDS"
  # run push guard (non-blocking safe)
  bash "$HOME/RESONANTIA_MASTER/5_INFRA/Services/codex_push_guard.sh" &
done
