#!/usr/bin/env bash
# run_module.sh
set -euo pipefail                              # safer bash defaults

module_dir="$HOME/HeWo/modules/$1"
module_dir="/home/daiego/ThinThoughProjects/HeWo/modules/$1"   # TODO: This is local development, remove before sending to hewo

if [[ ! -d "$module_dir" ]]; then
  echo "Module $module_dir does not exist." >&2
  exit 1
fi

echo "Running module in $module_dir …"
cd "$module_dir"


# -----------------------------------------------------------------

# ─── Run the module (docker-compose) ─────────────────────────────
if [[ -f docker-compose.yaml || -f docker-compose.yml ]]; then
  docker compose rm
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
