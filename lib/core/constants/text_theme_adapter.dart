import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TextThemeAdapter extends TextTheme {
  final ShadTextTheme shadcnTheme;

  TextThemeAdapter(this.shadcnTheme)
      : super(
          displayLarge: shadcnTheme.h1Large,
          displayMedium: shadcnTheme.h1,
          displaySmall: shadcnTheme.h2,
          headlineLarge: shadcnTheme.h1,
          headlineMedium: shadcnTheme.h2,
          headlineSmall: shadcnTheme.h3,
          titleLarge: shadcnTheme.h1,
          titleMedium: shadcnTheme.h2,
          titleSmall: shadcnTheme.h3,
          bodyLarge: shadcnTheme.h4,
          bodyMedium: shadcnTheme.p,
          bodySmall: shadcnTheme.small,
          labelLarge: shadcnTheme.small.copyWith(fontWeight: FontWeight.w600),
          labelMedium: shadcnTheme.muted.copyWith(fontWeight: FontWeight.w600),
          labelSmall: (shadcnTheme.custom['labelSmall'] ?? shadcnTheme.muted)
              .copyWith(fontWeight: FontWeight.w600),
        );
}
