import 'package:get/get.dart';
import 'package:flutter/material.dart';

/// 弹出框
Future<T?> showPopup<T>({
  required Widget child,
  void Function()? onOk,
  void Function()? onCancel,
  String? title,
  Widget? titleWidget,
  Color? color,
}) {
  final showNav = onOk != null ||
      (title != null && title.isNotEmpty) ||
      (titleWidget != null);
  final vTitle = title ?? "";
  final showNavBtn = onOk != null;
  final bgColor = color ?? Get.theme.cardColor;
  final bottom = GetPlatform.isIOS ? 0.0 : 20.0;

  return showModalBottomSheet<T>(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AnimatedPadding(
            duration: const Duration(milliseconds: 100),
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: showNav
                      ? Row(
                          children: [
                            showNavBtn
                                ? TextButton(
                                    onPressed: () {
                                      if (onCancel != null) {
                                        onCancel();
                                      } else {
                                        Get.back();
                                      }
                                    },
                                    child: const Text("取消"))
                                : const SizedBox(),
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: titleWidget ??
                                  Text(
                                    vTitle,
                                  ),
                            ),
                            const Spacer(),
                            showNavBtn
                                ? TextButton(
                                    onPressed: () => onOk(),
                                    child: const Text("确定"))
                                : const SizedBox()
                          ],
                        )
                      : const SizedBox(
                          height: 20.0,
                          width: double.infinity,
                        ),
                ),
                Container(
                  color: bgColor,
                  width: double.infinity,
                  child: child,
                ),
                Container(
                    color: bgColor,
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: bottom),
                    child: const SafeArea(
                      child: SizedBox(),
                    )),
              ],
            )),
          ));
}
