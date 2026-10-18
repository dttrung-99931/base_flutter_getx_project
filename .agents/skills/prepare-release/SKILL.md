---
name: prepare-release
description: >
  Prepare store release assets when the user invokes prepare_release (or
  prepare-release). With no option, show a brief guideline only. Options:
  gen_screenshots_plan, gen_screenshot_graphic_frames, gen_feature_graphic.
  Google Play sizes by default; pass app_store for App Store screenshot sizes.
  Bundled HTML/MJS scripts live under this skill — run them; do not regenerate.
disable-model-invocation: true
---

# Prepare release

Portable skill for store screenshot and graphic assets. Invoke as
`prepare_release <option> [args]`.

**Default store:** Google Play. Add `app_store` anywhere in the args to use
App Store phone sizes (see [reference/store-specs.md](reference/store-specs.md)).

## No option — guideline only

When the user invokes `prepare_release` with **no option**, print this guideline
and stop. Do not create files or run scripts.

```
prepare_release <option> [args]

Options:
  gen_screenshots_plan [output-folder]
      Write a plan to capture feature screenshots (realistic seed data +
      integration seed + flutter screenshot). Default output: release/screenshots

  gen_screenshot_graphic_frames [app_store]
      Render 3 graphic frame previews, then STOP and ask which frame to use.
      Only after the user explicitly picks a frame, generate framed screenshots
      for each locale. Default: release/graphic-screenshots/

  gen_feature_graphic [app_store]
      Generate 1024×500 Play Store feature graphic(s) per locale.
      Default: release/feature-graphic/{locale}/
      With app_store: not applicable (App Store has no feature graphic) — stop.

Store: Google Play by default. Pass app_store for App Store screenshot sizes.

Prerequisites: Node 18+, a Chromium browser (Brave / Chrome / Edge, or
BROWSER_PATH). Scripts: scripts/*.mjs under this skill folder.
```

## Prerequisites

- Node 18+
- Chromium browser: Brave → Chrome → Edge, or set `BROWSER_PATH` / `BRAVE_PATH`
- Raw screenshots already present under `{project}/release/screenshots/{locale}/`
  (or a custom folder) before running graphic options

## Default output layout (project root)

| Path | Contents |
|------|----------|
| `release/screenshots/{locale}/` | Raw phone screenshots |
| `release/graphic-screenshots/frames/` | Frame preview PNGs |
| `release/graphic-screenshots/{locale}/` | Framed store screenshots |
| `release/feature-graphic/{locale}/` | Feature graphic PNGs |
| `release/theme.json` | Brand colors for templates |
| `release/captions.json` | Titles/subtitles per shot × locale |
| `release/feature-graphic-config.json` | Feature graphic copy + phone shots |

Every script accepts flags to override these paths.

## Option: `gen_screenshots_plan [output-folder]`

Write a **screenshot plan only**. Do not capture until the user asks to implement.

1. Explore the app (routes, screens, main user journeys).
2. Write `.cursor/plans/release-screenshots.plan.md` using
   [reference/screenshots-plan-template.md](reference/screenshots-plan-template.md).
3. Include: feature list, ordered journey beats, realistic demo seed table,
   capture method (integration seed + `flutter screenshot`; iOS simulator when
   `app_store`), naming `NN-feature-name.png`, locale folders, overflow check.
4. Output folder: first non-flag arg, or default `release/screenshots`.
5. Put that folder path clearly in the plan.

### Capture with `flutter screenshot` (when implementing a plan)

Do **not** use Mobile MCP to capture store screenshots. Prefer the Flutter CLI:

```bash
# App must already be running on the target device (e.g. flutter run …)
flutter screenshot -d <device-id> -o <output>/{locale}/NN-feature-name.png
```

- Default `--type=device` captures the full device frame (status bar included) —
  preferred for store listings.
- Use `-d` for the emulator/simulator id; for App Store, target an iOS simulator.
- Repeat per beat × locale after the seed harness lands each UI state.

## Option: `gen_screenshot_graphic_frames [app_store]`

### Phase A — frame previews (always)

1. Read app brand colors (e.g. `lib/core/constants/colors.dart`) → write
   `release/theme.json` (schema: [templates/theme.example.json](templates/theme.example.json)).
2. Draft / update `release/captions.json` from the screenshot plan
   (schema: [templates/captions.example.json](templates/captions.example.json)).
3. Ensure raw screenshots exist under `--screenshots` (default
   `release/screenshots`).
4. Run from this skill folder:

```bash
node scripts/render-frames.mjs \
  --screenshots <project>/release/screenshots \
  --sample <relative-png-under-locale> \
  --out <project>/release/graphic-screenshots/frames \
  --theme <project>/release/theme.json \
  --store play|app_store
```

5. Present the 3 preview PNGs to the user.
6. **STOP.** Ask which frame to use (A / B / C, or a filename). Do **not** run
   `generate-graphics.mjs` yet.

### Frame gate (mandatory)

- **Never** run `scripts/generate-graphics.mjs` until the user **explicitly
  names** a frame (A/B/C or `frame-*.html`).
- If the user says "adjust", edit the template/theme and re-run
  `render-frames.mjs` only — still wait for an explicit pick.

### Phase B — framed screenshots (after pick only)

```bash
node scripts/generate-graphics.mjs \
  --frame frame-b-clean-light.html \
  --captions <project>/release/captions.json \
  --screenshots <project>/release/screenshots \
  --out <project>/release/graphic-screenshots \
  --locale all \
  --store play|app_store
```

Frame name map: A → `frame-a-gradient.html`, B → `frame-b-clean-light.html`,
C → `frame-c-dark.html`.

Missing source PNGs: warn and continue (do not abort the whole run).

## Option: `gen_feature_graphic [app_store]`

1. If `app_store` is present: explain that the App Store has **no** feature
   graphic, and **stop**. Do not write files.
2. Write / update `release/feature-graphic-config.json`
   (schema: [templates/feature-graphic-config.example.json](templates/feature-graphic-config.example.json)).
3. Run:

```bash
node scripts/generate-feature-graphic.mjs \
  --config <project>/release/feature-graphic-config.json \
  --screenshots <project>/release/screenshots \
  --out <project>/release/feature-graphic \
  --locale all
```

4. Output: `release/feature-graphic/{locale}/feature-graphic.png` at 1024×500,
   opaque (no alpha).

## Scripts (do not regenerate)

| Script | Role |
|--------|------|
| `scripts/lib/capture.mjs` | Shared browser + static server + store sizes |
| `scripts/render-frames.mjs` | 3 frame previews |
| `scripts/generate-graphics.mjs` | Chosen frame × captions × locales |
| `scripts/generate-feature-graphic.mjs` | 1024×500 feature graphic |

Templates: `templates/frames/`, `templates/fonts/`, `templates/feature-graphic/`.

## Anti-patterns

- Do not invent new HTML/MJS scripts when these exist
- Do not skip the frame-choice gate
- Do not hardcode one project's brand name or screenshot paths into templates
- Do not claim App Store support for the feature graphic
