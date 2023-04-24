import 'package:flutter/material.dart';

enum SimpleButtonType {
  primary,
  normal,
}

enum SimpleButtonSize {
  normal,
  small,
}

class SimpleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final SimpleButtonType? type;
  final SimpleButtonSize? size;
  final Icon? icon;

  const SimpleButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.type = SimpleButtonType.normal,
    this.size = SimpleButtonSize.normal,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? foregroundColor;
    Size? minimumSize;
    if (type == SimpleButtonType.primary) {
      backgroundColor = Theme.of(context).buttonTheme.colorScheme!.primary;
      foregroundColor = Theme.of(context).buttonTheme.colorScheme!.onPrimary;
    }
    if (size == SimpleButtonSize.small) {
      minimumSize = const Size(60, 30);
    }

    final style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      minimumSize: minimumSize,
    );

    if(icon != null) {
      return ElevatedButton.icon(style: style, onPressed: onPressed, icon: icon!, label: child);
    }

    return ElevatedButton(style: style, onPressed: onPressed, child: child);
  }
}
