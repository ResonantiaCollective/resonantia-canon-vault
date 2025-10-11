#!/bin/bash
# Adds auto-rotation to cron (every 12 hours)
( crontab -l 2>/dev/null; echo "0 */12 * * * bash \$HOME/RESONANTIA_MASTER/5_INFRA/Services/resonantia_autorotate.sh" ) | crontab -
echo "🕰️ Auto-rotation scheduled every 12h via cron."
