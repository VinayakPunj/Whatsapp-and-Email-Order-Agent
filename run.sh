#!/usr/bin/env bash
# Usage:  ./run.sh                   run the sample messages through the graph
#         ./run.sh test              run the unit tests
#         ./run.sh msg "para 650 x 4"   run a single message
#         ./run.sh graph             print the graph as a Mermaid diagram
# The first run creates a .venv folder and installs LangGraph into it.
set -euo pipefail
cd "$(dirname "$0")"

PY="${PYTHON:-python3}"
if ! command -v "$PY" >/dev/null 2>&1; then
  echo "Python 3.10 or newer is required. Install it from https://www.python.org/downloads/" >&2
  exit 1
fi

if [ ! -d .venv ]; then
  echo "Creating .venv and installing requirements (first run only)..."
  "$PY" -m venv .venv
  .venv/bin/python -m pip install --quiet --upgrade pip
  .venv/bin/python -m pip install --quiet -r requirements.txt
fi
VPY=".venv/bin/python"

case "${1:-demo}" in
  test)  "$VPY" -m unittest discover -s tests -v ;;
  msg)   shift; "$VPY" -m order_agent run "$*" ;;
  graph) "$VPY" -m order_agent graph ;;
  demo)  "$VPY" -m order_agent demo ;;
  *)     echo "Unknown option '$1'. Use: demo, test, msg or graph." >&2; exit 1 ;;
esac
