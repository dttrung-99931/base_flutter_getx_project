# Responsive framework migration

## Description

Replace `flutter_screenutil` with `responsive_framework` for handling responsive UI across mobile, tablet, and desktop.

## Requirements

- Change `screen_util` => `responsive_framework`
- Create `AdaptiveLayout(mobile: WidgetBuilder, tablet: WidgetBuilder?, desktop: WidgetBuilder?)`
- Add responsive note in README

## Open questions (optional)

- How to replace `.sp` / `.w` / `.h` / `.r` scaling extensions currently used in dimension/font constants
- Which breakpoint source `AdaptiveLayout` should use to pick mobile/tablet/desktop
