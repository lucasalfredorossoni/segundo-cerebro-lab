#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="$HOME/.local/bin/cerebro"

mkdir -p "$HOME/.local/bin"
chmod +x "$ROOT/tools/cerebro.py"
ln -sf "$ROOT/tools/cerebro.py" "$TARGET"

echo "cerebro instalado em $TARGET"
echo "versao fonte: $ROOT/tools/cerebro.py"
