# Text export for the Chief of Staff plugin (Mac only)

Four times a day, this copies your new text messages, with each person's name from Contacts, into `My Brain/Texts` in your Google Drive. Your chief of staff reads that folder, so it can see what you promised people by text.

- It only reads Messages and Contacts. It never sends a text.
- It runs at 6:10 AM, 11:10 AM, 4:10 PM and 9:10 PM. If your Mac is asleep then, it runs when it wakes.
- The first run copies the last 7 days.
- You can name people to leave out, such as family. A group chat with any of them in it is left out too.
- Login codes and texts from short codes (banks, pharmacies, deliveries) are skipped.
- Export files are deleted after 14 days. Google Drive keeps deleted files in its Trash for about 30 more days.
- Install it on one Mac only.
- If you've shared your My Brain folder with anyone, such as an assistant, they can see these files too.

## What you need

- A Mac with Messages signed in to your Apple ID.
- Google Drive for desktop, signed in to the same Google account your chief of staff uses.

## Install

Open Terminal (Command and Space, type Terminal, press Return), paste this line and press Return:

```
bash <(curl -fsSL https://raw.githubusercontent.com/lancelot9898/Reframe-Lab-Plugin/main/tools/text-export/install.sh)
```

The installer asks who to leave out, builds one small program called `reframe-texts`, and opens System Settings so you can switch on Full Disk Access for it. That's the one step only you can do. Full Disk Access goes to that one program, not to Terminal.

## Move an older install to four times a day

Run the install line again, type yes, and press Return to keep your list. The program itself hasn't changed, so Full Disk Access stays as it is. The installer writes `My Brain/Texts/_schedule.md` so your chief of staff knows which schedule you're on.

## Change who's left out

Run the install line again and type the new list, or type none to leave nobody out. If the program itself changed, the installer asks you to remove reframe-texts from Full Disk Access and add it again.

## Try it once without scheduling it

```
bash <(curl -fsSL https://raw.githubusercontent.com/lancelot9898/Reframe-Lab-Plugin/main/tools/text-export/install.sh) --test
```

## Turn it off

```
bash <(curl -fsSL https://raw.githubusercontent.com/lancelot9898/Reframe-Lab-Plugin/main/tools/text-export/install.sh) --uninstall
```

Then remove `reframe-texts` from System Settings, Privacy & Security, Full Disk Access.

## If something goes wrong

The program writes `My Brain/Texts/_status.md` every run. It says `status: ok` or the error. The log is at `~/Library/Application Support/ReframeLabTexts/export.log`.
