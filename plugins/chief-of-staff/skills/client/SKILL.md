---
name: client
description: Everything a real estate agent knows about one client, on one page. Who they are, where they are in the process, what was promised and by whom, what's overdue, preferences and sensitivities, and the next step. Pulls from Claude's memory, the client's folder in Google Drive (My Brain/Clients), recent Gmail or Outlook email, and the calendar, then offers to draft the next email. Use when the agent says "what do I know about", "pull up", "tell me about", "catch me up on", "where are we with", "where am I with", "brief me on", "prep me for my call with", "what did I promise", "remind me who", or types /client followed by a name.
---

# Client: one page on one person

The agent wants everything they know about one client, fast, often on a phone before a call. Gather it, put it on one page, and offer to draft the next email.

## 1. Who

Take the name from the request. If there's no name, ask. If two people in memory or email fit, ask which. Use the agent's spelling.

## 2. Gather

Read from everything you can reach. Read only. Change nothing.

- **Memory:** everything you remember about this client.
- **Google Drive:** find My Brain/Clients/[Client Name]. Read the notes in it, newest first. If there's no folder, say so in one line. Use the folder named exactly My Brain, and ignore folders whose names only contain those words. If more than one is named exactly My Brain, ask which to use.
- **Email:** Gmail or Outlook. Threads with them from the last 90 days, sent and received, newest first. Search results can show only the oldest messages in a thread, so open the whole thread.
- **Calendar:** events with them in the last 30 days and the next 30.

If a connector isn't there, carry on and note it under Gaps.

## 3. The page

Use these headings, with short lines under each. Keep it under about 350 words, so it reads on a phone.

**Who they are**

**Where they are in the process**

**Promised**
- By you: [what], by [date], done or open
- By them: [what], by [date], done or open

**Overdue**

**Preferences and sensitivities**

**Next step**

**Gaps**

- If a heading has nothing, write "Nothing found."
- Overdue means the date has passed and nothing in email or the notes shows it was done.
- Next step: one step. Take a position.
- Sensitivities: say what to be careful about in a few words, never the private details. Skip anything the agent asked you never to keep or repeat.
- When sources disagree, the newest written source wins. Name the conflict under Gaps.
- Gaps also lists anything you couldn't reach and every [NEEDS REVIEW].
- Never invent anything. Never fill a gap with a guess.

## 4. Offer the next email

End with: "Want me to draft the next email to [first name]?"

If they say yes:

- **Gmail:** draft it inside the latest thread between the agent and this client alone, or as a new email if there's none. A thread that includes other people, such as an introduction, would copy them, so start a new email instead. Never use Gmail's send, reply or forward tools. Reply and forward send at once.
- **Microsoft 365 only:** give it as a copy-ready draft: a line with To, a line with Subject, then the body alone in its own code block. Say once that the Claude for Outlook add-in can draft straight into Outlook. Never say or suggest it was saved in Outlook.
- **No email connector:** give it as a copy-ready draft.
- Never draft contract terms, legal positions or dollar figures. Where the email needs one, write [NEEDS REVIEW: the figure].

If the agent corrects a fact on the page, offer to update memory.

## How drafts sound

- Their voice comes first. Their Instructions for Claude and what memory holds about how they write win over anything here.
- By default: short, plain, and sounding like them on a good day. Open with the point. Sign off the way they sign in their sent mail.
- No AI tells: no "I hope this finds you well", no piles of exclamation points, no em dashes or en dashes.
- Plain text. No bold, no bullet symbols, no headings in an email.
- Fair housing: describe the property and the facts. Never describe people, or a neighborhood by who lives there. No "great for families", no "safe area", no "perfect for retirees".
- Never put a Social Security number, an account number or loan figures in a draft.
- Never invent a name, number, date or commitment. If it wasn't said or written, write [NEEDS REVIEW].

## Rules

- Draft, never send. Never create, change or answer a calendar event.
- Plain words. Never say MCP, API or tool call to the agent.
