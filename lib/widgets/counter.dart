import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Counter extends StatelessWidget {
  final RxInt count;
  final int? min;
  final int? max;
  final int? step;

  const Counter({
    Key? key,
    required this.count,
    this.min = 0,
    this.max,
    this.step = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme
        .of(context)
        .buttonTheme
        .colorScheme!.surfaceVariant;
    final foregroundColor = Theme
        .of(context)
        .buttonTheme
        .colorScheme!.onSurfaceVariant;

    return Row(children: [
      GestureDetector(
        onTap: () => decrement(),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 4.0),
          decoration:  BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
          child: Icon(Icons.remove, color: foregroundColor),
        ),
      ),
      const SizedBox(width: 0.5,),
      Obx(() =>
          Container(
            height: 32,
            width: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            color: backgroundColor,
            child: Text('$count', style: TextStyle(color: foregroundColor),),
          )),
      const SizedBox(width: 0.5,),
      GestureDetector(
        onTap: () => increment(),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: 4.0),
          decoration:  BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Icon(Icons.add, color: foregroundColor),
        ),
      ),
    ]);
  }

  increment() {
    if (max != null && count.value >= max!) {
      return;
    }
    count.value++;
  }

  decrement() {
    if (min != null && count.value <= min!) {
      return;
    }
    count.value--;
  }
}
