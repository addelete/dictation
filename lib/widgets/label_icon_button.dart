import 'package:flutter/material.dart';

/// 带标题的图标按钮
class LabelIconButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool disabled;

  const LabelIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.label,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 8),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
