import 'package:get/get.dart';
import 'package:flutter/material.dart';

Future<T?> showConfirmDialog<T>({
  String? title = "提示",
  Widget? titleWeight,
  String? contentText = "提示内容",
  Widget? contentWeight,
  String textConfirm = "确定",
  String textCancel = "取消",
  bool showCancel = true,
  void Function()? onConfirm,
  void Function()? onCancel,
}) {
  return showDialog<T>(
      context: Get.overlayContext!,
      builder: (context) {
        return AlertDialog(
          title: titleWeight ?? Text(title ?? ""),
          content: contentWeight ?? Text(contentText ?? ""),
          actions: [
            if(showCancel)
             TextButton(
                onPressed: () {
                  if (onCancel != null) {
                    onCancel();
                  } else {
                    Get.back();
                  }
                },
                child: Text(textCancel)),
            ElevatedButton(
                onPressed: () {
                  if (onConfirm != null) {
                    onConfirm();
                  } else {
                    Get.back();
                  }
                },
                child: Text(textConfirm)),
          ],
        );
      });
}
