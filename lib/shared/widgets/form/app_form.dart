import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppForm extends StatefulWidget {
  const AppForm({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AppForm> createState() => AppFormState();
}

class AppFormState extends State<AppForm> {
  final formKey = GlobalKey<ShadFormState>();

  bool saveAndValidate() {
    return formKey.currentState?.saveAndValidate() ?? false;
  }

  Map<Object, dynamic> get value {
    return formKey.currentState?.value ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return ShadForm(
      key: formKey,
      child: widget.child,
    );
  }
}
