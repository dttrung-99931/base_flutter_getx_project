#!/usr/bin/env node
/**
 * Generate framed store screenshots from a chosen frame + captions.json.
 *
 * Usage:
 *   node scripts/generate-graphics.mjs \
 *     --frame frame-b-clean-light.html \
 *     --captions /path/to/captions.json \
 *     --screenshots /path/to/release/screenshots \
 *     --out /path/to/release/graphic-screenshots \
 *     --locale all \
 *     --store play
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import {
  pickBrowser,
  serveStatic,
  screenshot,
  sizeForStore,
  loadTheme,
} from './lib/capture.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const SKILL_ROOT = path.resolve(__dirname, '..');
const FRAMES_DIR = path.join(SKILL_ROOT, 'templates', 'frames');
const FONTS_DIR = path.join(SKILL_ROOT, 'templates', 'fonts');

const FRAME_ALIASES = {
  a: 'frame-a-gradient.html',
  b: 'frame-b-clean-light.html',
  c: 'frame-c-dark.html',
  A: 'frame-a-gradient.html',
  B: 'frame-b-clean-light.html',
  C: 'frame-c-dark.html',
};

function parse(argv) {
  const out = {
    frame: null,
    captions: null,
    screenshots: null,
    out: null,
    theme: null,
    locale: 'all',
    only: null,
    store: 'play',
    help: false,
  };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--help' || a === '-h') out.help = true;
    else if (a === 'app_store') out.store = 'app_store';
    else if (a === '--store') out.store = argv[++i];
    else if (a === '--frame') out.frame = argv[++i];
    else if (a === '--captions') out.captions = path.resolve(argv[++i]);
    else if (a === '--screenshots') out.screenshots = path.resolve(argv[++i]);
    else if (a === '--out') out.out = path.resolve(argv[++i]);
    else if (a === '--theme') out.theme = path.resolve(argv[++i]);
    else if (a === '--locale') out.locale = argv[++i];
    else if (a === '--only') out.only = argv[++i];
  }
  return out;
}

function resolveFrame(name, captionsFrame) {
  const raw = name || captionsFrame;
  if (!raw) throw new Error('Pass --frame or set captions.frame');
  if (FRAME_ALIASES[raw]) return FRAME_ALIASES[raw];
  if (raw.endsWith('.html')) return raw;
  return `${raw}.html`;
}

function localesFor(opt, shots) {
  if (opt !== 'all') return [opt];
  const set = new Set();
  for (const shot of shots) {
    for (const key of Object.keys(shot)) {
      if (key === 'file') continue;
      if (shot[key]?.title) set.add(key);
    }
  }
  return [...set];
}

async function main() {
  const opts = parse(process.argv.slice(2));
  if (
    opts.help ||
    !opts.captions ||
    !opts.screenshots ||
    !opts.out
  ) {
    console.log(`Usage: node scripts/generate-graphics.mjs \\
  --frame <A|B|C|file.html> --captions <json> --screenshots <dir> --out <dir> \\
  [--locale all|xx] [--only file.png] [--theme theme.json] [--store play|app_store]`);
    if (!opts.help) process.exit(1);
    return;
  }

  const captions = JSON.parse(fs.readFileSync(opts.captions, 'utf8'));
  if (!Array.isArray(captions.shots) || captions.shots.length === 0) {
    throw new Error(`No shots in ${opts.captions}`);
  }

  const frame = resolveFrame(opts.frame, captions.frame);
  const framePath = path.join(FRAMES_DIR, frame);
  if (!fs.existsSync(framePath)) {
    throw new Error(`Frame not found: ${framePath}`);
  }

  let shots = captions.shots;
  if (opts.only) {
    shots = shots.filter((s) => s.file === opts.only);
    if (shots.length === 0) {
      throw new Error(`No caption entry for --only ${opts.only}`);
    }
  }

  const locales = localesFor(opts.locale, captions.shots);
  const { width, height } = sizeForStore(opts.store, 'phone');
  const theme = loadTheme(opts.theme);
  const browser = pickBrowser();

  const { server, port } = await serveStatic({
    '/frames': FRAMES_DIR,
    '/fonts': FONTS_DIR,
    '/screenshots': opts.screenshots,
  });

  console.log(`Frame: ${frame}`);
  console.log(`Store: ${opts.store} (${width}x${height})`);
  console.log(`Locales: ${locales.join(', ')} (${shots.length} shots)`);
  console.log(`Browser: ${browser}`);

  let ok = 0;
  let skipped = 0;
  try {
    for (const locale of locales) {
      for (const shot of shots) {
        const copy = shot[locale];
        if (!copy?.title || !copy?.subtitle) {
          console.warn(`WARN: missing ${locale} title/subtitle for ${shot.file} — skip`);
          skipped += 1;
          continue;
        }
        const src = path.join(opts.screenshots, locale, shot.file);
        if (!fs.existsSync(src)) {
          console.warn(`WARN: missing source ${src} — skip`);
          skipped += 1;
          continue;
        }

        const qs = new URLSearchParams({
          img: `/screenshots/${locale}/${shot.file}`,
          title: copy.title,
          subtitle: copy.subtitle,
          primary: theme.primary,
          accent: theme.accent,
          textDark: theme.textDark,
          bgLight: theme.bgLight,
          w: String(width),
          h: String(height),
        }).toString();
        const url = `http://127.0.0.1:${port}/frames/${frame}?${qs}`;
        const outPath = path.join(opts.out, locale, shot.file);

        process.stdout.write(`[${locale}] ${shot.file} … `);
        await screenshot(browser, url, { width, height, out: outPath });
        console.log(`OK (${fs.statSync(outPath).size} bytes)`);
        ok += 1;
      }
    }
  } finally {
    server.close();
  }

  console.log(`\nDone: ${ok} graphics, ${skipped} skipped → ${opts.out}/{locale}/`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
