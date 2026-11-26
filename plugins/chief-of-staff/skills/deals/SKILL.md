---
name: deals
description: The board, for a real estate agent's chief of staff. Every active buyer, seller and listing on one page, in the agent's stages: under contract by phase with days to close, the next date and a health flag; active listings; then pre-contract clients in the three physical stages (searching or preparing to list, nurturing, initial contact) with a dollar on every line and the 60/30/10 read. Built from the open transactions in reZEN, the deal files in Google Drive, My People, memory and the calendar. For a team leader, "deals team" shows the team's deals by agent. Use when the agent says "what's on my board", "where do all my deals stand", "what's closing this month", "what's under contract", "show me my pipeline", "how many buyers do I have", "what's late", "deals team", or types /deals. Read-only. Never sends.
---

# Deals: the board

The agent wants every deal on one page, once a week or whenever they feel behind. Not one deal (that's /deal), all of them, with the ones that need them first. You build it from what reZEN, the deal files, My People and memory already hold. You never ask them to update anything.

Keep it short. Never send anything. Never invent anything.

## 1. Check what's connected

- **The reZEN reader:** `rezen_transactions`, `rezen_transaction`, `rezen_checklist`, `rezen_me`, `rezen_team`. With it, reZEN is the source for everything under contract and every active listing. Without it, build the board from deal files, My People and memory, and say once at the end: "Install the reZEN reader and the board will read your contracts too."
- **Google Drive:** for the deal files (My Brain/Clients/*/ "Deal," files) and My People (My Brain/People). Without it, use memory alone and say so under Gaps.
- **Calendar:** for dates in the next 30 days. Without one, carry on.
- **Email and texts:** only to check whether a late item was actually done. Don't read the whole inbox for this.

## 2. Read

- **reZEN:** `rezen_transactions` for the open transactions and the active listings. For each open sale or lease closing in the next 45 days, `rezen_transaction` for the dates and `rezen_checklist` with `onlyOpen` true for the required count. Skip referral transactions unless the agent asks. Never pass `includeMoney`.
- **Deal files:** the newest "Deal," file in each client folder, for stage, promises and the last next step.
- **My People:** the Google Sheet "My People" in My Brain/People. Rows with Type client and a Stage of buyer, seller, under contract, or any stage the agent uses. Read the Last contact column.
- **Memory:** every client with an active search, a listing in preparation or a deal, and every budget or expected price the agent has given.
- **Calendar:** events in the next 30 days that name a client or an address.

Use the time zone on their calendar.

## 3. Put every client in a stage

Each client sits in exactly one stage. Use the physical definitions; nothing here is a feeling.

**Under contract** (from reZEN): a sale or lease with an acceptance date and no closing date in the past. Phase from the dates: under contract, inspections, title and financing, contingencies, getting to closing, closing this week.

**Active listing** (from reZEN): a listing transaction with a listing date and no contract yet.

**Searching** (buyers): the agent is showing them homes this month. Evidence: a showing on the calendar, a ShowingTime email, or the agent's own words in memory.
**Preparing to list** (sellers): a listing consultation happened and the home is being readied. Evidence: a consultation in memory or on the calendar, prep steps in email.

**Nurturing**: on a collection or a search alert (buyers), or planning to sell inside three months (sellers), with nothing above true.

**Initial contact**: has said they'll buy or sell sometime in the next twelve months, and nothing above is true.

Past clients, paused buyers and anyone with no stated intent stay off the board.

**Every line carries a number.** A buyer's budget or a seller's expected price, from memory, My People or the deal file. If there's none, write "$[NEEDS REVIEW]" and keep the line; never leave it at zero and never make one up.

## 4. Health, for everything under contract and every listing

- **Late:** a key date passed and nothing shows it was done; a required checklist item is past its due date and not accepted; a promise by the agent is past due.
- **Watch:** a required checklist item is due in the next 3 days and not accepted; a key date is in the next 3 days; a promise is due tomorrow; or there has been no email, text or calendar event on the deal in 14 days while under contract.
- **On track:** none of the above.

Check a Late item against email and texts before you call it late. A sent email or a text that did the thing clears it.

## 5. The board

Under about 400 words for a solo agent. These headings, in this order. Leave out a heading with nothing under it, except the pipeline counts.

**NEEDS YOU**
At most three lines, the most consequential first: a late item, a date in the next 2 days with something open, a promise due.

**UNDER CONTRACT**
- [Client], [address], [buyer or listing side]. Closes [date], [N] days. Next: [what, date]. Open on the contract: [N] required. [Late, Watch, or On track.]

**ACTIVE LISTINGS**
- [Address], listed [date], [N] days. Next: [what, date]. [Late, Watch, or On track.]

**SEARCHING / PREPARING TO LIST**
- [Client], $[budget or price]. Last touch [date]. Next: [what].

**NURTURING**
- [Client], $[number]. Last touch [date].

**INITIAL CONTACT**
- [Client], $[number]. Last touch [date].

**THE SHAPE**
[N] initial contact, [N] nurturing, [N] searching or preparing: [the split as percentages] against 60 / 30 / 10. One line on what it means: for example, "Thin at the top. Spring comes from the initial-contact column, and there are four names in it."

**GAPS**
What you couldn't reach, clients with no dollar, and any two sources that disagree.

Rules for the board:

- One line per client. Couples are one client, spelled the way the agent spells them.
- Dates from reZEN first, the deal file second, memory third. Name a conflict under Gaps.
- Never put commission, splits or payouts on the board.
- Referral transactions appear only as a count under Gaps ("3 referrals open in reZEN"), unless asked.

## 6. Team mode

When a team leader says "deals team": the reZEN reader already returns every transaction where they are a participant, which on a team includes the team's deals (the leader is on each file as PRO_TEAM_LEADER). Group UNDER CONTRACT and ACTIVE LISTINGS by agent, using the SELLERS_AGENT or BUYERS_AGENT participant's name on each file. Leave out the pre-contract stages, which live in each agent's own Claude. Add one line at the end: "[N] open, [N] closing in 30 days, [N] late."

If `rezen_me` has no team, say so and give the solo board.

## 7. Save it

Only when they ask ("save my board", "file this"), or on a Monday run from the monday skill: create a Google Doc "YYYY-MM-DD Deals" in My Brain/Deals, with the board as written. Create only. Never edit or delete an earlier one.

Save to memory any stage change you learned (for example, a buyer who moved from nurturing to searching), as one short line naming the client. Don't save the board itself.

## 8. End

In an attended run, end with one line: "Say 'deal' and a name for the full page on any of these." If a client has no dollar, add: "Give me a budget or price for [names] and the shape will be honest."

## When the Monday report calls this skill

The monday skill may include the board under its own headings. Build it the same way; don't repeat the explanations.

## Rules

- Read only in reZEN. Nothing here creates, changes, sends or signs anything there.
- Never send anything. Never create, change or answer a calendar event.
- Never invent a client, a date, a number or a stage. [NEEDS REVIEW] where something is missing.
- Plain words. Never say MCP, API or tool call to the agent. Call it "the reZEN reader".
