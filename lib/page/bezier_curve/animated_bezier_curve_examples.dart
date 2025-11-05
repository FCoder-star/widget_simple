import 'package:flutter/material.dart';
import 'package:widget_simple/components/app_scaffold.dart';
import 'package:widget_simple/components/page_title_bar.dart';
import 'package:widget_simple/page/bezier_curve/animated_bezier_curve.dart';

class AnimatedBezierCurveExamples extends StatefulWidget {
  const AnimatedBezierCurveExamples({super.key});

  @override
  State<AnimatedBezierCurveExamples> createState() =>
      _AnimatedBezierCurveExamplesState();
}

class _AnimatedBezierCurveExamplesState
    extends State<AnimatedBezierCurveExamples> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PageTitleBar(
        title: "Animated Bezier Curve",
      ),
      body: Column(
        children: [
            // 标题说明
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                '动态贝塞尔曲线动画演示',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
            // 动画展示区域
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 主要动画组件
                  Center(
                    child: AnimatedBezierCurve(
                      onAction: onControllerAction,
                      playing: _isPlaying,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  onControllerAction(bool state) {
    setState(() {
      _isPlaying = state;
    });
  }
}
