---
name: backup
description: Backs up everything Claude remembers about a real estate agent and their clients into a dated Google Doc, "Claude memory backup YYYY-MM-DD", in My Brain/Backups in their Google Drive. Writes memory out word for word, adds their Instructions for Claude if they paste it in, and says how to restore. Also runs as a monthly scheduled task. Use when the agent says "back up my memory", "back up Claude", "back up what you know", "save what you remember about me", "export my memory", "make a backup", "set up my monthly backup", "how do I restore my memory", or types /backup.
---

# Backup: what Claude remembers, saved to a Google Doc

Claude's memory lives in the agent's Claude account. There's no export button for it. Anthropic's own way to export memory is to ask Claude to write it out word for word. This skill does that, into a dated Google Doc the agent owns.

## 1. Attended or unattended

- **Attended:** someone typed /backup or asked. Start with step 2.
- **Unattended:** this is a scheduled task, or the request says it's the scheduled backup. Ask nothing. Skip step 2, and note in the Doc that the instructions weren't included.

## 2. Instructions for Claude (attended only)

Ask: "Want your Instructions for Claude in the backup too? Open Settings, then General. Click in the Instructions for Claude box, select everything, copy it, and paste it here. Or say skip."

Use exactly what they paste.

## 3. Write memory out

Write out everything you remember about the agent and their clients, verbatim, exactly as it appears in your memory.

- Go topic by topic until every topic is done. Use each topic's name as its heading.
- Don't summarize, shorten, reword, merge, fix or add anything.
- If anything looks like a Social Security number, an account number or a password, write [REMOVED] in its place. Those shouldn't be in memory at all.
- If memory is off or empty, say so and stop. There's nothing to back up.

## 4. Create the Google Doc

If Google Drive is connected:

1. Find the folder named exactly My Brain. Ignore folders whose names only contain those words, such as "My Brain Setup Kit". If more than one is named exactly My Brain, stop and ask which to use. In an unattended run, stop and write nothing. If there's none, create it at the top of their Drive.
2. Find the Backups folder inside My Brain, or create it.
3. Create a new Google Doc there called "Claude memory backup YYYY-MM-DD", with today's date. Upload the text with conversion to Google Docs left on. If a Doc with that name already exists, add " (2)" to the new one.

Create only. Never edit or delete an older backup. Together they're the history.

Put this in the Doc, in this order:

```
Claude memory backup, [Month D, YYYY]

How to restore: start a new chat in Claude and paste in the Memory section below. Then type: Add all of this to your memory. Check Settings > Memory afterwards.
To restore your instructions, paste the Instructions for Claude section into Settings > General > Instructions for Claude.

This Doc holds what Claude knows about you and your clients. Keep it private. Don't share this folder.

Memory
[each topic: its name, then its text, word for word]

Instructions for Claude
[their text, or: Not included in this backup.]
```

**If Google Drive isn't connected**, or they're on Microsoft 365 only: on the Pro plan, Claude can't save files to OneDrive, so put the whole backup in your reply, in one code block. Tell them to paste it into a document they keep somewhere private. Say once that connecting Google Drive in Customize > Connectors lets /backup save it for them.

## 5. Tell them

- **Attended:** "Saved: Claude memory backup YYYY-MM-DD, in My Brain/Backups. [N] topics." Then one sentence on how to restore: paste the Memory section into a new chat and ask Claude to add it to memory.
- **Unattended:** one line only: "Backup saved." If something stopped it, one line saying what.

## Make it monthly

When they want this as a monthly task:

1. Propose a scheduled task named "Monthly memory backup", on the 1st of each month, early morning, with no folder. If monthly isn't offered, weekly works too. Use these instructions, word for word:

```
This is my scheduled monthly backup. Use the backup skill from the Chief of Staff plugin, unattended. Write out everything you remember about me and my clients, verbatim, exactly as it appears in your memory. Create a new Google Doc called "Claude memory backup YYYY-MM-DD", with today's date, in My Brain/Backups in my Google Drive. Create only. Never edit or delete a file. Ask me nothing. Write no report.
```

2. They check the task names no folder, then click Schedule.
3. They open the task and click Run now once, the day they make it. If it asks to allow a tool, they choose the option that allows it for all scheduled runs.

## Rules

- Never send, share or move anything. Never delete anything.
- Never invent a memory. Write out only what's there.
- Plain words. Never say MCP, API or tool call to the agent.
