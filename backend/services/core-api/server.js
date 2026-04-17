const fs = require('node:fs/promises');
const http = require('node:http');
const path = require('node:path');

const HOST = process.env.HOST || '0.0.0.0';
const PORT = Number.parseInt(process.env.PORT || '8787', 10);
const DATA_DIR = path.join(__dirname, 'data');
const DATA_FILE = path.join(DATA_DIR, 'shared-state.json');

function corsHeaders() {
  return {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Content-Type': 'application/json; charset=utf-8',
  };
}

async function ensureStore() {
  await fs.mkdir(DATA_DIR, { recursive: true });
  try {
    await fs.access(DATA_FILE);
  } catch (_) {
    await writeStore({ entries: {}, updatedAt: Date.now() });
  }
}

async function readStore() {
  await ensureStore();
  try {
    const raw = await fs.readFile(DATA_FILE, 'utf8');
    const parsed = JSON.parse(raw);
    if (!parsed || typeof parsed !== 'object') {
      return { entries: {}, updatedAt: Date.now() };
    }
    if (!parsed.entries || typeof parsed.entries !== 'object') {
      parsed.entries = {};
    }
    return parsed;
  } catch (_) {
    return { entries: {}, updatedAt: Date.now() };
  }
}

async function writeStore(store) {
  await fs.mkdir(DATA_DIR, { recursive: true });
  const tempFile = `${DATA_FILE}.tmp`;
  await fs.writeFile(tempFile, JSON.stringify(store, null, 2), 'utf8');
  await fs.rename(tempFile, DATA_FILE);
}

function sendJson(res, statusCode, payload) {
  res.writeHead(statusCode, corsHeaders());
  res.end(JSON.stringify(payload));
}

async function readBody(req) {
  const chunks = [];
  for await (const chunk of req) {
    chunks.push(chunk);
  }
  const body = Buffer.concat(chunks).toString('utf8');
  if (!body.trim()) {
    return {};
  }
  return JSON.parse(body);
}

function normalizedEntry(entry) {
  if (!entry || typeof entry !== 'object') {
    return null;
  }

  const updatedAt = Number.parseInt(String(entry.updatedAt ?? '0'), 10);
  if (!Number.isFinite(updatedAt) || updatedAt <= 0) {
    return null;
  }

  if (entry.deleted === true) {
    return {
      deleted: true,
      updatedAt,
    };
  }

  const type = String(entry.type || '').trim();
  const value = entry.value;
  if (!type) {
    return null;
  }

  switch (type) {
    case 'bool':
      if (typeof value !== 'boolean') {
        return null;
      }
      break;
    case 'int':
      if (!Number.isInteger(value)) {
        return null;
      }
      break;
    case 'double':
      if (typeof value !== 'number' || Number.isNaN(value)) {
        return null;
      }
      break;
    case 'string':
      if (typeof value !== 'string') {
        return null;
      }
      break;
    case 'stringList':
      if (!Array.isArray(value) || value.some((item) => typeof item !== 'string')) {
        return null;
      }
      break;
    default:
      return null;
  }

  return {
    type,
    value,
    updatedAt,
  };
}

async function handleGetSharedState(res) {
  const store = await readStore();
  sendJson(res, 200, store);
}

async function handleMergeSharedState(req, res) {
  let body;
  try {
    body = await readBody(req);
  } catch (_) {
    sendJson(res, 400, { error: 'Invalid JSON body.' });
    return;
  }

  const entries = body && typeof body === 'object' ? body.entries : null;
  if (!entries || typeof entries !== 'object') {
    sendJson(res, 400, { error: 'Request body must include an entries object.' });
    return;
  }

  const store = await readStore();
  const mergedEntries = { ...(store.entries || {}) };
  let changed = 0;

  for (const [key, value] of Object.entries(entries)) {
    if (typeof key !== 'string' || !key.trim()) {
      continue;
    }
    const incoming = normalizedEntry(value);
    if (!incoming) {
      continue;
    }

    const existing = mergedEntries[key];
    const existingUpdatedAt = existing && typeof existing === 'object'
      ? Number.parseInt(String(existing.updatedAt ?? '0'), 10)
      : 0;
    if (!Number.isFinite(existingUpdatedAt) || incoming.updatedAt >= existingUpdatedAt) {
      mergedEntries[key] = incoming;
      changed += 1;
    }
  }

  const nextStore = {
    entries: mergedEntries,
    updatedAt: Date.now(),
  };
  await writeStore(nextStore);
  sendJson(res, 200, { ok: true, changed, updatedAt: nextStore.updatedAt });
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url || '/', `http://${req.headers.host || 'localhost'}`);

  if (req.method === 'OPTIONS') {
    res.writeHead(204, corsHeaders());
    res.end();
    return;
  }

  if (req.method === 'GET' && url.pathname === '/health') {
    sendJson(res, 200, { ok: true, service: 'learnova-core-api' });
    return;
  }

  if (req.method === 'GET' && url.pathname === '/api/shared-state') {
    await handleGetSharedState(res);
    return;
  }

  if (req.method === 'POST' && url.pathname === '/api/shared-state') {
    await handleMergeSharedState(req, res);
    return;
  }

  sendJson(res, 404, { error: 'Route not found.' });
});

ensureStore()
  .then(() => {
    server.listen(PORT, HOST, () => {
      console.log(`Learnova core API listening on http://${HOST}:${PORT}`);
    });
  })
  .catch((error) => {
    console.error('Failed to start Learnova core API.');
    console.error(error);
    process.exit(1);
  });
