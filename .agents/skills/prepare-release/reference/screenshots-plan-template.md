# Release screenshots plan (template)

Copy this structure into `{project}/.cursor/plans/release-screenshots.plan.md`.
Fill every section from the **current app** — do not keep sample product names.

## Scope

- **Store:** Google Play (default) / App Store (`app_store`)
- **Device:** Phone portrait (Play: Android emulator; App Store: iOS simulator)
- **Output folder:** `release/screenshots` (or user-provided path)
- **Locales:** list languages to capture (e.g. `en`, `vi`)

## Feature list

Explore routes / screens / main journeys. List each feature that should appear
in a store screenshot:

1. …
2. …

## Journey beats (ordered)

Numbered capture sequence. Example shape (replace with this app’s flow):

1. `01-…` — entry / create core entity
2. `02-…` — plan / edit
3. `03-…` — calendar / schedule
4. `04-…` — active / doing state
5. `05-…` — settings / reminders (if any)
6. `06-…` — complete / celebrate

## Demo seed data

Realistic, easy-to-understand example content per beat. Prefer short labels.

| Beat / screen | Seed data |
|---------------|-----------|
| … | … |

Use nested / multi-item data when the UI needs it (not empty or single-row only).

## Capture method

1. Integration seed harness (or debug host) that lands the UI on each beat
2. Mobile MCP (or iOS simulator tooling for `app_store`) to take the screenshot
3. Save as `{output}/{locale}/NN-feature-name.png`

Do **not** implement capture until the user asks.

## Naming & folders

```
{output}/
  en/
    01-….png
    02-….png
  vi/
    …
```

## Overflow check

Captured UI must not show yellow/black overflow stripes on critical labels.
Re-capture after fixing layout if needed.

## Out of scope (default)

- Store listing copy / descriptions
- Feature graphic / framed graphics (other skill options)
- Upload to Play Console / App Store Connect
