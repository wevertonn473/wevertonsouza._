#!/bin/bash
#
# uninstall.sh — remove o Smart Unzip do macOS
#
set -euo pipefail

rm -f  "$HOME/.local/bin/smart-unzip"
rm -rf "$HOME/Library/Services/SmartUnzip.workflow"
/System/Library/CoreServices/pbs -flush >/dev/null 2>&1 || true

echo "✅ Smart Unzip removido."
