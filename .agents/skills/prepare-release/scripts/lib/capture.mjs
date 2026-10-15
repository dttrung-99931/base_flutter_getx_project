/**
 * Shared headless capture helpers for prepare-release scripts.
 * No npm deps — Node 18+ built-ins only.
 */
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';

export const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.ttf': 'font/ttf',
  '.woff2': 'font/woff2',
  '.svg': 'image/svg+xml',
  '.json': 'application/json',
};

/** Play / App Store canvas sizes. */
export const STORE_SIZES = {
  play: {
    phone: { width: 1080, height: 1920 },
    featureGraphic: { width: 1024, height: 500 },
  },
  app_store: {
    // iPhone 6.9" portrait (default). Alt 6.7": 1290×2796 — see store-specs.md
    phone: { width: 1320, height: 2868 },
    featureGraphic: null,
  },
};

/**
 * @param {'play'|'app_store'} store
 * @param {'phone'|'featureGraphic'} kind
 * @returns {{width: number, height: number}}
 */
export function sizeForStore(store, kind) {
  const key = store === 'app_store' ? 'app_store' : 'play';
  const sizes = STORE_SIZES[key];
  const size = sizes[kind];
  if (!size) {
    throw new Error(
      `Store "${key}" has no size for "${kind}" (App Store has no feature graphic).`,
    );
  }
  return size;
}

/**
 * @param {string[]} argv
 * @param {Record<string, string|boolean|null>} defaults
 * @param {string[]} [flagsWithValue]
 */
export function parseArgs(argv, defaults = {}, flagsWithValue = []) {
  const out = { ...defaults };
  const valueFlags = new Set(flagsWithValue);
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--help' || a === '-h') {
      out.help = true;
      continue;
    }
    if (a === 'app_store') {
      out.store = 'app_store';
      continue;
    }
    if (a.startsWith('--')) {
      const key = a.slice(2).replace(/-([a-z])/g, (_, c) => c.toUpperCase());
      if (valueFlags.has(a) || valueFlags.has(key) || i + 1 < argv.length) {
        const next = argv[i + 1];
        if (next !== undefined && !next.startsWith('--') && next !== 'app_store') {
          out[key] = next;
          i++;
          continue;
        }
      }
      out[key] = true;
      continue;
    }
    if (!out._positional) out._positional = [];
    out._positional.push(a);
  }
  return out;
}

const BROWSER_CANDIDATES = [
  process.env.BROWSER_PATH,
  process.env.BRAVE_PATH,
  '/Applications/Brave Browser.app/Contents/MacOS/Brave Browser',
  '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
  '/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge',
  '/Applications/Chromium.app/Contents/MacOS/Chromium',
  'google-chrome',
  'chromium',
  'chromium-browser',
  'brave-browser',
  'microsoft-edge',
].filter(Boolean);

/** Pick first existing Chromium-family browser. */
export function pickBrowser() {
  for (const candidate of BROWSER_CANDIDATES) {
    if (candidate.includes('/') || candidate.startsWith('.')) {
      if (fs.existsSync(candidate)) return candidate;
    } else {
      // Bare command name — try `which` via common bin paths
      for (const bin of ['/usr/bin', '/usr/local/bin', '/opt/homebrew/bin']) {
        const p = path.join(bin, candidate);
        if (fs.existsSync(p)) return p;
      }
    }
  }
  throw new Error(
    'No Chromium browser found. Install Brave/Chrome/Edge or set BROWSER_PATH.',
  );
}

/**
 * Serve one or more roots. Path prefix maps to a root directory.
 * @param {Record<string, string>|string} roots
 *   string → single root at `/`
 *   map e.g. { '/frames': framesDir, '/screenshots': shotsDir, '/fonts': fontsDir }
 */
export function serveStatic(roots) {
  const map =
    typeof roots === 'string'
      ? { '/': path.resolve(roots) }
      : Object.fromEntries(
          Object.entries(roots).map(([k, v]) => [
            k.endsWith('/') ? k.slice(0, -1) || '/' : k,
            path.resolve(v),
          ]),
        );

  return new Promise((resolve) => {
    const server = http.createServer((req, res) => {
      const url = new URL(req.url || '/', 'http://127.0.0.1');
      let rel = decodeURIComponent(url.pathname);

      // Longest-prefix match
      const prefixes = Object.keys(map).sort((a, b) => b.length - a.length);
      let root = null;
      let rest = rel;
      for (const prefix of prefixes) {
        if (prefix === '/') continue;
        if (rel === prefix || rel.startsWith(prefix + '/')) {
          root = map[prefix];
          rest = rel.slice(prefix.length) || '/';
          break;
        }
      }
      if (!root) {
        root = map['/'];
        rest = rel;
      }
      if (!root) {
        res.writeHead(404);
        res.end('No root');
        return;
      }

      const filePath = path.normalize(path.join(root, rest));
      if (!filePath.startsWith(root)) {
        res.writeHead(403);
        res.end('Forbidden');
        return;
      }
      fs.readFile(filePath, (err, data) => {
        if (err) {
          res.writeHead(404);
          res.end(`Not found: ${rel}`);
          return;
        }
        const ext = path.extname(filePath).toLowerCase();
        res.writeHead(200, {
          'Content-Type': MIME[ext] || 'application/octet-stream',
          'Cache-Control': 'no-store',
        });
        res.end(data);
      });
    });
    server.listen(0, '127.0.0.1', () => {
      resolve({ server, port: server.address().port });
    });
  });
}

/**
 * Headless screenshot via Chromium.
 * @param {string} browser
 * @param {string} url
 * @param {{width: number, height: number, out: string, scale?: number, budgetMs?: number}} opts
 */
export function screenshot(browser, url, opts) {
  const {
    width,
    height,
    out,
    scale = 1,
    budgetMs = 8000,
  } = opts;
  return new Promise((resolve, reject) => {
    fs.mkdirSync(path.dirname(out), { recursive: true });
    const args = [
      '--headless=new',
      '--disable-gpu',
      '--hide-scrollbars',
      `--force-device-scale-factor=${scale}`,
      `--window-size=${width},${height}`,
      '--default-background-color=00000000',
      `--virtual-time-budget=${budgetMs}`,
      '--run-all-compositor-stages-before-draw',
      `--screenshot=${out}`,
      url,
    ];
    const child = spawn(browser, args, { stdio: ['ignore', 'pipe', 'pipe'] });
    let stderr = '';
    child.stderr.on('data', (d) => {
      stderr += d.toString();
    });
    child.on('error', reject);
    child.on('close', (code) => {
      if (code !== 0 && !fs.existsSync(out)) {
        reject(new Error(`Browser exit ${code}\n${stderr}`));
        return;
      }
      resolve();
    });
  });
}

/** Load theme JSON; return CSS-friendly color map with defaults. */
export function loadTheme(themePath) {
  const defaults = {
    primary: '#7C3AED',
    accent: '#6366F1',
    textDark: '#0F172A',
    bgLight: '#F8FAFC',
  };
  if (!themePath || !fs.existsSync(themePath)) return defaults;
  try {
    return { ...defaults, ...JSON.parse(fs.readFileSync(themePath, 'utf8')) };
  } catch {
    return defaults;
  }
}
