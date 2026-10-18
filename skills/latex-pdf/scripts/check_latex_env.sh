#!/usr/bin/env bash
# check_latex_env.sh — Detect LaTeX compilation environment (cross-platform)
# Usage: bash check_latex_env.sh
# Output: Human-readable probe report (not proof that a document compiles)
# Read-only: review this file and resolve trusted PATH programs before running.
# Missing dependencies never authorize installation or configuration changes.

set -euo pipefail

echo "========================================"
echo "  LaTeX Environment Detection Report"
echo "========================================"
echo ""

# ── OS Detection ──────────────────────────
OS="unknown"
case "$(uname -s)" in
    Darwin) OS="macOS" ;;
    Linux)  OS="Linux" ;;
    MINGW*|MSYS*|CYGWIN*) OS="Windows" ;;
esac
echo "## Operating System: $OS"
echo ""

# ── TeX Distribution ─────────────────────
echo "## TeX Distribution"
echo ""
TEX_DIST="none"

if command -v tlmgr &>/dev/null; then
    TEX_DIST="TeX Live"
    if TL_VER=$(tlmgr --version 2>/dev/null); then TL_VER=${TL_VER%%$'\n'*}; else TL_VER="probe failed"; fi
    echo "  ✅ TeX Live found: $TL_VER"
elif command -v mpm &>/dev/null; then
    TEX_DIST="MiKTeX"
    if MK_VER=$(mpm --version 2>/dev/null); then MK_VER=${MK_VER%%$'\n'*}; else MK_VER="probe failed"; fi
    echo "  ✅ MiKTeX found: $MK_VER"
else
    echo "  ❌ No TeX distribution found"
    echo "     → Install: https://www.tug.org/texlive/ or https://miktex.org/"
fi
echo ""

# ── Engines ──────────────────────────────
echo "## Engines"
echo ""
AVAILABLE_ENGINES=()
for engine in pdflatex xelatex lualatex latexmk; do
    if command -v "$engine" &>/dev/null; then
        AVAILABLE_ENGINES+=("$engine")
        if VER=$("$engine" --version 2>/dev/null); then VER=${VER%%$'\n'*}; else VER="probe failed"; fi
        echo "  ✅ $engine: $VER"
    else
        echo "  ❌ $engine: not found"
    fi
done
echo ""

# ── biber (bibliography backend) ─────────
echo "## Bibliography Tools"
echo ""
if command -v biber &>/dev/null; then
    BIBER_VER=$(biber --version 2>/dev/null || echo "unknown")
    echo "  ✅ biber: $BIBER_VER"
else
    echo "  ❌ biber: not found (needed for biblatex)"
fi
if command -v bibtex &>/dev/null; then
    echo "  ✅ bibtex: available"
else
    echo "  ❌ bibtex: not found"
fi
echo ""

# ── Key Packages ─────────────────────────
echo "## Key Packages"
echo ""
# Optional package inventory; install only what the actual document needs.
PACKAGES=(
    ctex xeCJK fontspec geometry hyperref graphicx amsmath amssymb
    booktabs enumitem tcolorbox fancyhdr listings minted pgfplots
    tikz microtype longtable tabularx caption subcaption cleveref
    polyglossia babel xcolor titlesec siunitx
)

AVAILABLE_PKGS=()
MISSING_PKGS=()

UNKNOWN_PKGS=()
if command -v kpsewhich &>/dev/null; then
    for pkg in "${PACKAGES[@]}"; do
        if PATH_RESULT=$(kpsewhich "${pkg}.sty" 2>/dev/null); then
            if [ -n "$PATH_RESULT" ]; then
                echo "  ✅ ${pkg}"
                AVAILABLE_PKGS+=("$pkg")
            else
                echo "  ? ${pkg}: empty probe result"
                UNKNOWN_PKGS+=("$pkg")
            fi
        else
            PROBE_STATUS=$?
            if [ "$PROBE_STATUS" -eq 1 ]; then
                echo "  ❌ ${pkg}: not found"
                MISSING_PKGS+=("$pkg")
            else
                echo "  ? ${pkg}: probe failed (exit $PROBE_STATUS)"
                UNKNOWN_PKGS+=("$pkg")
            fi
        fi
    done
else
    echo "  ? kpsewhich unavailable: packages not checked"
    UNKNOWN_PKGS=("${PACKAGES[@]}")
fi
echo ""

# ── CJK Font Detection ───────────────────
echo "## CJK (Chinese/Japanese/Korean) Font Support"
echo ""
CJK_AVAILABLE=false
if command -v fc-list &>/dev/null; then
    if CJK_FONTS=$(fc-list :lang=zh family 2>/dev/null); then
      if [ -n "$CJK_FONTS" ]; then
        CJK_AVAILABLE=true
        echo "  ✅ CJK fonts detected:"
        printf '%s\n' "$CJK_FONTS" | sort -u | sed -n '1,10p' | while IFS= read -r line; do
            echo "     • $line"
        done
    else
        echo "  ❌ No CJK fonts found via fc-list"
      fi
    else
        echo "  ? fc-list probe failed: font availability unknown"
    fi
else
    echo "  ⚠️ fc-list not available, cannot check CJK fonts"
    echo "     On macOS, check: /System/Library/Fonts/ and ~/Library/Fonts/"
    echo "     On Linux, install: fontconfig package"
fi
echo ""

# ── minted Dependencies ──────────────────
echo "## minted Dependencies"
echo ""
if command -v pygmentize &>/dev/null; then
    echo "  ✅ pygmentize (Pygments) found"
elif command -v latexminted &>/dev/null; then
    echo "  ✅ latexminted found (minted v3+)"
else
    echo "  ❌ Neither pygmentize nor latexminted found"
    echo "     → minted helpers not found; project compatibility is unverified"
    echo "     → Report missing helpers; do not install without authorization"
    echo "     → Alternative: use 'listings' package (no external deps)"
fi
echo ""

# ── shell-escape Setting ─────────────────
echo "## shell-escape Setting"
echo ""
if [ "$TEX_DIST" = "TeX Live" ]; then
    SHELL_ESCAPE=$(kpsewhich -var-value shell_escape 2>/dev/null || echo "unknown")
    case "$SHELL_ESCAPE" in
        t|y) echo "  ⚠️ shell_escape = $SHELL_ESCAPE (fully enabled; explicitly disable for default compilation)" ;;
        p)   echo "  ⚠️ shell_escape = p (restricted — approved commands only)" ;;
        f|n) echo "  ✅ shell_escape = $SHELL_ESCAPE (disabled; default compilation policy)" ;;
        *)   echo "  ? shell_escape = $SHELL_ESCAPE (unknown)" ;;
    esac
elif [ "$TEX_DIST" = "MiKTeX" ]; then
    echo "  ℹ️ MiKTeX: keep external command execution disabled by default"
else
    echo "  ? Cannot determine (no TeX distribution)"
fi
echo ""

# ── Summary ──────────────────────────────
echo "========================================"
echo "  Summary"
echo "========================================"
echo "  Distribution:  $TEX_DIST"
echo "  Engines found: ${AVAILABLE_ENGINES[*]:-none}"
echo "  Packages:      ${#AVAILABLE_PKGS[@]}/${#PACKAGES[@]} available"
if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    echo "  Missing pkgs:  ${MISSING_PKGS[*]}"
fi
echo "  Packages unchecked/probe-failed: ${#UNKNOWN_PKGS[@]}"
echo "  CJK detected:  $CJK_AVAILABLE (false may mean unavailable probe)"
if command -v pygmentize &>/dev/null || command -v latexminted &>/dev/null; then
    echo "  minted helper: yes (compatibility and execution policy not checked)"
else
    echo "  minted helper: no"
fi
echo ""
echo "## Next steps"
echo "  This report does not install packages or enable shell-escape."
echo "  Confirm the actual document requirements and existing authorization first."
echo "  A helper on PATH does not prove minted or the document can compile."
echo ""
