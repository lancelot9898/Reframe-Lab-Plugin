#!/bin/bash
# Reframe Lab text export, for the Chief of Staff plugin.
#
# Four times a day, copies your new text messages, with each person's name, from the
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
echo "in your Google Drive four times a day, so your chief of staff can see them."
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
MYDRIVE="$DRIVE/My Drive"
if [ ! -d "$MYDRIVE" ]; then
  # On a Mac set to another language, My Drive has another name.
  MYDRIVE=""
  for d in "$DRIVE"/*/; do
    n="$(basename "$d")"
    case "$n" in "Shared drives"|"Other computers"|.*) continue ;; esac
    if [ -z "$MYDRIVE" ]; then MYDRIVE="${d%/}"; fi
  done
fi
if [ -z "$MYDRIVE" ] || [ ! -d "$MYDRIVE" ]; then
  say "Can't find My Drive inside Google Drive at: $DRIVE"
  echo "Open Google Drive for desktop from the menu bar, wait until it says it's up to date, then run this again."
  exit 1
fi
# Use the My Brain folder the chief of staff already uses, if there is one.
BRAINS=()
while IFS= read -r b; do BRAINS+=("$b"); done < <(find "$MYDRIVE" -maxdepth 3 -type d -name "My Brain" 2>/dev/null)
if [ "${#BRAINS[@]}" -eq 0 ]; then
  BRAIN="$MYDRIVE/My Brain"
elif [ "${#BRAINS[@]}" -eq 1 ]; then
  BRAIN="${BRAINS[0]}"
else
  say "There's more than one folder called My Brain in your Google Drive:"
  i=1
  for b in "${BRAINS[@]}"; do
    echo "  $i. ${b#"$MYDRIVE"/}"
    i=$((i + 1))
  done
  PICK="$(ask "Type the number of the one your chief of staff uses: ")"
  if ! [[ "$PICK" =~ ^[0-9]+$ ]] || [ "$PICK" -lt 1 ] || [ "$PICK" -gt "${#BRAINS[@]}" ]; then
    say "That isn't one of the numbers. Run the installer again."
    exit 1
  fi
  BRAIN="${BRAINS[$((PICK - 1))]}"
fi
OUT_DIR="$BRAIN/Texts"
echo "If your Mac asks to let Terminal use Google Drive, click Allow."
mkdir -p "$OUT_DIR"
say "Your texts will go to: ${OUT_DIR#"$MYDRIVE"/} (Google account ${DRIVE##*/GoogleDrive-})"

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
  echo "Press Return to keep that list, type a new one, or type none to leave nobody out."
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
NEW_JS="$APP_DIR/export.js.new"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"
if [ -n "$SRC_DIR" ] && [ -f "$SRC_DIR/export.js" ]; then
  cp "$SRC_DIR/export.js" "$NEW_JS"
else
  curl -fsSL "$REPO_RAW/export.js" -o "$NEW_JS"
fi
BIN="$APP_DIR/reframe-texts"
HAD_BIN=no
if [ -x "$BIN" ]; then HAD_BIN=yes; fi
SAME=no
if [ "$HAD_BIN" = yes ] && [ -f "$APP_DIR/export.js" ] && cmp -s "$NEW_JS" "$APP_DIR/export.js" && "$BIN" --selftest >/dev/null 2>&1; then
  SAME=yes
fi
mv -f "$NEW_JS" "$APP_DIR/export.js"

OUT_DIR="$OUT_DIR" SKIP_RAW="$SKIP_RAW" OLD_SKIP="$OLD_SKIP" CONFIG="$CONFIG" "$BUN" -e '
  const fs = require("fs");
  const raw = (process.env.SKIP_RAW || "").trim();
  let skip = [];
  if (/^none$/i.test(raw)) skip = [];
  else if (raw) skip = raw.split(",").map((s) => s.trim()).filter(Boolean);
  else { try { skip = JSON.parse(process.env.OLD_SKIP || "[]"); } catch { skip = []; } }
  fs.writeFileSync(process.env.CONFIG, JSON.stringify({ out_dir: process.env.OUT_DIR, skip, first_run_days: 7 }, null, 2));
'

# ---------- 5. Build one small program ----------
# Full Disk Access then goes to this one program, not to bun or Terminal.
# Rebuilding makes macOS treat it as a new program, so keep the old one when nothing changed.
built=no
if [ "$SAME" = yes ]; then
  built=yes
else
rm -f "$BIN"
if "$BUN" build "$APP_DIR/export.js" --compile --outfile "$BIN" >/dev/null 2>&1; then
  if "$BIN" --selftest >/dev/null 2>&1; then
    built=yes
  elif codesign --force --sign - "$BIN" >/dev/null 2>&1 && "$BIN" --selftest >/dev/null 2>&1; then
    built=yes
  fi
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

# ---------- 6. Schedule it: 6:10 AM before the morning message, 11:10 AM, 4:10 PM and 9:10 PM ----------
# The daytime runs keep texts fresh when they ask Claude during the day.
# A Mac that's asleep at any of these times runs it when it wakes.
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
  <array>
    <dict>
      <key>Hour</key><integer>6</integer>
      <key>Minute</key><integer>10</integer>
    </dict>
    <dict>
      <key>Hour</key><integer>11</integer>
      <key>Minute</key><integer>10</integer>
    </dict>
    <dict>
      <key>Hour</key><integer>16</integer>
      <key>Minute</key><integer>10</integer>
    </dict>
    <dict>
      <key>Hour</key><integer>21</integer>
      <key>Minute</key><integer>10</integer>
    </dict>
  </array>
  <key>RunAtLoad</key><false/>
  <key>ProcessType</key><string>Background</string>
  <key>StandardOutPath</key><string>$APP_DIR/export.log</string>
  <key>StandardErrorPath</key><string>$APP_DIR/export.log</string>
</dict>
</plist>
PLISTEOF
launchctl bootout "gui/$UID_NUM/$LABEL" 2>/dev/null || true
launchctl enable "gui/$UID_NUM/$LABEL" 2>/dev/null || true
if ! launchctl bootstrap "gui/$UID_NUM" "$PLIST" 2>/dev/null; then
  sleep 2
  launchctl bootstrap "gui/$UID_NUM" "$PLIST" 2>/dev/null || true
fi
if ! launchctl print "gui/$UID_NUM/$LABEL" >/dev/null 2>&1; then
  say "Your Mac didn't accept the daily schedule."
  echo "Open System Settings, then General, then Login Items."
  echo "Under Allow in the Background, switch on reframe-texts (it may show as bun). Then run this installer again."
  exit 1
fi
# Tell the chief of staff which schedule this Mac is on, so the morning message knows it's current.
if [ "$MODE" = "install" ]; then
  printf -- '---\nruns_per_day: 4\ntimes: "6:10 AM, 11:10 AM, 4:10 PM, 9:10 PM"\nset_up: %s\n---\n\nThe text export on this Mac runs at 6:10 AM, 11:10 AM, 4:10 PM and 9:10 PM.\n' "$(date '+%Y-%m-%d %H:%M')" > "$OUT_DIR/_schedule.md" 2>/dev/null || true
fi

# ---------- 7. Full Disk Access, the one step only you can do ----------
# When the program didn't change, skip this step only if the last run worked.
# If the last run failed (often Full Disk Access was never switched on), show the step again.
LAST_STATUS=""
for s in "$OUT_DIR/_status.md" "$APP_DIR/_status.md"; do
  if [ -f "$s" ] && { [ -z "$LAST_STATUS" ] || [ "$s" -nt "$LAST_STATUS" ]; }; then LAST_STATUS="$s"; fi
done
LAST_OK=no
if [ -n "$LAST_STATUS" ] && grep -q '^status: ok' "$LAST_STATUS" 2>/dev/null; then LAST_OK=yes; fi

echo "If a notice says a background item was added, that's this program. Leave it on."
if [ "$SAME" = yes ] && [ "$LAST_OK" = yes ]; then
  say "Nothing changed in the program, so Full Disk Access stays as it is."
else
  say "One step only you can do: switch on Full Disk Access for $FDA_NAME."
  echo "Two windows are opening now:"
  echo "  - System Settings, on Privacy & Security, then Full Disk Access"
  echo "  - Finder, with $FDA_NAME selected"
  echo ""
  if [ "$SAME" = yes ]; then
    echo "If $FDA_NAME is already in the list, make sure its switch is on."
    echo "If it isn't in the list, drag $FDA_NAME from the Finder window into the list, then switch it on."
  elif [ "$HAD_BIN" = yes ]; then
    echo "This is a new copy of the program, so the old switch won't work any more."
    echo "In System Settings, select $FDA_NAME, click the minus button, then drag $FDA_NAME in again and switch it on."
  else
    echo "Drag $FDA_NAME from the Finder window into the list in System Settings, then switch it on."
  fi
  echo "If dragging doesn't work: click the plus button, press Command, Shift and G together,"
  echo "paste this, press Return, then click Open:"
  echo "  $FDA_TARGET"
  echo "If your Mac asks for your password or Touch ID, that's your Mac asking, not this installer."
  echo "If it asks you to quit and reopen an app, choose Later."
  open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles" || true
  open -R "$FDA_TARGET" || true
  echo ""
  ask "Press Return once $FDA_NAME is switched on... " >/dev/null
fi

# ---------- 8. First run ----------
say "Copying your texts from the last 7 days now..."
STATUS="$OUT_DIR/_status.md"
STATUS2="$APP_DIR/_status.md"
BEFORE="$(stat -f %m "$STATUS" 2>/dev/null || echo 0)"
BEFORE2="$(stat -f %m "$STATUS2" 2>/dev/null || echo 0)"
launchctl kickstart -k "gui/$UID_NUM/$LABEL" 2>/dev/null || true
AFTER="$BEFORE"
for _i in $(seq 1 30); do
  sleep 2
  AFTER="$(stat -f %m "$STATUS" 2>/dev/null || echo 0)"
  if [ "$AFTER" != "$BEFORE" ]; then break; fi
  if [ "$(stat -f %m "$STATUS2" 2>/dev/null || echo 0)" != "$BEFORE2" ]; then STATUS="$STATUS2"; AFTER=changed; break; fi
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
  UNMATCHED="$(grep '^unmatched_skip:' "$STATUS" | head -1 | sed 's/unmatched_skip: *//; s/"//g')"
  say "Done. It works."
  if [ "$MSGS" = "0" ]; then
    echo "No new texts since the last run."
  else
    echo "Texts copied into My Brain/Texts: $MSGS"
  fi
  if [ -n "$UNMATCHED" ]; then
    echo ""
    echo "These names didn't match anyone in Contacts, so they aren't left out yet: $UNMATCHED"
    echo "Check how they're spelled in Contacts, then run this installer again with the exact names."
  fi
  if [ "$MODE" = "test" ]; then
    echo "This was a test run, so nothing is scheduled. Run the installer without --test to make it daily."
  else
    echo "From now on it runs four times a day: 6:10 and 11:10 in the morning, 4:10 in the afternoon and 9:10 at night."
    echo "If your Mac is asleep then, it runs when it wakes."
    echo "Install it on one Mac only."
  fi
else
  say "It ran but hit a problem:"
  grep '^error:' "$STATUS" | sed 's/error: *//'
  echo ""
  echo "If it mentions Full Disk Access, $FDA_NAME isn't switched on yet. Run this installer again and it shows you that step."
  echo "Otherwise, copy the line above into your chat with Claude and ask what went wrong."
  exit 1
fi
