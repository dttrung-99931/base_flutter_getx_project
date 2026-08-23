import 'package:base_flutter_getx/core/constants/themes.dart';
import 'package:base_flutter_getx/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
    this.isLoading = false,
    this.width,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool enabled;
  final bool isLoading;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      width: width,
      enabled: enabled && !isLoading,
      onPressed: onPressed,
      leading: isLoading ? const LoadingWidget() : null,
      textStyle: textTheme.bodySmall,
      child: child,
    );
  }
}
