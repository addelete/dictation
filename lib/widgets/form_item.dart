import 'package:flutter/material.dart';

class FormItem extends StatelessWidget {
  final String? label;
  final Widget? labelWidget;
  final Widget control;
  final bool? isHorizontal;
  final double? labelWidth;

  const FormItem(
      {Key? key,
      this.label,
      this.labelWidget,
      required this.control,
      this.labelWidth = 80.0,
      this.isHorizontal = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isHorizontal!) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24,),
        child: Row(
          children: [
            SizedBox(
              width: labelWidth,
              child: labelWidget ?? Text(label!),
            ),
            const SizedBox(width: 10),
            Expanded(child: control)
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelWidget ?? Text(label!),
          const SizedBox(height: 10),
          control
        ],
      );
    }
  }
}
