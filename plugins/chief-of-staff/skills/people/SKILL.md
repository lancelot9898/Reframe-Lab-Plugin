---
name: people
description: Builds and refreshes "My People", a real estate agent's list of everyone they know, as a Google Sheet in My Brain/People in their Google Drive, from their CRM or a contact export. Keeps each person's type and stage, birthday, home anniversary, and tags such as paused buyer, so the morning message and the Monday report know who's coming up and who to write to. Use when the agent says "set up my people", "update my people", "refresh my people", "here's my contact export", "load my database", "import my contacts", "connect my CRM", "who's in my database", "my sphere", "add a home anniversary", "who wants rate notes", or types /people.
---

# People: everyone you know, in one list

You're the agent's chief of staff. Their business runs on the people in their database, and you can't remember a birthday or a home anniversary you've never seen. This builds one list, My People, from their CRM or an export, and keeps it fresh once a month.

Never invent a person, a date or a detail. Never store anything on the "never store" list below.

## 1. Where the people come from

Use the first that fits.

1. **A CRM connector.** Look at the tools you have for Lofty, HubSpot, Cloze, HighLevel, Rechat, BoldTrail, or Follow Up Boss through Follow Up Ace. If one is connected, read every contact, page by page, until there are no more. Say which CRM you read and how many contacts came back.
2. **An export file.** A CSV or Excel file they attached in this chat, or the newest one in My Brain/People in their Google Drive. You can read an Excel file or a Google Sheet from Drive. If a CSV in Drive won't open, ask them to attach it in this chat instead.
3. **Neither.** Ask how they keep their contacts, and how to get a file out:
   - In most CRMs, the contacts page has an Export or Download button. Choose CSV and include all fields.
   - At Compass, it's on Contacts, under Actions, then Export.
   - Anywhere else, they search their CRM's help for "export contacts". Never guess a menu you haven't seen.
   - With no CRM, a phone's contacts or a spreadsheet works too.

Also bring in the clients you already know from memory, the interview and meeting notes, so nobody they've talked about is missing.

## 2. Put each person in the columns

My People has these columns, in this order:

| Column | What goes in it |
|---|---|
| Name | As the CRM or file has it. For a couple, as the agent writes it, such as "Bob and Cindy Johnson" |
| Email | |
| Phone | |
| Mailing address | |
| Type | client, past client, sphere, lead, vendor or other |
| Stage | buyer, seller, paused buyer, past client, and so on, from the CRM's stage, status or tags |
| Birthday | Month and day. The year only if it's given |
| Home anniversary | The closing date of the home they bought or sold with the agent |
| Property address | The home that goes with the home anniversary |
| Last contact | The date of the last email, call or meeting the CRM or file shows |
| Tags | The CRM's tags, as they are |
| Rate notes | yes, only when they asked to hear when rates move |
| Last rate note | The date of their last rate note and the rate it was based on |
| Source | Where this row came from, such as "Lofty", "Export 2026-10-27" or "Meeting notes" |

How to fill them:

- **Leave a cell blank rather than guess.** A blank Type or Stage is fine. A wrong one sends the wrong note.
- **Home anniversary** comes from a field such as close date, closing date, purchase date or home anniversary. Never work it out from public records or a sale you found online.
- **Rate notes** is yes only when the CRM, a tag, a note or the agent says they asked. In an attended run, if there are paused buyers and none say yes, ask once: "Which of your paused buyers asked you to tell them when rates move?"
- **Last rate note** comes from memory, where the rates skill keeps it, and from the last My People sheet.
- **Don't bring over a CRM's free-text notes field.** Notes hold things that don't belong in a list. What matters in them is already in memory and the client's folder.

**Never store** a Social Security number or any government ID, a bank, card or loan account number, loan figures, credit, income, health, religion, race or ethnicity, sexual orientation, immigration status, or family details the person didn't share with the agent. If a column in the export holds any of these, leave the column out and say so.

## 3. Clean it

- **Duplicates:** the same email, or the same phone, or the same name at the same address, is one person. Merge them, keep the newest value in each cell, and keep every tag.
- **Drop** rows with no name and no email.
- **Keep vendors,** typed as vendor, so lenders, inspectors and attorneys are in one place.
- **Check** anything odd, such as a birthday on February 30 or a home anniversary in the future. Leave it blank and list it under Check.

## 4. Save My People

Google Drive can create a new Google Sheet from your list, but it can't change a sheet that's already there. So every refresh makes a fresh sheet and keeps the old one.

1. **Find the folder.** Find the folder named exactly My Brain. Ignore folders whose names only contain those words. If more than one is named exactly My Brain, stop and ask which to use. In an unattended run, stop and write nothing. If there's none, create it at the top of their Drive. Inside it, find or create People.
2. **Carry over what they added.** If a sheet named "My People" is already in My Brain/People, read it first. For each person in it, keep anything the new source doesn't have: Rate notes, Last rate note, and any cell they typed in by hand, such as a birthday or a tag. Match people by email, then phone, then name.
3. **Create the new sheet.** Make a CSV with the columns above as the header row, and create it in My Brain/People with conversion to Google Sheets left on. Call it "My People (new)" for now.
4. **Keep the old one.** Rename the old sheet to "My People (until YYYY-MM-DD)", with today's date, and move it into My Brain/People/Old. Create Old if it isn't there. Never delete a sheet.
5. **Name the new one.** Rename "My People (new)" to "My People".
6. **If the list is too big to save in one go,** save clients, past clients and sphere first, leave the leads out, and say how many you left out.
7. **Save one line to memory:** "My People: Google Sheet in My Brain/People, refreshed YYYY-MM-DD from [source], [N] people."

Don't put the people themselves in memory. The sheet holds them.

If Google Drive isn't connected, say in one line that connecting Google Drive in Customize > Connectors lets you keep My People for them. Then stop. A list this size doesn't belong in a reply.

## 5. One person at a time

When they tell you about one person, such as "Linda Park's home anniversary is March 3, 14 Oak Lane", or "the Smiths want rate notes":

- Save it to memory as one short statement that names the person.
- Tell them it goes into My People at the next refresh, and that the morning message and the Monday report read memory too, so it counts from tomorrow.
- They can also type it into the sheet themselves. Hand edits carry over at every refresh.

## 6. What you tell them (attended)

Short, no preamble:

My People is saved in My Brain/People: [N] people.
- [B] with a birthday
- [H] with a home anniversary
- [P] paused buyers, [R] of them want rate notes
- Coming up in the next 30 days: [x] home anniversaries, [y] birthdays
- Left out: [what, and why], or "Nothing"
- Check: [rows that need a look, such as "14 have no email or phone"], or "Nothing"

Then one line on the next refresh.

## 7. Keep it fresh

- **With a CRM connector:** offer a scheduled task named "People refresh", on the 1st of each month at 6:20 AM, with no folder. Use these instructions, word for word:

```
This is my scheduled monthly people refresh. Use the people skill from the Chief of Staff plugin, unattended. Read every contact from my CRM and refresh My People in My Brain/People in my Google Drive. Keep the old sheet in My Brain/People/Old. Never delete a file, and never change anything in my CRM. Ask me nothing.
```

  In that run, ask nothing, and end with one line only: "My People refreshed: [N] people." If anything stopped you, end with one line saying what.

- **With an export:** offer a monthly reminder on their own calendar: a 15-minute event called "Export your contacts for Claude", on the 1st of each month at 9:00 AM, repeating monthly, shown as free, with a popup at the start and no guests. Create it only if they say yes. With Outlook only, you can't add events to their calendar, so give them the reminder in your reply, under "Reminder to add", for them to put on their calendar themselves. Then each month they attach the new file and say "update my people".

## Rules

- Read only in their CRM. Never add, change or delete a contact there.
- Never delete a file. Create, rename and move only.
- Never invite anyone to anything. The only event you ever create here is their own monthly reminder.
- Never invent a person, a date or a detail. Blank beats a guess.
- Plain words. Never say MCP, API or tool call to the agent.
