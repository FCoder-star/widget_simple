import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/signature_state.dart';

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
        child: RepaintBoundary(
          key: canvasKey,
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

  Future<Uint8List?> exportImage() async {
    try {
      final boundary = canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }
}

class SignaturePainter extends CustomPainter {
  final List<Stroke> strokes;
  final List<Offset> currentStroke;
  final double currentWidth;
  final Color backgroundColor;

  SignaturePainter({
    required this.strokes,
    required this.currentStroke,
    required this.currentWidth,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      paint.strokeWidth = stroke.width;
      _drawStroke(canvas, stroke.points, paint);
    }

    if (currentStroke.isNotEmpty) {
      paint.strokeWidth = currentWidth;
      _drawStroke(canvas, currentStroke, paint);
    }
  }

  void _drawStroke(Canvas canvas, List<Offset> points, Paint paint) {
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
