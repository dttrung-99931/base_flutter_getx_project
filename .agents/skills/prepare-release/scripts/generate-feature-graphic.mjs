#!/usr/bin/env node
/**
 * Generate Play Store feature graphic (1024×500) per locale.
 *
 * Usage:
 *   node scripts/generate-feature-graphic.mjs \
 *     --config /path/to/feature-graphic-config.json \
 *     --screenshots /path/to/release/screenshots \
 *     --out /path/to/release/feature-graphic \
 *     --locale all
 *
 * Pass app_store / --store app_store → exits with message (not applicable).
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import {
  pickBrowser,
  serveStatic,
  screenshot,
  sizeForStore,
  loadTheme,
} from './lib/capture.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const SKILL_ROOT = path.resolve(__dirname, '..');
const FG_HTML_DIR = path.join(SKILL_ROOT, 'templates', 'feature-graphic');
const FONTS_DIR = path.join(SKILL_ROOT, 'templates', 'fonts');
const HTML = 'feature-graphic.html';

function parse(argv) {
  const out = {
    config: null,
    screenshots: null,
    out: null,
    locale: 'all',
    store: 'play',
    help: false,
  };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--help' || a === '-h') out.help = true;
    else if (a === 'app_store') out.store = 'app_store';
    else if (a === '--store') out.store = argv[++i];
    else if (a === '--config') out.config = path.resolve(argv[++i]);
    else if (a === '--screenshots') out.screenshots = path.resolve(argv[++i]);
    else if (a === '--out') out.out = path.resolve(argv[++i]);
    else if (a === '--locale') out.locale = argv[++i];
  }
  return out;
}

function localesFor(opt, config) {
  const available = Object.keys(config.locales || {});
  if (opt === 'all') return available;
  if (!available.includes(opt)) {
    throw new Error(`Unknown locale "${opt}". Available: ${available.join(', ')}`);
  }
  return [opt];
}

/** Flatten to opaque PNG via sips when available (Play forbids alpha). */
function flattenOpaque(pngPath) {
  const tmp = pngPath.replace(/\.png$/i, '.opaque.png');
  const r = spawnSync(
    'sips',
    ['-s', 'format', 'png', '--setProperty', 'formatOptions', 'default', pngPath, '--out', tmp],
    { encoding: 'utf8' },
  );
  // sips doesn't always strip alpha; overlay on white bg with a second pass
  const flatten = spawnSync(
    'sips',
    [
      '-s',
      'format',
      'jpeg',
      pngPath,
      '--out',
      pngPath.replace(/\.png$/i, '.tmp.jpg'),
    ],
    { encoding: 'utf8' },
  );
  const jpg = pngPath.replace(/\.png$/i, '.tmp.jpg');
  if (flatten.status === 0 && fs.existsSync(jpg)) {
    const back = spawnSync(
      'sips',
      ['-s', 'format', 'png', jpg, '--out', pngPath],
      { encoding: 'utf8' },
    );
    try {
      fs.unlinkSync(jpg);
    } catch (_) {}
    if (back.status === 0) return;
  }
  if (r.status === 0 && fs.existsSync(tmp)) {
    fs.renameSync(tmp, pngPath);
  }
}

async function main() {
  const opts = parse(process.argv.slice(2));

  if (opts.store === 'app_store') {
    console.error(
      'Feature graphic is not applicable to the App Store (Play-only, 1024×500). Stopping.',
    );
    process.exit(0);
  }

  if (opts.help || !opts.config || !opts.screenshots || !opts.out) {
    console.log(`Usage: node scripts/generate-feature-graphic.mjs \\
  --config <json> --screenshots <dir> --out <dir> [--locale all|xx]`);
    if (!opts.help) process.exit(1);
    return;
  }

  const config = JSON.parse(fs.readFileSync(opts.config, 'utf8'));
  const theme = {
    ...loadTheme(null),
    ...(config.theme || {}),
  };
  const imgBackFile = config.imgBack;
  const imgMainFile = config.imgMain;
  if (!imgBackFile || !imgMainFile) {
    throw new Error('config must set imgBack and imgMain filenames');
  }

  const locales = localesFor(opts.locale, config);
  const { width, height } = sizeForStore('play', 'featureGraphic');
  const browser = pickBrowser();

  const { server, port } = await serveStatic({
    '/fg': FG_HTML_DIR,
    '/fonts': FONTS_DIR,
    '/screenshots': opts.screenshots,
  });

  // HTML links ../fonts/fonts.css → from /fg/feature-graphic.html resolves to /fonts/
  console.log(`Config: ${opts.config}`);
  console.log(`Phones: back=${imgBackFile}, main=${imgMainFile}`);
  console.log(`Locales: ${locales.join(', ')}`);
  console.log(`Browser: ${browser}`);

  try {
    for (const locale of locales) {
      const copy = config.locales[locale];
      const srcBack = path.join(opts.screenshots, locale, imgBackFile);
      const srcMain = path.join(opts.screenshots, locale, imgMainFile);
      if (!fs.existsSync(srcBack)) {
        console.warn(`WARN: missing ${srcBack} — skip ${locale}`);
        continue;
      }
      if (!fs.existsSync(srcMain)) {
        console.warn(`WARN: missing ${srcMain} — skip ${locale}`);
        continue;
      }

      const qs = new URLSearchParams({
        lang: copy.lang || locale,
        brand: copy.brand || 'App Name',
        headline: copy.headline,
        sub: copy.sub,
        chips: (copy.chips || []).join('|'),
        imgBack: `/screenshots/${locale}/${imgBackFile}`,
        imgMain: `/screenshots/${locale}/${imgMainFile}`,
        primary: theme.primary,
        accent: theme.accent,
        textDark: theme.textDark,
        bgLight: theme.bgLight,
      }).toString();

      const url = `http://127.0.0.1:${port}/fg/${HTML}?${qs}`;
      const outPath = path.join(opts.out, locale, 'feature-graphic.png');
      const hiPath = outPath.replace(/\.png$/i, '@2x.png');

      process.stdout.write(`[${locale}] … `);
      // Capture @2x then downscale for sharper phone UI text
      await screenshot(browser, url, {
        width,
        height,
        out: hiPath,
        scale: 2,
        budgetMs: 12000,
      });

      fs.mkdirSync(path.dirname(outPath), { recursive: true });
      const resize = spawnSync(
        'sips',
        ['-z', String(height), String(width), hiPath, '--out', outPath],
        { encoding: 'utf8' },
      );
      if (resize.status !== 0) {
        fs.renameSync(hiPath, outPath);
      } else if (fs.existsSync(hiPath)) {
        fs.unlinkSync(hiPath);
      }

      flattenOpaque(outPath);
      console.log(`OK → ${outPath} (${fs.statSync(outPath).size} bytes)`);
    }
  } finally {
    server.close();
  }

  console.log('\nDone.');
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
