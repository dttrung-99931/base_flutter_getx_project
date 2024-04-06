import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class BaseController extends GetxController {
  final _isLoading = false.obs;
  final _subscriptions = List<StreamSubscription>.empty(growable: true);

  bool get isLoading => _isLoading.value;
  @protected
  set isLoading(bool value) => _isLoading.value = value;

  /// Generic function for listening change of a obversable variable 
  /// and keep the subscription of listening to cancel when controller disposed
  void listen<T>(RxNotifier<T> notifier, Function(T) onChanged) {
    _subscriptions.add(notifier.listen(onChanged));
  }

  @override
  void dispose() {
    _subscriptions.forEach((element) => element.cancel());
    super.dispose();
  }

  Future<void> load(Function load) async {
    isLoading = true;
    await load();
    isLoading = false;
  }

  Future<void> showSnackbar(String msg) {
    return Get.snackbar('', msg).show();
  }
}
