import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Picks a layout builder by the active [ResponsiveBreakpoints] value.
///
/// Fallback cascade: desktop → tablet → mobile.
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    final breakpoints = ResponsiveBreakpoints.of(context);

    if (breakpoints.isDesktop) {
      return (desktop ?? tablet ?? mobile)(context);
    }
    if (breakpoints.isTablet) {
      return (tablet ?? mobile)(context);
    }
    return mobile(context);
  }
}
