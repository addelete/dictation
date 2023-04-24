import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 简单卡片
class SimpleCard extends StatelessWidget {
  final Widget? child;
  final String? title;
  final Widget? titleWidget;
  final void Function()? onClose;

  const SimpleCard({Key? key, this.child, this.title, this.titleWidget, this.onClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showHeader = title != null || titleWidget != null || onClose != null;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader)
            SizedBox(
              height: 54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: titleWidget ?? Text(
                        title ?? "",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),

                  if (onClose != null)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                    ),
                ],
              ),
            ),
          if (child != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: child,
            ),
        ],
      ),
    );
  }
}
