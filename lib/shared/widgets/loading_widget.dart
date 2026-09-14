import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(4),
      child: const CircularProgressIndicator(
        backgroundColor: Colors.white,
        strokeWidth: 2,
      ),
    );
  }
}
