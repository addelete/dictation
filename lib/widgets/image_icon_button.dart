import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 图片图标按钮
class ImageIconButton extends StatelessWidget {
  final String? title;
  final String iconPath;
  final VoidCallback onPressed;

  const ImageIconButton({
    Key? key,
    required this.iconPath,
    required this.onPressed,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSvg = iconPath.endsWith('.svg');
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              child: Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(12),
                child: isSvg
                    ? SvgPicture.asset(
                        iconPath,
                      )
                    : Image.asset(
                        iconPath,
                      ),
              ),
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                title!,
                style: const TextStyle(fontSize: 12),
              ),
            )
        ],
      ),
    );
  }
}
