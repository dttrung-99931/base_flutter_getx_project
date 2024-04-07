
import 'package:base_flutter_getx/core/constants/diemsions/dimensions.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: s24,
      height: s24,
      padding: EdgeInsets.all(s4),
      child: const CircularProgressIndicator(
        backgroundColor: Colors.white,
        strokeWidth: 2,
      ),
    );
  }
}
