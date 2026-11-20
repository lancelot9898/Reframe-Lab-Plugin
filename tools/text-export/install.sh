#!/bin/bash
# Reframe Lab text export, for the Chief of Staff plugin.
#
# Once a day, copies your new text messages, with each person's name, from the
# Messages app on this Mac into My Brain/Texts in your Google Drive, so your
# chief of staff can see what you promised people by text. It only reads.
# It never sends a text.
#
# Run it in Terminal with:
#   bash <(curl -fsSL https://raw.githubusercontent.com/lancelot9898/Reframe-Lab-Plugin/main/tools/text-export/install.sh)
#
# Options:
#   --test       run once and schedule nothing (for trying it out)
#   --uninstall  stop it and remove the program
#
# Safe to run again: it replaces the old copy and keeps your settings unless you change them.

set -e

REPO_RAW="https://raw.githubusercontent.com/lancelot9898/Reframe-Lab-Plugin/main/tools/text-export"
LABEL="com.reframelab.texts"
APP_DIR="$HOME/Library/Application Support/ReframeLabTexts"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
CONFIG="$APP_DIR/config.json"
UID_NUM="$(id -u)"
MODE="install"
for a in "$@"; do
  case "$a" in
    --test) MODE="test" ;;
    --uninstall) MODE="uninstall" ;;
  esac
done

say() { printf '\n\033[1m%s\033[0m\n' "$1"; }
ask() { local r; read -r -p "$1" r < /dev/tty; printf '%s' "$r"; }

if [ "$(uname)" != "Darwin" ]; then
  say "This only works on a Mac."
  exit 1
fi

# ---------- uninstall ----------
if [ "$MODE" = "uninstall" ]; then
  launchctl bootout "gui/$UID_NUM/$LABEL" 2>/dev/null || true
  rm -f "$PLIST"
  rm -rf "$APP_DIR"
  say "Removed. Nothing runs any more."
  echo "Last step: open System Settings, then Privacy & Security, then Full Disk Access,"
  echo "select reframe-texts and click the minus button."
  echo "Your old export files stay in My Brain/Texts until you delete them."
  exit 0
fi

say "Reframe Lab text export"
echo "This copies your new texts, with each person's name, into My Brain/Texts"
echo "in your Google Drive once a day, so your chief of staff can see them."
echo "It only reads your texts. It never sends one."
echo "Everything you text is included, unless you name people to leave out in a minute."
echo ""
GO="$(ask "Type yes and press Return to go on: ")"
if [ "$(printf '%s' "$GO" | tr '[:upper:]' '[:lower:]')" != "yes" ]; then
  say "Stopped. Nothing was changed."
  exit 0
fi

# ---------- 1. Find Google Drive for desktop ----------
DRIVES=()
for d in "$HOME/Library/CloudStorage"/GoogleDrive-*; do
  [ -d "$d" ] && DRIVES+=("$d")
done
if [ "${#DRIVES[@]}" -eq 0 ]; then
  say "Google Drive for desktop isn't on this Mac yet."
  echo "1. Download it from https://www.google.com/drive/download/ and install it."
  echo "2. Sign in with the same Google account your chief of staff uses."
  echo "3. Run this installer again."
  exit 1
fi
if [ "${#DRIVES[@]}" -eq 1 ]; then
  DRIVE="${DRIVES[0]}"
else
  say "More than one Google account is signed in to Google Drive here:"
  i=1
  for d in "${DRIVES[@]}"; do
    echo "  $i. ${d##*/GoogleDrive-}"
    i=$((i + 1))
  done
  PICK="$(ask "Type the number of the account your chief of staff uses: ")"
  if ! [[ "$PICK" =~ ^[0-9]+$ ]] || [ "$PICK" -lt 1 ] || [ "$PICK" -gt "${#DRIVES[@]}" ]; then
    say "That isn't one of the numbers. Run the installer again."
    exit 1
  fi
  DRIVE="${DRIVES[$((PICK - 1))]}"
fi
if [ ! -d "$DRIVE/My Drive" ]; then
  say "Can't find My Drive inside Google Drive at: $DRIVE"
  echo "Open Google Drive for desktop, make sure it says it's up to date, then run this again."
  exit 1
fi
OUT_DIR="$DRIVE/My Drive/My Brain/Texts"
mkdir -p "$OUT_DIR"
say "Your texts will go to: My Brain/Texts (Google account ${DRIVE##*/GoogleDrive-})"

# ---------- 2. Who to leave out ----------
OLD_SKIP=""
if [ -f "$CONFIG" ]; then
  OLD_SKIP="$(/usr/bin/plutil -extract skip json -o - "$CONFIG" 2>/dev/null || true)"
fi
echo ""
echo "Anyone whose texts should stay out, such as family?"
echo "Type their names exactly as they appear in Contacts, separated by commas."
echo "A group chat with any of them in it is left out too."
if [ -n "$OLD_SKIP" ] && [ "$OLD_SKIP" != "[]" ]; then
  echo "Right now you leave out: $OLD_SKIP"
  echo "Press Return to keep that list, or type a new one."
else
  echo "Press Return to leave nobody out."
fi
SKIP_RAW="$(ask "> ")"

# ---------- 3. bun, used only to build the program ----------
BUN="$(command -v bun 2>/dev/null || true)"
for c in "$HOME/.bun/bin/bun" /opt/homebrew/bin/bun /usr/local/bin/bun; do
  if [ -z "$BUN" ] && [ -x "$c" ]; then BUN="$c"; fi
done
if [ -z "$BUN" ]; then
  say "Installing bun, a free tool this needs to build the program (about a minute)..."
  curl -fsSL https://bun.sh/install | bash >/dev/null 2>&1 || true
  BUN="$HOME/.bun/bin/bun"
  if [ ! -x "$BUN" ]; then
    say "bun didn't install. Paste this line, press Return, then run this installer again:"
    echo ""
    echo "  curl -fsSL https://bun.sh/install | bash"
    exit 1
  fi
fi

# ---------- 4. Get the exporter and save the settings ----------
mkdir -p "$APP_DIR" "$HOME/Library/LaunchAgents"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"
if [ -n "$SRC_DIR" ] && [ -f "$SRC_DIR/export.js" ]; then
  cp "$SRC_DIR/export.js" "$APP_DIR/export.js"
else
  curl -fsSL "$REPO_RAW/export.js" -o "$APP_DIR/export.js"
fi

OUT_DIR="$OUT_DIR" SKIP_RAW="$SKIP_RAW" OLD_SKIP="$OLD_SKIP" CONFIG="$CONFIG" "$BUN" -e '
  const fs = require("fs");
  const raw = (process.env.SKIP_RAW || "").trim();
  let skip = [];
  if (raw) skip = raw.split(",").map((s) => s.trim()).filter(Boolean);
  else { try { skip = JSON.parse(process.env.OLD_SKIP || "[]"); } catch { skip = []; } }
  fs.writeFileSync(process.env.CONFIG, JSON.stringify({ out_dir: process.env.OUT_DIR, skip, first_run_days: 7 }, null, 2));
'

# ---------- 5. Build one small program ----------
# Full Disk Access then goes to this one program, not to bun or Terminal.
BIN="$APP_DIR/reframe-texts"
rm -f "$BIN"
built=no
if "$BUN" build "$APP_DIR/export.js" --compile --outfile "$BIN" >/dev/null 2>&1; then
  if "$BIN" --selftest >/dev/null 2>&1; then
    built=yes
  elif codesign --force --sign - "$BIN" >/dev/null 2>&1 && "$BIN" --selftest >/dev/null 2>&1; then
    built=yes
  fi
fi
BUN_REAL="$(readlink -f "$BUN" 2>/dev/null || echo "$BUN")"
if [ "$built" = yes ]; then
  PROG_XML="    <string>$BIN</string>"
  FDA_TARGET="$BIN"
  FDA_NAME="reframe-texts"
else
  say "Couldn't build the small program, so it will run through bun instead."
  PROG_XML="    <string>$BUN_REAL</string>
    <string>$APP_DIR/export.js</string>"
  FDA_TARGET="$BUN_REAL"
  FDA_NAME="bun"
fi

# ---------- 6. Schedule it: every day at 6:10 AM, before the morning message ----------
# A Mac that's asleep at 6:10 runs it when it wakes.
cat > "$PLIST" <<PLISTEOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
$PROG_XML
  </array>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key><integer>6</integer>
    <key>Minute</key><integer>10</integer>
  </dict>
  <key>RunAtLoad</key><false/>
  <key>ProcessType</key><string>Background</string>
  <key>StandardOutPath</key><string>$APP_DIR/export.log</string>
  <key>StandardErrorPath</key><string>$APP_DIR/export.log</string>
</dict>
</plist>
PLISTEOF
launchctl bootout "gui/$UID_NUM/$LABEL" 2>/dev/null || true
launchctl bootstrap "gui/$UID_NUM" "$PLIST"

# ---------- 7. Full Disk Access, the one step only you can do ----------
say "One step only you can do: switch on Full Disk Access for $FDA_NAME."
echo "Two windows are opening now:"
echo "  - System Settings, on Privacy & Security, then Full Disk Access"
echo "  - Finder, with $FDA_NAME selected"
echo ""
echo "Drag $FDA_NAME from the Finder window into the list in System Settings, then switch it on."
echo "If it's already in the list, switch it off and on again."
echo "If your Mac asks for your password or Touch ID, that's your Mac asking, not this installer."
echo "If it asks you to quit and reopen an app, choose Later."
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles" || true
open -R "$FDA_TARGET" || true
echo ""
ask "Press Return once $FDA_NAME is switched on... " >/dev/null

# ---------- 8. First run ----------
say "Copying your texts from the last 7 days now..."
STATUS="$OUT_DIR/_status.md"
BEFORE="$(stat -f %m "$STATUS" 2>/dev/null || echo 0)"
launchctl kickstart -k "gui/$UID_NUM/$LABEL"
AFTER="$BEFORE"
for _i in $(seq 1 30); do
  sleep 2
  AFTER="$(stat -f %m "$STATUS" 2>/dev/null || echo 0)"
  if [ "$AFTER" != "$BEFORE" ]; then break; fi
done

if [ "$MODE" = "test" ]; then
  launchctl bootout "gui/$UID_NUM/$LABEL" 2>/dev/null || true
  rm -f "$PLIST"
fi

if [ "$AFTER" = "$BEFORE" ]; then
  say "Nothing came back yet. These are the last lines of the log:"
  tail -n 5 "$APP_DIR/export.log" 2>/dev/null || echo "(no log yet)"
  echo ""
  echo "Copy these lines into your chat with Claude and ask what went wrong."
  exit 1
fi

RESULT="$(grep '^status:' "$STATUS" | head -1 | sed 's/status: *//')"
if [ "$RESULT" = "ok" ]; then
  MSGS="$(grep '^messages:' "$STATUS" | head -1 | sed 's/messages: *//')"
  say "Done. It works."
  echo "Texts copied into My Brain/Texts: $MSGS"
  if [ "$MODE" = "test" ]; then
    echo "This was a test run, so nothing is scheduled. Run the installer without --test to make it daily."
  else
    echo "From now on it runs every morning at 6:10, or when your Mac wakes up."
  fi
else
  say "It ran but hit a problem:"
  grep '^error:' "$STATUS" | sed 's/error: *//'
  echo ""
  echo "If it mentions Full Disk Access, $FDA_NAME isn't switched on yet. Switch it on, then run this installer again."
  echo "Otherwise, copy the line above into your chat with Claude and ask what went wrong."
  exit 1
fi
