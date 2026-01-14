import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/signature_state.dart';

/// 签字板画布组件
/// 使用 GestureDetector 捕获手势，CustomPainter 绘制笔画
class SignatureCanvas extends StatelessWidget {
  final SignatureState state;
  final GlobalKey canvasKey;

  const SignatureCanvas({
    super.key,
    required this.state,
    required this.canvasKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: state.background.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        // RepaintBoundary 用于将画布内容转换为图片
        child: RepaintBoundary(
          key: canvasKey,
          // GestureDetector 捕获手势事件
          child: GestureDetector(
            onPanStart: (details) => state.startStroke(details.localPosition),
            onPanUpdate: (details) => state.addPoint(details.localPosition),
            onPanEnd: (_) => state.endStroke(),
            child: CustomPaint(
              painter: SignaturePainter(
                strokes: state.strokes,
                currentStroke: state.currentStroke,
                currentWidth: state.currentWidth.value,
                backgroundColor: state.background.color,
              ),
              size: Size.infinite,
            ),
          ),
        ),
      ),
    );
  }

  /// 导出画布为 PNG 图片
  /// 返回图片的字节数据，失败时返回 null
  Future<Uint8List?> exportImage() async {
    try {
      final boundary = canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      // 以 3 倍像素比率生成高清图片
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }
}

/// 签字板绘制器
/// 绘制所有已完成的笔画和当前正在绘制的笔画
class SignaturePainter extends CustomPainter {
  final List<Stroke> strokes;          // 已完成的笔画列表
  final List<Offset> currentStroke;    // 当前正在绘制的笔画
  final double currentWidth;           // 当前画笔粗细
  final Color backgroundColor;         // 背景颜色

  SignaturePainter({
    required this.strokes,
    required this.currentStroke,
    required this.currentWidth,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    // 配置画笔样式
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round  // 圆形笔触端点
      ..style = PaintingStyle.stroke;

    // 绘制所有已完成的笔画
    for (final stroke in strokes) {
      paint.strokeWidth = stroke.width;
      _drawStroke(canvas, stroke.points, paint);
    }

    // 绘制当前正在绘制的笔画
    if (currentStroke.isNotEmpty) {
      paint.strokeWidth = currentWidth;
      _drawStroke(canvas, currentStroke, paint);
    }
  }

  /// 绘制单条笔画
  /// 通过连接相邻点绘制连续的线段
  void _drawStroke(Canvas canvas, List<Offset> points, Paint paint) {
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
