#!/usr/bin/env bash
set -euo pipefail

while true; do
  choice="$(
    printf "ThinLinc\nMoonlight\nTerminal\n" |
      fuzzel --dmenu --prompt "Session " --lines 3 --width 24 2>/dev/null || true
  )"

  case "${choice:-}" in
    ThinLinc)
      /opt/thinlinc/bin/tlclient &
      ;;
    Moonlight)
      moonlight-qt &
      ;;
    Terminal)
      foot &
      ;;
  esac

  sleep 1
done
