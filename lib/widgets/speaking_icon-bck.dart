import 'package:flutter/material.dart';

class MyAnimation extends StatefulWidget {
  const MyAnimation({super.key});

  @override
  MyAnimationState createState() => MyAnimationState();
}

class MyAnimationState extends State<MyAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    //创建动画控制器
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    //创建高度范围
    final Tween<double> heightTween = Tween(begin: 10.0, end: 40.0);
    //创建动画对象
    _animation = heightTween.animate(_controller);
    //启动动画并反向执行
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    //释放资源
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //绘制四个矩形，并根据动画值设置高度
            Container(
              width: 6.0,
              height: _animation.value,
              color: Colors.red,
              alignment: Alignment.bottomCenter,
            ),
            const SizedBox(width: 6),
            Container(
              width: 6.0,
              height: _animation.value + 10,
              color: Colors.green,
              alignment: Alignment.bottomCenter,
            ),
            const SizedBox(width: 6),
            Container(
              width: 6.0,
              height: _animation.value,
              color: Colors.blue,
              alignment: Alignment.bottomCenter,
            ),
            const SizedBox(width: 6),
            Container(
              width: 6.0,
              height: _animation.value,
              color: Colors.yellow,
              alignment: Alignment.bottomCenter,
            ),
          ],
        );
      },
    );
  }
}
