#!/bin/bash
# Runs Amazon's official Amazon Music installer on Apple Silicon (M-series) Macs.
# The installer's start script only accepts Intel chips, so we start its
# Intel installer through Rosetta instead.
set -e
AMAZON_TEAM="94KV3E626L"   # Amazon's Apple developer ID

say_err() { osascript -e "display alert \"Amazon Music on M Mac\" message \"$1\"" >/dev/null 2>&1; echo "$1"; exit 1; }

# 1. Rosetta
if ! /usr/bin/pgrep -q oahd && ! arch -x86_64 /usr/bin/true 2>/dev/null; then
  echo "Installing Rosetta (Apple's Intel app support)..."
  softwareupdate --install-rosetta || say_err "Rosetta install failed."
fi

# 2. Find Amazon's installer DMG
DMG=$(ls -t "$HOME"/Downloads/Amazon*Music*Installer*.dmg 2>/dev/null | head -1 || true)
if [ -z "$DMG" ]; then
  DMG=$(osascript -e 'POSIX path of (choose file with prompt "Pick the Amazon Music Installer .dmg you downloaded from amazon.com" of type {"dmg"})' 2>/dev/null) \
    || say_err "No installer picked. Download it from amazon.com/music first."
fi
echo "Using: $DMG"

# 3. Mount it and check it really is Amazon's
MP=$(mktemp -d)
trap 'hdiutil detach "$MP" -quiet 2>/dev/null; rmdir "$MP" 2>/dev/null' EXIT
hdiutil attach -readonly -nobrowse -noautoopen -mountpoint "$MP" "$DMG" >/dev/null 2>&1 || say_err "Could not open the DMG."
APP=$(ls -d "$MP"/*.app 2>/dev/null | head -1)
[ -n "$APP" ] || say_err "No installer app found in the DMG."
codesign --verify --deep --strict "$APP" 2>/dev/null || say_err "Installer signature is broken. Download it again from amazon.com."
codesign -dv "$APP" 2>&1 | grep -q "TeamIdentifier=$AMAZON_TEAM" || say_err "This installer is not signed by Amazon."

# 4. Run the Intel installer through Rosetta
BIN="$APP/Contents/MacOS/osx-x86_64"
[ -x "$BIN" ] || say_err "Installer layout changed; this fix may no longer be needed."
[ -n "$CHECK_ONLY" ] && { echo "Checks passed (CHECK_ONLY set, not installing)."; exit 0; }
echo "Opening Amazon Music installer..."
arch -x86_64 "$BIN"
echo "Done."
