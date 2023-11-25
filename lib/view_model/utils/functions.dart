import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:note_application/view_model/utils/app_colors.dart';

class Functions {
  static void showErrorToast(
      {required String msg, required BuildContext context, int? milliseconds}) {
    return CherryToast.error(
      title: Text(msg, style: const TextStyle(color: AppColors.black)),
      animationType: AnimationType.fromTop,
      enableIconAnimation: true,
      animationDuration: Duration(milliseconds: milliseconds ?? 1000),
      toastDuration: const Duration(seconds: 3),
      autoDismiss: true,
      actionHandler: FlutterError.onError,
    ).show(context);
  }

  static void showSuccessToast(
      {required BuildContext context, required String msg, Color? color}) {
    return CherryToast.success(
            title: Text(msg, style: TextStyle(color: color ?? AppColors.black)))
        .show(context);
  }
}
