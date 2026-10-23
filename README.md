# Reframe Lab: Chief of Staff

DRAFT: member-facing copy goes through Lance's copy loop before publishing.

The Chief of Staff plugin for Building Your AI Chief of Staff, a Reframe Lab program from Lance Pendleton. It makes Claude a chief of staff for your real estate business. It learns who you are, drafts the emails you owe, turns your meetings into follow-ups, and keeps a note for each client. It drafts. You send.

## What you need

- Claude Pro, or any paid Claude plan. Plugins don't work on the free plan.
- The Claude desktop app, on a Mac or a Windows computer.
- Gmail and Google Calendar, connected in Customize > Connectors. Google Drive too, for client notes and backups.
- On Outlook? Read "If you use Outlook" below first.

## Install it once

1. Open the Claude desktop app.
2. Click Customize in the left sidebar.
3. Click Plugins.
4. Click Add, then Add marketplace.
5. Click Add from a repository.
6. Type `[NEEDS LANCE: github-owner]/reframe-lab-plugin`
7. Leave Sync automatically on.
8. Click Sync.
9. Find Chief of Staff and click Add.

You're done when you type / in a new chat and see setup, today, meeting, client and backup.

## The five commands

Type / and then the name. Claude also picks these up when you ask in plain words, but typing the name always works.

- **/setup** is the week 1 interview. You talk for about 45 minutes, and Claude learns who you are and how to work for you.
- **/today** reads your email and calendar and drafts what you owe. Your morning task runs it too.
- **/meeting** turns a voice note, a transcript or a recording into a follow-up draft, a list of who promised what, and a note in the client's folder.
- **/client** and a name, such as /client Bob Johnson, shows everything Claude knows about that client on one page.
- **/backup** saves what Claude remembers to a dated Google Doc. It can run once a month on its own.

## It drafts. You send.

Nothing in this plugin sends an email. Your replies wait in Gmail Drafts until you read them and press send. In week 1 you also set Gmail's send, reply and forward to Blocked, so Claude can't send even by mistake.

## If you use Outlook

On Pro, Claude can read your Outlook mail and calendar through the Microsoft 365 connector, but it can't save drafts in Outlook. So Claude writes each draft out for you to copy. The Claude for Outlook add-in can draft straight into Outlook. Both need a work Microsoft 365 account, and your brokerage's IT has to approve them once. Personal Outlook.com and Hotmail addresses can't connect.

## Updates

Updates arrive on their own, with nothing to accept. If something looks out of date, go to Customize > Plugins and click Check for updates.

## For maintainers

Change `version` in `plugins/chief-of-staff/.claude-plugin/plugin.json`, run `claude plugin validate .` from the repository root, and push to the default branch.
