#!/usr/bin/env node
/**
 * Render the 3 frame templates to PNG previews.
 *
 * Usage:
 *   node scripts/render-frames.mjs \
 *     --screenshots /path/to/release/screenshots \
 *     --sample en/02-draft-plan.png \
 *     --out /path/to/release/graphic-screenshots/frames \
 *     --theme /path/to/release/theme.json \
 *     --store play
 *
 * Also renders one long-locale sample (-vi) when a vi/ sample exists or
 * --title-vi / --subtitle-vi are passed.
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

const FRAMES = [
  'frame-a-gradient.html',
  'frame-b-clean-light.html',
  'frame-c-dark.html',
];

function parse(argv) {
  const out = {
    screenshots: null,
    sample: null,
    out: null,
    theme: null,
    store: 'play',
    title: 'Your headline',
    subtitle: 'Short supporting line',
    titleVi: 'Tiêu đề dài hơn để kiểm tra xuống dòng',
    subtitleVi: 'Dòng phụ dài hơn — kiểm tra wrap và không bị cắt chữ',
    help: false,
  };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--help' || a === '-h') out.help = true;
    else if (a === 'app_store' || a === '--store' && argv[i + 1] === 'app_store') {
      out.store = 'app_store';
      if (a === '--store') i++;
    } else if (a === '--store') out.store = argv[++i];
    else if (a === '--screenshots') out.screenshots = path.resolve(argv[++i]);
    else if (a === '--sample') out.sample = argv[++i];
    else if (a === '--out') out.out = path.resolve(argv[++i]);
    else if (a === '--theme') out.theme = path.resolve(argv[++i]);
    else if (a === '--title') out.title = argv[++i];
    else if (a === '--subtitle') out.subtitle = argv[++i];
    else if (a === '--title-vi') out.titleVi = argv[++i];
    else if (a === '--subtitle-vi') out.subtitleVi = argv[++i];
  }
  return out;
}

function themeQs(theme) {
  return {
    primary: theme.primary,
    accent: theme.accent,
    textDark: theme.textDark,
    bgLight: theme.bgLight,
  };
}

async function main() {
  const opts = parse(process.argv.slice(2));
  if (opts.help || !opts.screenshots || !opts.sample || !opts.out) {
    console.log(`Usage: node scripts/render-frames.mjs \\
  --screenshots <dir> --sample <locale/file.png> --out <dir> \\
  [--theme <theme.json>] [--store play|app_store]`);
    if (!opts.help && (!opts.screenshots || !opts.sample || !opts.out)) {
      process.exit(1);
    }
    return;
  }

  const { width, height } = sizeForStore(opts.store, 'phone');
  const theme = loadTheme(opts.theme);
  const browser = pickBrowser();

  // sample is relative to screenshots root, e.g. en/01-create-goal.png
  const sampleRel = opts.sample.replace(/^\/+/, '');
  const sampleAbs = path.join(opts.screenshots, sampleRel);
  if (!fs.existsSync(sampleAbs)) {
    throw new Error(`Sample screenshot not found: ${sampleAbs}`);
  }

  const { server, port } = await serveStatic({
    '/frames': FRAMES_DIR,
    '/fonts': FONTS_DIR,
    '/screenshots': opts.screenshots,
  });

  // HTML references ../fonts/fonts.css → served as /fonts via rewrite:
  // frames HTML uses href="../fonts/fonts.css" which from /frames/foo.html
  // resolves to /fonts/fonts.css — good.

  const imgUrl = `/screenshots/${sampleRel.split(path.sep).join('/')}`;
  fs.mkdirSync(opts.out, { recursive: true });

  console.log(`Store: ${opts.store} (${width}x${height})`);
  console.log(`Browser: ${browser}`);
  console.log(`Sample: ${sampleAbs}`);

  const baseParams = {
    img: imgUrl,
    ...themeQs(theme),
    w: String(width),
    h: String(height),
  };

  try {
    for (const frame of FRAMES) {
      const qs = new URLSearchParams({
        ...baseParams,
        title: opts.title,
        subtitle: opts.subtitle,
      }).toString();
      const url = `http://127.0.0.1:${port}/frames/${frame}?${qs}`;
      const outPath = path.join(opts.out, frame.replace(/\.html$/, '.png'));
      process.stdout.write(`Rendering ${frame} … `);
      await screenshot(browser, url, { width, height, out: outPath });
      console.log(`OK (${fs.statSync(outPath).size} bytes)`);
    }

    // Long-locale sample on frame B (wrap / overflow check)
    const qsVi = new URLSearchParams({
      ...baseParams,
      title: opts.titleVi,
      subtitle: opts.subtitleVi,
    }).toString();
    const viOut = path.join(opts.out, 'frame-b-clean-light-long-locale.png');
    process.stdout.write('Rendering long-locale sample (frame B) … ');
    await screenshot(browser, `http://127.0.0.1:${port}/frames/frame-b-clean-light.html?${qsVi}`, {
      width,
      height,
      out: viOut,
    });
    console.log(`OK (${fs.statSync(viOut).size} bytes)`);
  } finally {
    server.close();
  }

  console.log(`\nPreviews → ${opts.out}`);
  console.log('STOP: ask the user to pick frame A, B, or C before generate-graphics.');
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
