#!/usr/bin/env bash
# run_module.sh
set -euo pipefail                              # safer bash defaults

module_dir="$HOME/HeWo/modules/$1"

if [[ ! -d "$module_dir" ]]; then
  echo "Module $module_dir does not exist." >&2
  exit 1
fi

echo "Running module in $module_dir …"
cd "$module_dir"

# ─── Launch unclutter to hide the cursor ─────────────────────────
if command -v unclutter >/dev/null; then
  # -idle 0   = hide immediately
  # -root     = work on the whole root window
  unclutter -idle 0 -root &
  UNCLUTTER_PID=$!
  echo "(unclutter started, PID=$UNCLUTTER_PID)"
else
  echo "⚠️  unclutter not found; cursor will remain visible"
fi
# -----------------------------------------------------------------

# ─── Run the module (docker-compose) ─────────────────────────────
if [[ -f docker-compose.yaml || -f docker-compose.yml ]]; then
  docker compose up
else
  echo "No docker-compose file found." >&2
  exit 1
fi
# -----------------------------------------------------------------

# ─── Clean up unclutter on exit ──────────────────────────────────
if [[ ${UNCLUTTER_PID:-} ]]; then
  kill "$UNCLUTTER_PID" 2>/dev/null || true
fi
