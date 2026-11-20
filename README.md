# Reframe Lab: Chief of Staff

The Chief of Staff plugin for Building Your AI Chief of Staff, a Reframe Lab program from Lance Pendleton. It makes Claude a chief of staff for your real estate business. Every morning it puts your day on your phone with the replies you owe already drafted. After every conversation it writes the follow-up and puts your to-dos on your calendar. It keeps a note for each client, a list of your people, and your brand, so everything it makes sounds and looks like you.

## What you need

- Claude Pro, or any paid Claude plan. Plugins don't work on the free plan.
- The Claude desktop app, on a Mac or a Windows computer.
- Gmail and Google Calendar, connected in Plugins, in the left sidebar. Google Drive too, for My People, client notes, prep pages and backups.
- The Claude app on your phone, signed in with the same email. On Gmail, the Google Calendar app too, with notifications on, because your morning message arrives there as an alert.
- On Outlook? Read "If you use Outlook" below first.

## Install it once

1. Open the Claude desktop app.
2. Click Plugins in the left sidebar.
3. Click Add at the top right, then Add marketplace.
4. Click Add from a repository.
5. In the URL box, type `lancelot9898/Reframe-Lab-Plugin`
6. Click Sync.
7. In the Plugins search box, type Chief of staff. Click the one by Lance Pendleton.
8. Click Add at the top right.

You're done when you type / in a new chat and see the Chief of Staff jobs, such as setup, today, meeting and client.

## Three commands to remember

Everything else arrives on a schedule or starts when you ask in plain words.

- /today gives you your morning message any time: the three things that matter today, your appointments, your deal dates, and the replies you owe, drafted.
- /meeting turns a voice note, a transcript or a recording into a follow-up draft, reminders on your calendar, and a note in the client's folder.
- /client and a name, such as /client Bob Johnson, shows everything Claude knows about that client on one page. Say "prep me for my 2:00" and it makes the prep page for that appointment.

## What arrives on its own

- **Every weekday morning:** your morning message, as a 7:00 calendar alert on your phone, and by email too if you'd like. On Outlook, it waits in Claude under Scheduled.
- **Every Monday:** your week on one page, with an update drafted for each seller.
- **The 1st of every month:** your marketing review, with posts and a newsletter planned and drafted.

## The jobs, week by week

- **Week 1, it learns you:** setup (the interview), brand (your brand kit), people (My People, from your CRM or an export), today (your morning message).
- **Week 2, your day:** meeting (after every conversation), client (one page on anyone, and prep pages), backup (a monthly copy of what Claude remembers).
- **Week 3, your people and your listings:** monday (the Monday report), seller-update (the Monday letter to each seller), rates (notes to paused buyers when rates move), market (a market report when you need one), compass (the weekly Compass check, for Compass agents), texts (your text messages, on a Mac, through the text export in tools/text-export).
- **Week 4, your marketing:** marketing (the monthly review, posts and newsletter), cma (a CMA), inspection (the inspection response).

## It drafts. You send.

Nothing in this plugin sends an email or a text. Your replies wait in Gmail Drafts until you read them and press send. In week 1 you also set Gmail's send, reply and forward to Blocked, so Claude can't send even by mistake.

## If you use Outlook

On Pro, Claude can read your Outlook mail and calendar through the Microsoft 365 connector, but it can't save drafts in Outlook. So Claude writes each draft out for you to copy. The Claude for Outlook add-in can draft straight into Outlook. Both need a work Microsoft 365 account, and whoever runs your brokerage's email has to approve them once, in one request. Personal Outlook.com and Hotmail addresses can't connect.

## Updates

Updates arrive on their own, with nothing to accept. If something looks out of date, click Plugins in the left sidebar, then Add, then Manage marketplaces. Click the three dots beside Reframe-Lab-Plugin, then Check for updates. If that doesn't do it, open Chief of staff, click the three dots at the top right, click Remove, then search for it again and click Add. Your memory stays. Add it back right away, since your scheduled tasks use it.

## For maintainers

In Claude Code, the install is one line: `/plugin install chief-of-staff --marketplace lancelot9898/Reframe-Lab-Plugin`

Change `version` in `plugins/chief-of-staff/.claude-plugin/plugin.json`, run `claude plugin validate .` from the repository root, and push to the default branch.
