
import 'package:base_flutter_getx/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.s24,
      height: Sizes.s24,
      padding: const EdgeInsets.all(Sizes.s4),
      child: const CircularProgressIndicator(
        backgroundColor: Colors.white,
        strokeWidth: 2,
      ),
    );
  }
}
