// Smoke test: spawn the server over stdio, list tools, call each one read-only.
// Run from this folder: REZEN_API_KEY=... node test/smoke.mjs
// Prints names as initials and never prints emails or phone numbers.
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
const key = process.env.REZEN_API_KEY;
if (!key) { console.error("Set REZEN_API_KEY"); process.exit(1); }
const transport = new StdioClientTransport({ command: "node", args: ["server/index.js"], env: { ...process.env, REZEN_API_KEY: key } });
const client = new Client({ name: "smoke", version: "0.0.1" });
await client.connect(transport);
const tools = await client.listTools();
console.log("TOOLS:", tools.tools.map((t) => t.name).join(", "));
const initials = (n) => (n || "").split(" ").map((w) => (w[0] ? w[0] + "." : "")).join(" ");
const call = async (name, args) => { const r = await client.callTool({ name, arguments: args || {} }); const t = r.content[0].text; let json = null; try { json = JSON.parse(t); } catch {} return { isError: !!r.isError, text: t, json }; };
let r = await call("rezen_me");
console.log("\n== rezen_me", r.isError ? "ERROR " + r.text : "ok | keys: " + Object.keys(r.json).join(","), "| teamId:", r.json?.teamId ? "yes" : "none");
const me = r.json;
r = await call("rezen_transactions", {});
console.log("\n== rezen_transactions", r.isError ? "ERROR " + r.text : "ok");
if (r.json) {
  console.log("counts:", JSON.stringify(r.json.counts));
  console.log("open:", r.json.open?.length, "| activeListings:", r.json.activeListings?.length ?? "none", r.json.activeListingsNote || "");
  for (const t of (r.json.open || []).slice(0, 8)) console.log("  -", t.type, "|", t.side, "|", t.status.internal, "/", t.status.external, "| close", t.closingEstimated, "|", (t.address || "").split(",").slice(-3).join(",").trim(), "|", t.id.slice(0, 8));
  for (const t of (r.json.activeListings || []).slice(0, 6)) console.log("  L", t.type, "|", t.status.internal, "| listed", t.listingDate, "|", (t.address || "").split(",").slice(-3).join(",").trim());
}
const sale = (r.json?.open || []).find((t) => t.type === "SALE" && t.status.internal !== "TERMINATION_REQUESTED") || (r.json?.open || [])[0];
if (sale) {
  r = await call("rezen_transaction", { transactionId: sale.id });
  console.log("\n== rezen_transaction", r.isError ? "ERROR " + r.text : "ok");
  if (r.json) { const j = r.json; console.log("side:", j.side, "| represents:", j.owner?.represents, "| client:", initials(j.clientName)); console.log("dates:", JSON.stringify(j.dates)); console.log("people:", j.people.map((p) => `${initials(p.name)} (${p.role})`).join(", ")); console.log("checklistId:", j.checklistId ? "yes" : "none", "| warnings:", j.warnings.length, "| errors:", j.errors.length, "| money present:", "money" in j); }
  r = await call("rezen_checklist", { transactionId: sale.id, onlyOpen: true });
  console.log("\n== rezen_checklist(onlyOpen)", r.isError ? "ERROR " + r.text : "ok");
  if (r.json) { console.log("summary:", JSON.stringify(r.json.summary)); for (const i of r.json.items.filter((i) => i.required).slice(0, 8)) console.log("  -", i.name, "|", i.status, "| due", i.dueDate, "| docs", i.documents, "| assignee", i.assignee ? "yes" : "none"); }
}
if (me?.teamId) { r = await call("rezen_team", { teamId: me.teamId }); console.log("\n== rezen_team", r.isError ? "ERROR " + r.text : `ok | ${r.json.name} | ${r.json.type} | agents ${r.json.agents.length} | roles ${r.json.agents.map((a) => a.roles.join("/")).join(",")} | ids present ${r.json.agents.filter((a) => a.agentId).length}`); }
else console.log("\n== rezen_team skipped: no teamId on me");
await client.close();
