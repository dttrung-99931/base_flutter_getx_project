# Store screenshot & graphic specs

Used by `prepare_release` scripts via `--store play|app_store`.

## Google Play (default)

| Asset | Size | Notes |
|-------|------|-------|
| Phone screenshots | **1080 × 1920** (9:16) | 2–8 per locale recommended |
| Feature graphic | **1024 × 500** | JPG or 24-bit PNG **without alpha** |

## App Store

| Asset | Size | Notes |
|-------|------|-------|
| iPhone 6.9" (default) | **1320 × 2868** | Preferred for `--store app_store` |
| iPhone 6.7" (alt) | **1290 × 2796** | Documented alternative; scripts use 6.9" |
| Feature graphic | — | **Not applicable** — App Store has none |

Up to 10 screenshots per locale.

## Caption length guidance

Keep store overlay text short so long locales (VI, DE, …) still fit:

- **Title:** ≤ ~28 characters
- **Subtitle:** ≤ ~40 characters

Prefer punchy marketing lines over full sentences.
