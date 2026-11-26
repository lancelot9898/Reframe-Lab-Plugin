---
name: under-contract
description: The one-time setup when a real estate agent goes under contract, for their chief of staff. Finds the deal in reZEN, takes every contract date from it and asks once for any the workflow needs that reZEN doesn't hold, puts each deadline on the agent's calendar with a reminder two days before, drafts the client's "here is what happens next" email and the handoff email to the TC, creates the first deal file in the client's folder, and saves the dates and people to memory. Use when the agent says "we're under contract", "we went under contract on 381 South Ames", "the contract was accepted", "offer accepted", "set up the Johnson deal", "new deal", "put the contract dates on my calendar", "start the file for", or types /under-contract followed by a client or an address. Read-only in reZEN. Drafts only. Never sends.
---

# Under contract: set the deal up once

A contract just got accepted. The agent wants three things in the next ten minutes: the deadlines where they can see them, the client told what happens next, and the TC handed the file. You do all three from what reZEN already holds, ask once for anything it doesn't, and never send.

They're real estate agents, mostly not technical. Keep it short. Never send anything. Never invent anything.

## 1. Check what's connected

- **The reZEN reader:** `rezen_transactions`, `rezen_transaction`, `rezen_checklist`. The deal has to be in reZEN for this to read the dates; if the agent's TC or Leo hasn't filed it yet, the dates come from the agent instead (step 3).
- **Calendar:** Google Calendar or Microsoft 365. Without one, give the dates in your reply and skip step 4.
- **Email:** Gmail or Microsoft 365, for the two drafts. Without one, write copy-ready drafts.
- **Google Drive:** for the deal file. Without it, put the deal file's contents in your reply.

Only in a chat they're in. Never in a scheduled run.

## 2. Which deal

Take the client's name or the address from the request. With the reZEN reader, call `rezen_transactions` and match on the address, or on a person's name among the deal's people. If two fit, ask. If none fits:

- Say: "I don't see [address] in reZEN yet. Once your TC files the contract there, run this again and I'll read the dates. Or give me the dates now and I'll set everything up from them." Then carry on with whatever they give you.

Spell the client's name the way the agent does. Work out the side (buyer or listing) from reZEN's `side`, or ask.

## 3. The dates

From `rezen_transaction`, take: contract acceptance, closing (estimated), inspection expiration, financing conditions expiration, condo or HOA documents expiration, sale of buyer's property expiration, other conditions expiration, possession if present.

Then open the step reference for the side (`../deal/reference/seller-workflow.md` or `../deal/reference/buyer-workflow.md`) and read the line "Dates this workflow keys off." For each date the workflow needs that reZEN doesn't hold, ask once, in one message, as a short list the agent can fill in from the contract's dates and deadlines page: for example, earnest money deadline, seller disclosure delivery deadline, inspection objection and resolution deadlines, appraisal deadline and objection deadline, HOA document delivery and objection deadlines, loan commitment deadline, title objection and resolution deadlines, survey deadline, possession or move-out date. Say: "Give me the ones that apply and skip the rest." Dates they skip are left blank, never guessed.

If they paste the dates and deadlines page or the contract, read the dates from it. Use the agent's dates where they and reZEN disagree, and flag the disagreement under Gaps.

## 4. The calendar

For every date you have, put one all-day event on the agent's own calendar (Google Calendar, or Outlook through Microsoft 365, on the same account as their email):

- Title: "[Street address]: [what]", such as "381 South Ames: inspection objection deadline".
- All day, on the date. Shown as free. No guests. Send no invitation.
- A popup reminder 2 days before at 9:00 AM, and one the morning of.
- Closing gets a second event titled "[Street address]: closing week" on the Monday of that week, so the week starts with it in view.
- **Never twice.** Before each one, check the calendar for an event with the same title on the same date. If it's there, leave it.
- **Never touch another event.** Never change, move, answer or delete anything already on the calendar. If a date changes later, the agent says so and you add the new event and tell them to delete the old one, or do it only when they ask in that chat.

If a date is blank, no event. Say which ones have no date under Gaps.

## 5. Two drafts

**To the client: what happens next.** Plain, in the agent's voice, under about 250 words. In this order: congratulations in one line; the dates that matter to them, each with one plain line on what it means and what they do (the inspection, the appraisal, the loan, the walkthrough, closing); who they'll hear from and about what (the TC by name if there is one, the lender, title); the one thing to do this week; "ask me anything, any time." No dollar figures. No contract language. Subject: "What happens next on [street address]".

**To the TC: the handoff.** Only if a TC is on the file (a participant with role TRANSACTION_COORDINATOR in reZEN, or the TC in memory). Short: the address and side; the client's name; the other agent, lender and title by name; every date with its deadline; what the agent has already done; what the agent needs from them first. Subject: "[Street address]: under contract, [closing date]". If the agent has no TC, skip this draft and say so.

- **Gmail:** create each draft in Gmail. A reply inside the latest thread with that person alone where there is one, otherwise a new email. Never use Gmail's send, reply or forward tools. Reply and forward send at once.
- **Microsoft 365 (Outlook):** create each draft with Microsoft 365's draft tools. Never use its tools that send mail, forward mail, send a draft, answer an event, post in Teams, set automatic replies or make inbox rules. If it has no draft tool, or it fails, give copy-ready drafts: a line with To, a line with Subject, then the body alone in its own code block. Never say a draft is in Outlook unless the tool confirmed it.
- **No email connector:** copy-ready drafts.
- Never draft contract terms, legal positions or dollar figures. Write [NEEDS REVIEW: the figure] where one is needed.

## 6. The first deal file

If Google Drive is connected:

1. Find the folder named exactly My Brain. Inside it, Clients, then the client's folder, created if needed, named as the agent spells the name.
2. Create a Google Doc "YYYY-MM-DD Deal, [address]", today's date. Create only.
3. Put in it: The deal (address, side, type, price, stage "under contract", closing date). Key dates (every one, with its source: reZEN, the agent, or blank). Open on the contract (from `rezen_checklist` with `onlyOpen` true: every required item not accepted, with its due date). Who's on it (names and roles). Promised (nothing yet, or what the agent said). Next step. Gaps.
4. Never write commission, splits, payouts, account numbers, loan figures, access codes, or anything about anyone's health or family.

## 7. Memory

Save, each as its own short line naming the client: the address and side; "under contract, accepted [date], closing [date]"; each key date; the TC, lender, title and other agent by name. Don't save money or the drafts.

## 8. What you tell them

Under about 150 words, phone-friendly:

Set up: [address], [side], closing [date].
On your calendar: [N] dates, from [first] to [last].
Drafted: the client's what-happens-next email, and the handoff to [TC name]. In your drafts.
Deal file: saved in My Brain/Clients/[Client].
Still blank: [any dates with no value].
Then one line: "Say 'deal [client]' any time for where it stands."

## How drafts sound

- Their voice comes first. Their Instructions for Claude and what memory holds about how they write win over anything here.
- By default: short, plain, and sounding like them on a good day. Open with the point. Sign off the way they sign in their sent mail.
- No AI tells: no "I hope this finds you well", no piles of exclamation points, no em dashes or en dashes.
- Plain text. No bold, no bullet symbols, no headings in an email.
- Fair housing: describe the property and the facts. Never describe people, or a neighborhood by who lives there.
- Never put a Social Security number, an account number or loan figures in a draft.
- Never invent a name, number, date or commitment. If it wasn't said or written, write [NEEDS REVIEW].

## Rules

- Read only in reZEN. Nothing here creates, changes, sends or signs anything there.
- Draft, never send. The only calendar events you create are the deadline events in step 4, on the agent's own calendar, with no guests. Never change, delete or answer an event.
- Create the deal file, never edit one.
- Plain words. Never say MCP, API or tool call to the agent. Call it "the reZEN reader".
