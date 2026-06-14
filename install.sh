#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Bmox Installer — macOS & Linux
# Usage:
#   curl -fsSL https://bmox.vercel.app/mac | bash
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

REPO="bmo272202/bmox-releases"  # Repositorio público satélite (binarios públicos, código fuente privado)
BIN_DIR="${BMOX_BIN_DIR:-/usr/local/bin}"
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
error()   { echo -e "  ${RED}✗${NC}  $1" >&2; exit 1; }

echo ""
echo -e "  ${BOLD}◉ Bmox Installer${NC}"
echo "  ─────────────────────────────────────────"
echo ""

# ── Detect OS and Architecture ────────────────────────────────────────────────
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Linux)
    case "$ARCH" in
      x86_64)          RID="linux-x64"   ;;
      aarch64|arm64)   RID="linux-arm64" ;;
      *) error "Unsupported Linux architecture: $ARCH" ;;
    esac
    ASSET="bmox-${RID}.tar.gz"
    ;;
  Darwin)
    case "$ARCH" in
      arm64)   RID="osx-arm64" ;;
      *) error "Unsupported macOS architecture: $ARCH" ;;
    esac
    ASSET="bmox-${RID}.tar.gz"
    ;;
  *)
    error "Unsupported OS: $OS. Use the PowerShell installer on Windows."
    ;;
esac

info "Detected platform: ${BOLD}${RID}${NC}"

# ── Fetch latest release tag ──────────────────────────────────────────────────
info "Fetching latest release..."

if command -v curl &>/dev/null; then
  LATEST=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases?per_page=1" \
           | grep '"tag_name"' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/')
elif command -v wget &>/dev/null; then
  LATEST=$(wget -qO- "https://api.github.com/repos/${REPO}/releases?per_page=1" \
           | grep '"tag_name"' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/')
else
  error "curl or wget is required."
fi

if [[ -z "$LATEST" ]]; then
  error "Could not fetch the latest release from GitHub."
fi

info "Latest version: ${BOLD}${LATEST}${NC}"

DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${LATEST}/${ASSET}"

# ── Download ──────────────────────────────────────────────────────────────────
TMPDIR="$(mktemp -d)"
TMPFILE="${TMPDIR}/${ASSET}"

info "Downloading ${ASSET}..."

if command -v curl &>/dev/null; then
  curl -fsSL "$DOWNLOAD_URL" -o "$TMPFILE"
else
  wget -q "$DOWNLOAD_URL" -O "$TMPFILE"
fi

# ── Extract ───────────────────────────────────────────────────────────────────
info "Extracting..."
tar -xzf "$TMPFILE" -C "$TMPDIR"
chmod +x "${TMPDIR}/${BINARY_NAME}"

# ── Install ───────────────────────────────────────────────────────────────────
info "Installing to ${BIN_DIR}..."

if [[ -w "$BIN_DIR" ]]; then
  mv "${TMPDIR}/${BINARY_NAME}" "${BIN_DIR}/${BINARY_NAME}"
else
  warn "Elevated permissions required for ${BIN_DIR}."
  sudo mv "${TMPDIR}/${BINARY_NAME}" "${BIN_DIR}/${BINARY_NAME}"
fi

rm -rf "$TMPDIR"

# ── Verify ────────────────────────────────────────────────────────────────────
if ! command -v bmox &>/dev/null; then
  warn "bmox installed to ${BIN_DIR} but it's not on your PATH."
  warn "Add this to your shell profile: export PATH=\"\$PATH:${BIN_DIR}\""
else
  INSTALLED_VERSION="$(bmox --version 2>/dev/null || echo "$LATEST")"
  success "bmox ${INSTALLED_VERSION} installed successfully!"
fi

echo ""
echo "  ─────────────────────────────────────────"
echo -e "  ${BOLD}Getting started:${NC}"
echo ""
echo "    bmox init my-project"
echo "    cd my-project"
echo "    bmox config"
echo "    bmox run main \"Hello, Bmox!\""
echo ""
echo -e "  Docs: ${CYAN}https://bmox.vercel.app/docs${NC}"
echo ""
