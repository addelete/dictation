import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SpeakingIcon extends StatelessWidget {
  final bool isSpeaking;

  const SpeakingIcon({Key? key, required this.isSpeaking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        Theme.of(context).buttonTheme.colorScheme!.primary;
    final Color foregroundColor =
        Theme.of(context).buttonTheme.colorScheme!.onPrimary;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: isSpeaking
            ? List.generate(5, (index) {
                return Animate(
                  delay: (index * 200).ms,
                  onPlay: (controller) => controller.repeat(),
                ).custom(
                  duration: 1000.ms,
                  begin: 10,
                  end: 40,
                  builder: (_, value, __) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      height: value > 25 ? 50 - value : value,
                      width: 6,
                      decoration: BoxDecoration(
                        color: foregroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                );
              })
            : List.generate(2, (index) {
                return Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: Container(
                  width: 10,
                  height: 25,
                  decoration: BoxDecoration(
                    color: foregroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                ),);
              }),
      ),
    );
  }
}
