import 'dart:async';

import 'package:base_flutter_getx/core/error/app_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  Future<void> showSnackbar(String msg)  async {
    await Get.snackbar(msg, msg,  colorText: Colors.black,).future;
  }

  Future<void> handleServiceResult<Model>({
    required Future<Either<AppError, Model>> serviceResult,
    required Function(Model result) onSuccess,
    Function(AppError result)? onError,
    bool handleLoading = true,
  }) async {
    isLoading = true;
    Either<AppError, Model> result = await serviceResult;
    result.fold(
      onError ?? onErrorDefault,
      (Model data) => onSuccess(data),
    );
    isLoading = false;
  }

  void onErrorDefault(AppError appError) {
    showSnackbar(appError.message);
  }

  @override
  void dispose() {
    for (StreamSubscription element in _subscriptions) {
      element.cancel();
    }
    super.dispose();
  }
}
