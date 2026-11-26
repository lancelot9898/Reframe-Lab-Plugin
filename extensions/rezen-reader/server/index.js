#!/usr/bin/env node
// reZEN reader: a read-only MCP server for Real's reZEN.
//
// Five tools, all GET: who am I, my open deals, one deal, its checklist, my team.
// It never creates, edits, sends or signs anything. The key comes from the
// REZEN_API_KEY environment variable, which the Claude Desktop extension fills
// from the Mac Keychain. Nothing is written to disk.
//
// Money (commission splits, payouts, gross commission) is left out of every
// answer unless a tool is asked for it, because the deal file and Claude's
// memory should never carry it.

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const HOSTS = {
  yenta: "https://yenta.therealbrokerage.com/api/v1",     // users, agents, teams
  arrakis: "https://arrakis.therealbrokerage.com/api/v1", // transactions
  sherlock: "https://sherlock.therealbrokerage.com/api/v1", // checklists
};

const KEY = process.env.REZEN_API_KEY;
const TIMEOUT_MS = 25000;

function text(obj) {
  return { content: [{ type: "text", text: typeof obj === "string" ? obj : JSON.stringify(obj, null, 2) }] };
}

function fail(msg) {
  return { content: [{ type: "text", text: msg }], isError: true };
}

async function get(host, path, params) {
  if (!KEY) throw new Error("No reZEN key. In Claude Desktop, open the reZEN reader extension and paste the key you generated in reZEN under Security Settings.");
  const url = new URL(HOSTS[host] + "/" + path.replace(/^\//, ""));
  if (params) for (const [k, v] of Object.entries(params)) if (v !== undefined && v !== null) url.searchParams.set(k, String(v));
  const ctrl = new AbortController();
  const t = setTimeout(() => ctrl.abort(), TIMEOUT_MS);
  let res;
  try {
    res = await fetch(url, { method: "GET", headers: { "X-API-KEY": KEY, Accept: "application/json" }, signal: ctrl.signal });
  } finally {
    clearTimeout(t);
  }
  if (res.status === 401 || res.status === 403) throw new Error(`reZEN refused the key (${res.status}). Generate a new key in reZEN under Security Settings and paste it into the extension.`);
  if (res.status === 404) throw new Error(`reZEN has nothing at ${path} (404).`);
  if (res.status === 429) throw new Error("reZEN is rate limiting. Wait a minute and try again.");
  if (!res.ok) throw new Error(`reZEN returned ${res.status} for ${path}.`);
  return res.json();
}

// ---------- normalizers ----------

function isoDate(ms) {
  if (!ms) return null;
  if (typeof ms === "string") return ms;
  try { return new Date(ms).toISOString().slice(0, 10); } catch { return null; }
}

function address(a) {
  if (!a) return null;
  return a.oneLine || [a.street, a.street2, a.city, a.state, a.zip].filter(Boolean).join(", ");
}

function person(p) {
  if (!p) return null;
  const name = p.fullName || [p.firstName, p.lastName].filter(Boolean).join(" ") || p.name || null;
  return {
    name,
    role: p.participantRole || p.role || null,
    company: p.company || null,
    email: p.emailAddress || p.email || null,
    phone: p.phoneNumber || p.phone || null,
    status: p.participantStatus || p.status || null,
    isRealAgent: p.realAgent === true || p.paidByReal === true || undefined,
  };
}

function lifecycle(t) {
  return {
    internal: t.lifecycleState?.state || null,
    internalNote: t.lifecycleState?.description || null,
    external: t.externalLifecycleState?.state || null,
    externalNote: t.externalLifecycleState?.description || null,
    closed: !!t.closed,
    terminated: !!t.terminated,
    verified: !!t.verified,
    complianceStatus: t.complianceStatus || null,
    compliantAt: isoDate(t.compliantAt),
  };
}

function side(t) {
  // Which side the agent's team represents, as far as the record says.
  if (t.listingSideRepresentation && !t.buySideRepresentation) return "listing";
  if (t.buySideRepresentation && !t.listingSideRepresentation) return "buyer";
  if (t.doubleSidedRepresentation || t.dualRepresentation) return "both";
  if (t.transactionOwner?.represents) return String(t.transactionOwner.represents).toLowerCase();
  return null;
}

function dates(t) {
  return {
    contractAcceptance: t.contractAcceptanceDate || null,
    firm: t.firmDate || null,
    listing: t.listingDate || null,
    listingExpiration: t.listingExpirationDate || null,
    closingEstimated: t.closingDateEstimated || t.skySlopeEscrowClosingDate || null,
    closingActual: t.closingDateActual || t.skySlopeActualClosingDate || t.rezenClosedAt && isoDate(t.rezenClosedAt) || null,
    inspectionExpiration: t.propertyInspectionExpirationDate || null,
    financingConditionsExpiration: t.financingConditionsExpirationDate || null,
    condoDocumentsExpiration: t.condoDocumentsExpirationDate || null,
    saleOfBuyersPropertyExpiration: t.saleOfBuyersPropertyExpirationDate || null,
    otherConditionsExpiration: t.otherConditionsExpirationDate || null,
  };
}

function lightTransaction(t) {
  return {
    id: t.id,
    code: t.code || null,
    address: address(t.address),
    type: t.transactionType || null,
    propertyType: t.propertyType || null,
    price: t.price?.amount ?? null,
    side: side(t),
    status: lifecycle(t),
    closingEstimated: t.closingDateEstimated || t.skySlopeEscrowClosingDate || null,
    listingDate: t.listingDate || null,
    mlsNumber: t.mlsNum || null,
    checklistId: t.checklistId || null,
    complianceStatus: t.complianceStatus || null,
    updated: isoDate(t.updatedAt),
  };
}

// Pages through a lifecycle-group feed. reZEN requires pageNumber and pageSize.
async function pageGroup(id, feed, group, maxPages = 5) {
  const rows = [];
  for (let page = 0; page < maxPages; page++) {
    const r = await get("arrakis", `transactions/participant/${id}/${feed}/${group}`, { pageNumber: page, pageSize: 50 });
    rows.push(...(r.transactions || r.results || r.content || []));
    if (!r.hasNext) break;
  }
  return rows;
}

function fullTransaction(t, includeMoney) {
  const out = {
    id: t.id,
    code: t.code || null,
    address: address(t.address),
    type: t.transactionType || null,
    propertyType: t.propertyType || null,
    yearBuilt: t.yearBuilt || null,
    mlsNumber: t.mlsNum || null,
    price: t.price?.amount ?? null,
    side: side(t),
    owner: t.transactionOwner ? { name: t.transactionOwner.name || null, represents: t.transactionOwner.represents || null } : null,
    clientName: t.clientName || null,
    status: lifecycle(t),
    dates: dates(t),
    people: (t.participants || []).map(person),
    counts: {
      participants: (t.participants || []).length,
      pendingChecklistItems: Array.isArray(t.pendingChecklistItems) ? t.pendingChecklistItems.length : (t.pendingChecklistItems ?? null),
    },
    checklistId: t.checklistId || null,
    journeyId: t.journeyId || null,
    usingRealTitle: t.usingTitle ?? null,
    warnings: (t.transactionWarnings || []).map((w) => (typeof w === "string" ? w : w?.message || w?.description || JSON.stringify(w))).slice(0, 10),
    errors: (t.errors || []).map((w) => (typeof w === "string" ? w : w?.message || w?.description || JSON.stringify(w))).slice(0, 10),
    created: isoDate(t.createdAt),
    updated: isoDate(t.updatedAt),
  };
  if (includeMoney) {
    out.money = {
      grossCommission: t.grossCommission?.amount ?? null,
      listingCommissionPercent: t.listingCommissionPercent ?? null,
      saleCommissionPercent: t.saleCommissionPercent ?? null,
      commissionSplits: (t.commissionSplits || []).map((c) => ({ name: [c.firstName, c.lastName].filter(Boolean).join(" "), percentage: c.percentage ?? null, amount: c.amount?.amount ?? c.amount ?? null })),
      paymentParticipants: (t.paymentParticipants || []).map((p) => ({ name: p.fullName || [p.firstName, p.lastName].filter(Boolean).join(" "), role: p.role, netPayout: p.netPayout?.amount ?? p.netPayout ?? null, paid: p.paid ?? null })),
    };
  }
  return out;
}

function checklistItem(i) {
  const docs = Array.isArray(i.documents) ? i.documents : [];
  return {
    id: i.id,
    name: i.name,
    status: i.status || null,           // NOT_STARTED, PENDING, ACCEPTED, REVISION_REQUESTED, ...
    complete: !!i.complete,
    skipped: !!i.skipped,
    required: !!i.required,
    urgent: !!i.urgent,
    dueDate: i.dueDate || null,
    completedAt: isoDate(i.completedAt),
    assignee: i.assignee ? (typeof i.assignee === "string" ? i.assignee : [i.assignee.firstName, i.assignee.lastName].filter(Boolean).join(" ") || i.assignee.id || null) : null,
    documents: docs.length,
    latestDocument: docs.length ? (docs[docs.length - 1]?.name || docs[docs.length - 1]?.title || null) : null,
    labels: (i.labels || []).map((l) => (typeof l === "string" ? l : l?.text || l?.name)).filter(Boolean),
    position: i.position ?? null,
  };
}

// ---------- server ----------

const server = new McpServer({ name: "rezen-reader", version: "0.1.0" });

server.registerTool(
  "rezen_me",
  {
    title: "Who am I in reZEN",
    description: "The signed-in agent's reZEN profile: name, agent id (used by the other tools), team id, office, brand, license verified. Read-only.",
    inputSchema: {},
  },
  async () => {
    try {
      const me = await get("yenta", "users/me");
      const teams = (me.teams || []).map((t) => ({ teamId: t.teamId || t.id || null, teamName: t.teamName || t.name || null, teamType: t.teamType || t.type || null, isLeader: !!t.isLeader, isAdmin: !!t.isAdmin }));
      const primary = teams.find((t) => t.isLeader) || teams[0] || null;
      const offices = (me.offices || []).map((o) => ({ officeId: o.id || o.officeId || null, officeName: o.name || o.officeName || null }));
      return text({
        agentId: me.id,
        name: me.fullName || [me.firstName, me.lastName].filter(Boolean).join(" "),
        email: me.emailAddress || null,
        brand: me.brand || null,
        type: me.type || null,
        licenseVerified: me.licenseVerified ?? null,
        teamId: primary?.teamId || null,
        teamName: primary?.teamName || null,
        teamType: primary?.teamType || null,
        isTeamLeader: primary?.isLeader ?? false,
        teams,
        offices,
        usesSkySlope: me.usesSkySlope ?? null,
      });
    } catch (e) {
      return fail(e.message);
    }
  }
);

server.registerTool(
  "rezen_transactions",
  {
    title: "My open deals in reZEN",
    description: "Every open transaction and active listing where this agent is a participant (a team leader also sees team deals). One line each: address, type, side, price, status, estimated closing. Pass the agentId from rezen_me, or leave it blank to look it up. Read-only.",
    inputSchema: {
      agentId: z.string().optional().describe("Agent id from rezen_me. Blank means the signed-in agent."),
      include: z.enum(["open", "closed", "all"]).optional().describe("open (default), closed, or all."),
    },
  },
  async ({ agentId, include }) => {
    try {
      const id = agentId || (await get("yenta", "users/me")).id;
      const which = include || "open";
      const [counts, listCounts] = await Promise.all([
        get("arrakis", `transactions/participant/${id}/transactions/lifecycle-group-counts`).catch(() => null),
        get("arrakis", `transactions/participant/${id}/listing-transactions/lifecycle-group-counts`).catch(() => null),
      ]);
      const out = {
        agentId: id,
        counts: { transactions: counts?.countsByLifecycleGroup || null, listings: listCounts?.countsByLifecycleGroup || null, drafts: counts?.draftCount ?? null },
      };
      if (which !== "closed") {
        out.open = (await pageGroup(id, "transactions", "OPEN")).map(lightTransaction);
        try {
          out.activeListings = (await pageGroup(id, "listing-transactions", "LISTING_ACTIVE")).map(lightTransaction);
        } catch (e) {
          out.activeListingsNote = "Active listings could not be read: " + e.message;
        }
      }
      if (which !== "open") {
        out.closed = (await pageGroup(id, "transactions", "CLOSED", 2)).map(lightTransaction);
      }
      return text(out);
    } catch (e) {
      return fail(e.message);
    }
  }
);

server.registerTool(
  "rezen_transaction",
  {
    title: "One deal in reZEN",
    description: "One transaction in full: address, type, side, status, every contract date (acceptance, inspection, financing, closing), the people on the file with their roles and contact details, the checklist id, warnings and errors. Money (commissions, splits, payouts) is left out unless includeMoney is true. Read-only.",
    inputSchema: {
      transactionId: z.string().describe("The transaction id from rezen_transactions."),
      includeMoney: z.boolean().optional().describe("Include commission, splits and payouts. Default false. Never store these in a deal file or memory."),
    },
  },
  async ({ transactionId, includeMoney }) => {
    try {
      const t = await get("arrakis", `transactions/${transactionId}`);
      return text(fullTransaction(t, !!includeMoney));
    } catch (e) {
      return fail(e.message);
    }
  }
);

server.registerTool(
  "rezen_checklist",
  {
    title: "A deal's checklist in reZEN",
    description: "The compliance checklist on one transaction: every item with its name, status (NOT_STARTED, PENDING, ACCEPTED and so on), whether it is required, its due date, assignee and how many documents are attached. Pass the checklistId from rezen_transaction, or the transactionId and it will be looked up. Read-only.",
    inputSchema: {
      checklistId: z.string().optional().describe("Checklist id from rezen_transaction."),
      transactionId: z.string().optional().describe("Transaction id, if you do not have the checklist id."),
      onlyOpen: z.boolean().optional().describe("Return only items that are not complete or accepted. Default false."),
    },
  },
  async ({ checklistId, transactionId, onlyOpen }) => {
    try {
      let cid = checklistId;
      if (!cid) {
        if (!transactionId) return fail("Give a checklistId or a transactionId.");
        const t = await get("arrakis", `transactions/${transactionId}`);
        cid = t.checklistId;
        if (!cid) return fail("This transaction has no checklist yet.");
      }
      const c = await get("sherlock", `checklists/${cid}`);
      let items = (c.items || []).map(checklistItem).sort((a, b) => (a.position ?? 0) - (b.position ?? 0));
      const summary = {
        checklistId: c.id,
        name: c.name || null,
        approved: c.approved ?? null,
        locked: c.locked ?? null,
        total: items.length,
        required: items.filter((i) => i.required).length,
        requiredOpen: items.filter((i) => i.required && !i.complete && i.status !== "ACCEPTED" && !i.skipped).length,
        byStatus: items.reduce((m, i) => ((m[i.status || "UNKNOWN"] = (m[i.status || "UNKNOWN"] || 0) + 1), m), {}),
      };
      if (onlyOpen) items = items.filter((i) => !i.complete && i.status !== "ACCEPTED" && !i.skipped);
      return text({ summary, items });
    } catch (e) {
      return fail(e.message);
    }
  }
);

server.registerTool(
  "rezen_team",
  {
    title: "My team in reZEN",
    description: "The agent's team: name, type, status, and the agents on it with their roles. Pass the teamId from rezen_me. Read-only.",
    inputSchema: {
      teamId: z.string().describe("Team id from rezen_me."),
    },
  },
  async ({ teamId }) => {
    try {
      const t = await get("yenta", `teams/${teamId}`);
      return text({
        id: t.id,
        name: t.name || null,
        type: t.type || null,
        status: t.status || null,
        agents: (t.agents || []).map((a) => ({
          agentId: a.agent?.id || a.agentId || a.id || null,
          name: a.agent?.fullName || [a.agent?.firstName, a.agent?.lastName].filter(Boolean).join(" ") || a.fullName || null,
          roles: a.roles || (a.role ? [a.role] : []),
        })),
      });
    } catch (e) {
      return fail(e.message);
    }
  }
);

const transport = new StdioServerTransport();
await server.connect(transport);
