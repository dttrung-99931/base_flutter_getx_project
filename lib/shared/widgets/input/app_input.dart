import 'package:base_flutter_getx/core/constants/colors.dart';
import 'package:base_flutter_getx/core/constants/themes.dart';
import 'package:base_flutter_getx/core/utils/extension/ui_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppInput extends StatefulWidget {
  const AppInput({
    super.key,
    required this.id,
    this.label,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.leadingIcon,
    this.isPassword = false,
    this.validator,
  });

  final String id;
  final String? label;
  final String? placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? leadingIcon;
  final bool isPassword;
  final String? Function(String)? validator;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool obscureText = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        if (widget.label != null)
          // Replace for ShadInputFormField.label to fix ShadInputFormField.label
          // always turn red when error
          Text(
            widget.label!,
            style: textTheme.labelMedium.withWeight(FontWeight.w500),
          ),
        ShadInputFormField(
          id: widget.id,
          placeholder:
              widget.placeholder != null ? Text(widget.placeholder!) : null,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: obscureText,
          leading: widget.leadingIcon != null ? Icon(widget.leadingIcon) : null,
          trailing: widget.isPassword ? _passwordToggle() : null,
          validator: widget.validator,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          decoration: ShadDecoration(
            border: ShadBorder.all(
              color: AppColors.border,
              width: 1.r,
              radius: BorderRadius.circular(8.r),
            ),
            secondaryFocusedBorder: ShadBorder.all(
              // Hide secondary border when focused
              width: 0,
            ),
            focusedBorder: ShadBorder.all(
              width: 1.5.r,
              color: AppColors.primary,
              radius: BorderRadius.circular(8.r),
            ),
            fallbackToLabelStyle: true,
          ),
        ),
      ],
    );
  }

  Widget _passwordToggle() {
    return SizedBox.square(
      dimension: 24,
      child: OverflowBox(
        maxWidth: 28,
        maxHeight: 28,
        child: ShadIconButton(
          backgroundColor: AppColors.background,
          iconSize: 20,
          padding: const EdgeInsets.all(2),
          icon: Icon(
            obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
            color: AppColors.primary,
          ),
          onPressed: () {
            setState(() => obscureText = !obscureText);
          },
        ),
      ),
    );
  }
}
