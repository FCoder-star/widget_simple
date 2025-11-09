import 'dart:math';

import 'package:flutter/material.dart';

class SuperEllipseDemo extends StatefulWidget {
  const SuperEllipseDemo({super.key});

  @override
  State<SuperEllipseDemo> createState() => _SuperEllipseDemoState();
}

class _SuperEllipseDemoState extends State<SuperEllipseDemo> {
  double n = 3.0; // 小米LOGO的n值大约在3左右

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white, // ✅ 小米LOGO常用白底
        appBar: AppBar(
          title: const Text('超椭圆曲线演示 (小米LOGO)'),
          backgroundColor: const Color(0xFFFF6900), // ✅ 小米橙
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: CustomPaint(
                    size: const Size(300, 300), // 固定绘制区域
                    painter: XiaomiLogoPainter(n: n),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '当前 n 值：${n.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Slider(
                value: n,
                min: 1,
                max: 5,
                divisions: 99,
                label: n.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    n = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class XiaomiLogoPainter extends CustomPainter {
  final double n;

  const XiaomiLogoPainter({this.n = 3.0});

  @override
  void paint(Canvas canvas, Size size) {
    final a = size.width / 2;
    final b = size.height / 2;
    final path = Path();

    for (double angle = 0; angle < 2 * pi; angle += 0.01) {
      final cosA = cos(angle);
      final sinA = sin(angle);
      final r = 1 / pow(pow(cosA.abs(), n) + pow(sinA.abs(), n), 1 / n);
      final x = a * r * cosA;
      final y = b * r * sinA;

      if (angle == 0) {
        path.moveTo(a + x, b + y);
      } else {
        path.lineTo(a + x, b + y);
      }
    }

    path.close();

    // ✅ 小米橙填充
    final paintFill = Paint()
      ..color = const Color(0xFFFF6900)
      ..style = PaintingStyle.fill;

    // ✅ 可选黑色边框用于对比
    final paintStroke = Paint()
      ..color = const Color(0xFFFF6900)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant XiaomiLogoPainter oldDelegate) =>
      oldDelegate.n != n;
}
