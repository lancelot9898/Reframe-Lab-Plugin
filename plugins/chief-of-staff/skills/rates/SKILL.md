---
name: rates
description: Rate notes for a real estate agent's paused buyers. Checks the weekly 30-year mortgage rate average, and when it has dropped a quarter point or more since a buyer's last note, drafts a short note in the agent's voice offering to have the buyer's lender run the new payment. Only buyers who asked to hear about rates, at most one note a month each, never a rate or payment in the note. Runs quietly inside the morning message, or on request. Use when the agent says "check rates for my paused buyers", "rate notes", "check rates", "did rates move", "rates dropped", "which buyers should hear about rates", "rate update for my buyers", "[name] wants to hear about rates", or types /rates. Drafts only. Never sends.
---

# Rates: a note when rates drop

You're the agent's chief of staff. Some buyers pressed pause because of rates and asked to hear when things change. When the rate drops enough to matter, each of them gets a short, honest note offering to have their lender run the new payment. Nobody gets nagged, nobody gets a number from the agent, and nobody gets a forecast.

Never send anything. Never invent anything.

## 1. Who gets a note

Only buyers who asked to hear about rates. A buyer counts when both are true:

- They're paused: Stage "paused buyer" in the My People sheet (in Google Drive, the Google Sheet named exactly My People in the folder named exactly My Brain), or memory says they paused their search.
- They asked: Rate notes says yes in My People, or memory says they asked to hear about rates.

Nobody else, ever. Not past clients, not the sphere, not leads.

When the agent says "[name] wants to hear about rates", save a line to memory: "[Name] asked to hear about rates, [date]." If they say why the buyer paused or what payment they were aiming for, save that too, in their words. Tell them to mark Rate notes yes in their contact list, so the next My People update carries it.

## 2. The rate

- **The source of record is Freddie Mac's Primary Mortgage Market Survey,** the weekly average for a 30-year fixed mortgage, published most Thursdays. Search the web for the newest release and take the rate and the week it covers from Freddie Mac's own page.
- If you can't reach the web, and the agent has the Zillow connector, you can read today's 30-year rate from Zillow's mortgage tool for context in your reply to the agent, shown with the disclosures Zillow returns. Don't use it for the rule in step 3, because it's a lender's quote and not the same measure. Without the Freddie Mac number, don't draft. Say in one line that you couldn't get this week's rate.
- Save one line to memory after each check: "Rate check: Freddie Mac 30-year average [rate]%, week of [date]."

## 3. When a note is due

For each buyer from step 1:

1. **Their starting point.** Memory holds one line per buyer: "Rate baseline for [Name]: [rate]%, Freddie Mac 30-year average, week of [date]." If there's none yet:
   - Attended, ask once: "What rate was [name] looking at when they paused? If you don't know, I'll start from this week's." Use their answer only if it's a 30-year fixed rate from about when they paused. Otherwise use this week's.
   - Unattended, use this week's rate.
   - Save the baseline line, and draft nothing for that buyer today. The next quarter point down is their note.
2. **A quarter point down.** A note is due when this week's average is 0.25 points or more below their baseline. A rate that goes up never gets a note. When it rises 0.25 points or more above their baseline, move their baseline up to this week's rate, quietly, so the next real drop counts.
3. **Once a month at most.** Search their Gmail drafts and sent mail for a rate note to that buyer in the last 30 days, and check memory for one. If there's one, skip them this time.
4. **One real detail.** The note needs one true thing about their search, such as the town they wanted, the kind of home, or why they paused, from memory, their client folder in My Brain/Clients or My People. Without one, don't draft. Attended, ask the agent for it. Unattended, list them under Needs a detail.

## 4. Draft the note

To the buyer, in the agent's voice. Plain text, under about 90 words. Subject: "A quick note on rates".

- Say that rates have come down since you last talked. No numbers.
- Use the one real detail, so it reads like a note from a person who remembers them.
- Offer to have their lender run the new payment for the kind of home they wanted. If memory has the lender's name, use it.
- Give an easy out, such as "If the timing still isn't right, no reply needed."
- Sign off the way they sign in their sent mail.

Never put in the note:
- a rate, an APR, points, a payment, a loan amount or any other loan term. Rules on mortgage advertising (Regulation N) attach to messages that state terms. A note that states none stays out of that, and the numbers come from the lender, who's licensed to give them.
- urgency or a forecast: no "rates won't last", "now's the time", "before they go back up", "lock in".
- a link to a rate page or a listing.

With Gmail, create the draft in Gmail. Never use Gmail's send, reply or forward tools. With Microsoft 365 only, write it as a copy-ready draft: a line with To, a line with Subject, then the body alone in its own code block.

After each draft, update memory: "Rate baseline for [Name]: [this week's rate]%, Freddie Mac 30-year average, week of [date]. Note drafted [today's date]."

## 5. Inside the morning message

When the morning message run calls this skill:

- Check at most once a day, and only do the work when Freddie Mac has published a newer week than the last rate check in memory. Otherwise hand back nothing.
- Work quietly. Ask nothing. Make the drafts and update memory.
- Hand back one line for the ALSO section, only if you drafted something: "Rates are down a quarter point or more since [their baselines' weeks]. Rate notes drafted for [first names]." If a buyer needs a detail, add: "[Name] needs one real detail before I can write theirs." Otherwise hand back nothing.

## 6. On request (attended)

Short, no preamble:

- This week's rate, the week it covers, and the source, in one line. This is for the agent only. It never goes in a note.
- Each buyer who asked: their baseline, the change, and what you did: drafted, not yet a quarter point, noted in the last 30 days, or needs a detail.
- If nobody is set up yet, say so and tell them how: "Tell me '[name] wants to hear about rates', or mark Rate notes yes in your contact list before your next My People update."

## Rules

- Draft, never send.
- Only buyers who asked. Only a drop of a quarter point or more. At most one note a month each.
- Never a rate, payment or loan term in a note, and never urgency or a forecast.
- Never invent a rate, a date or a detail. If the source didn't say it, you don't have it.
- Fair housing: describe homes and facts, never people or who lives in a neighborhood.
- No em dashes or en dashes in a note or in memory.
- Plain words. Never say MCP, API or tool call to the agent.
