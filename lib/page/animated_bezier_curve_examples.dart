import 'package:flutter/material.dart';
import 'package:widget_simple/widgets/animated_bezier_curve.dart';

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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0f0c29),
              Color(0xFF302b63),
              Color(0xFF24243e),
            ],
          ),
        ),
        child: Column(
          children: [
            // 自定义 AppBar
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 16),
                  Text(
                    "Animated Bezier Curve",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 标题说明
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                '动态贝塞尔曲线动画演示',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
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
      ),
    );
  }

  onControllerAction(bool state) {
    setState(() {
      _isPlaying = state;
    });
  }
}
