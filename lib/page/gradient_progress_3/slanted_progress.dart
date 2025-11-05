import 'dart:math';
import 'package:flutter/material.dart';

/// 斜切进度指示器：左侧高亮（彩色），右侧灰度
class SlantedProgress extends StatefulWidget {
  final double progress; // 0.0 ~ 1.0
  final double angle; // -45 ~ 45
  final ImageProvider background;
  final String text;
  final TextStyle leftTextStyle;
  final TextStyle rightTextStyle;
  final VoidCallback? onTap;

  const SlantedProgress({
    super.key,
    required this.progress,
    this.angle = 20,
    required this.background,
    required this.text,
    required this.leftTextStyle,
    required this.rightTextStyle,
    this.onTap,
  });

  @override
  State<SlantedProgress> createState() =>
      _SlantedProgressState();
}

class _SlantedProgressState extends State<SlantedProgress> {
  static const ColorFilter _grayFilter = ColorFilter.matrix([
    0.2126 * 0.7,
    0.7152 * 0.7,
    0.0722 * 0.7,
    0,
    0,
    0.2126 * 0.7,
    0.7152 * 0.7,
    0.0722 * 0.7,
    0,
    0,
    0.2126 * 0.7,
    0.7152 * 0.7,
    0.0722 * 0.7,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 200,
        height: 36,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            // 限制 progress 在 [0, 1]
            final clampedProgress = (widget.progress).clamp(0.0, 1.0);
            final position = width * clampedProgress;

            final radians = widget.angle * pi / 180;
            // 防止 tan(±90°) 无穷大，限制 angle 范围已在构造中约定
            final dx = tan(radians) * height / 2;

            final p1 = Offset(position + dx, 0);
            final p2 = Offset(position - dx, height);

            // 左侧高亮区域（彩色）
            final leftPath = Path()
              ..moveTo(0, 0)
              ..lineTo(0, height)
              ..lineTo(p2.dx, p2.dy)
              ..lineTo(p1.dx, p1.dy)
              ..close();

            // 右侧灰度区域
            final rightPath = Path()
              ..moveTo(width, height)
              ..lineTo(width, 0)
              ..lineTo(p1.dx, p1.dy)
              ..lineTo(p2.dx, p2.dy)
              ..close();

            return Stack(
              fit: StackFit.expand,
              children: [
                // 彩色底图
                Image(image: widget.background, fit: BoxFit.fill),

                // 右侧灰度覆盖
                ClipPath(
                  clipper: _SlantedClipper(rightPath),
                  child: ColorFiltered(
                    colorFilter: _grayFilter,
                    child: Image(image: widget.background, fit: BoxFit.fill),
                  ),
                ),

                // 分割线
                // CustomPaint(painter: _LinePainter(p1, p2)),

                // 左侧文字
                ClipPath(
                  clipper: _SlantedClipper(leftPath),
                  child: Container(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              height: 24,
                              child: Text(
                                widget.text,
                                style: widget.leftTextStyle.copyWith(height: 1),
                              ),
                            ),
                          ),
                          WidgetSpan(
                            child: Transform.translate(
                              offset: const Offset(0, -3.5),
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: Image.asset(
                                  "assets/image/qus.png",
                                  colorBlendMode: BlendMode.srcIn,
                                  color: widget.leftTextStyle.color,
                                ),
                              ),
                            ),
                          ),
                        ],
                        style: widget.leftTextStyle.copyWith(
                          height: 1,
                        ), // fallback
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // 右侧文字
                ClipPath(
                  clipper: _SlantedClipper(rightPath),
                  child: Container(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              height: 24,
                              child: Text(
                                widget.text,
                                style: widget.rightTextStyle.copyWith(
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                          WidgetSpan(
                            child: Transform.translate(
                              offset: const Offset(0, -3.5),
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: Image.asset(
                                  "assets/image/qus.png",
                                  colorBlendMode: BlendMode.srcIn,
                                  color: widget.rightTextStyle.color,
                                ),
                              ),
                            ),
                          ),
                        ],
                        style: widget.rightTextStyle,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// --- 以下为辅助类（可放在同一文件或 utils/ 中）---

class _SlantedClipper extends CustomClipper<Path> {
  final Path path;
  _SlantedClipper(this.path);

  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(covariant _SlantedClipper oldClipper) => true;
}

class _LinePainter extends CustomPainter {
  final Offset p1;
  final Offset p2;

  _LinePainter(this.p1, this.p2);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) =>
      oldDelegate.p1 != p1 || oldDelegate.p2 != p2;
}
