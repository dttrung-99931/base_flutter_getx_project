import 'package:base_flutter_getx/core/constants/diemsions/dimensions.dart';
import 'package:flutter/material.dart';

import '../../../core/base/base_get_widget.dart';
import '../controllers/short_videos_controller.dart';

class ShortVideosScreen extends BaseGetWidget<ShortVideosController> {
  const ShortVideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: EdgeInsets.all(s16),
            child: Center(
              child: Text('short videos'),
            )),
      ),
    );
  }
}
