# Agent experience (brief)

Notes from past corrections — each is a reusable lesson, not a changelog.
Add one only if it would likely prevent the same mistake again. Keep it to one or two lines: a short general rule, then a concrete "Ex:" that makes the rule obvious. Write it so an agent with no context of this project still understands it.

- Changing one behavior can silently break another path when both share code — before editing a shared function/handler, list every caller and confirm the change is correct for each; if not, scope it to the one path. Ex: added “clear the form” to a shared save(); the Submit button now works, but the Save Draft button reuses save() and wipes the form while the user is still editing.
