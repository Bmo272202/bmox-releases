#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Bmox Uninstaller — macOS & Linux
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

BIN_DIR="${BMOX_BIN_DIR:-/usr/local/bin}"
CONFIG_DIR="${HOME}/.bmox"
BINARY_NAME="bmox"

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

info()    { echo -e "  ${CYAN}→${NC}  $1"; }
success() { echo -e "  ${GREEN}✓${NC}  $1"; }
warn()    { echo -e "  ${YELLOW}!${NC}  $1"; }

echo ""
echo -e "  ${BOLD}◉ Bmox Uninstaller${NC}"
echo "  ─────────────────────────────────────────"
echo ""

# ── Remove Binary ─────────────────────────────────────────────────────────────
BIN_PATH="${BIN_DIR}/${BINARY_NAME}"
if [[ -f "$BIN_PATH" ]]; then
  info "Removing ${BINARY_NAME} from ${BIN_DIR}..."
  if [[ -w "$BIN_DIR" ]]; then
    rm -f "$BIN_PATH"
  else
    warn "Elevated permissions required to remove from ${BIN_DIR}."
    sudo rm -f "$BIN_PATH"
  fi
  success "Binary removed."
else
  info "Bmox binary not found at ${BIN_PATH}. Skipping."
fi

# ── Optional Config Cleanup ───────────────────────────────────────────────────
if [[ -d "$CONFIG_DIR" ]]; then
  echo ""
  read -p "  ? Do you want to remove all Bmox configurations and data in ${CONFIG_DIR}? (y/N) " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    info "Removing ${CONFIG_DIR}..."
    rm -rf "$CONFIG_DIR"
    success "Configuration removed."
  else
    info "Configuration kept at ${CONFIG_DIR}."
  fi
fi

echo ""
echo "  ─────────────────────────────────────────"
success "Bmox has been uninstalled successfully."
warn "If you added ${BIN_DIR} to your PATH manually in your shell profile (.bashrc, .zshrc, etc.), you may want to remove it."
echo ""
