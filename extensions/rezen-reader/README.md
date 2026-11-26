# reZEN reader

A read-only Claude Desktop extension for Real's reZEN, built for the Reframe Lab Chief of Staff. Five tools, all reads: who am I, my open deals and active listings, one deal in full (dates, people, status), its compliance checklist, my team. It never creates, edits, sends or signs anything in reZEN. Commission, splits and payouts are left out of every answer unless a tool is asked for them, because the deal file and Claude's memory should never carry them.

## Install (agents)

1. In reZEN: three dots, Security Settings, Recent API Key, Generate Key. Copy it.
2. Double-click `rezen-reader.mcpb`. Claude Desktop asks for the key once and stores it in the operating system's keychain (manifest field `api_key`, `sensitive: true`).
3. In a new chat, type /deals.

The extension reaches reZEN only from the desktop app. A scheduled morning message that reads reZEN runs as a desktop scheduled task while the app is open.

## Build

```
cd extensions/rezen-reader
npm install
REZEN_API_KEY=... node test/smoke.mjs      # read-only smoke test against your own account
npx -y @anthropic-ai/mcpb@latest validate manifest.json
npx -y @anthropic-ai/mcpb@latest pack . ../../dist/rezen-reader.mcpb
```

## Run it without the extension (Claude Code or a hand-edited desktop config)

A launcher that reads the key from the macOS Keychain and starts the server:

```
KEY=$(security find-generic-password -s rezen-api -a lance -w); REZEN_API_KEY="$KEY" node server/index.js
```

Store the key once with `security add-generic-password -U -s rezen-api -a <you> -w`.

## Hosts and endpoints used

- `yenta.therealbrokerage.com/api/v1`: `users/me`, `teams/{id}`
- `arrakis.therealbrokerage.com/api/v1`: `transactions/participant/{agentId}/transactions/lifecycle-group-counts`, `.../transactions/{OPEN|CLOSED}?pageNumber&pageSize`, `.../listing-transactions/LISTING_ACTIVE?pageNumber&pageSize`, `transactions/{id}`
- `sherlock.therealbrokerage.com/api/v1`: `checklists/{id}`

Real publishes no terms on third-party use of the agent key. Keep this read-only.
