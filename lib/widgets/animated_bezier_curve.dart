import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBezierCurve extends StatefulWidget {
  final ValueChanged<bool> onAction;
  final int numControlPoints;
  final bool playing;

  const AnimatedBezierCurve(
      {super.key,
      required this.onAction,
      this.numControlPoints = 16,
      this.playing = false});

  @override
  AnimatedBezierCurveState createState() => AnimatedBezierCurveState();
}

class AnimatedBezierCurveState extends State<AnimatedBezierCurve>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Offset> _startPoints1 = [];
  List<Offset> _endPoints1 = [];
  List<Offset> _startPoints2 = [];
  List<Offset> _endPoints2 = [];
  late Animation<double> _animation;
  bool _isPlaying = true;
  Offset center = Offset.zero;
  double maxRadius1 = 145;
  double minRadius1 = 115;

  double maxRadius2 = 140;
  double minRadius2 = 175;

  // StreamSubscription<BeginPlay>? sub;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.playing;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _startPoints1 = _endPoints1;
          _endPoints1 = _generatePoints(maxRadius1, minRadius1);
          _startPoints2 = _endPoints2;
          _endPoints2 = _generatePoints(maxRadius2, minRadius2);
          _controller.forward(from: 0.0);
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPoints1 = _generatePoints(maxRadius1, minRadius1);
      _endPoints1 = _generatePoints(maxRadius1, minRadius1);
      _startPoints2 = _generatePoints(maxRadius2, minRadius2);
      _endPoints2 = _generatePoints(maxRadius2, minRadius2);
      setState(() {});
      if (_isPlaying) {
        _controller.forward();
      }
    });

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // sub =  EventBusUtil.on<BeginPlay>((event){
    //   if(event.start){
    //     _controller.forward();
    //     _isPlaying = true;
    //   }else{
    //     _controller.stop();
    //     _isPlaying = false;
    //   }
    //
    //   setState(() {
    //
    //   });
    // });
  }

  List<double> _generateAngles() {
    final rand = math.Random();
    List<double> angles = List.generate(
        widget.numControlPoints, (_) => 18.0 + rand.nextDouble() * 10.0);

    double totalAngle = angles.reduce((a, b) => a + b);
    for (int i = 0; i < angles.length; i++) {
      angles[i] = angles[i] * 360.0 / totalAngle;
    }

    return angles;
  }

  List<Offset> _generatePoints(double maxRadius, double minRadius) {
    final rand = math.Random();
    List<double> angles = _generateAngles();
    double currentAngle = 0.0;

    return angles.map((angle) {
      double radius = minRadius + rand.nextDouble() * (maxRadius - minRadius);
      double newX = center.dx + radius * math.cos(currentAngle * math.pi / 180);
      double newY = center.dy + radius * math.sin(currentAngle * math.pi / 180);
      currentAngle += angle;
      return Offset(newX, newY);
    }).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    // sub?.cancel();
    super.dispose();
  }

  void _toggleAnimation() {
    setState(() {
      if (_isPlaying) {
        _controller.stop();
      } else {
        _controller.forward();
      }
      _isPlaying = !_isPlaying;
      widget.onAction.call(_isPlaying);
    });
  }

  @override
  Widget build(BuildContext context) {
    const double containerSize = 360.0;

    center = const Offset(containerSize / 2, containerSize / 2);

    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(containerSize, containerSize),
            painter: BezierPainter(
              startPoints1: _startPoints1,
              endPoints1: _endPoints1,
              startPoints2: _startPoints2,
              endPoints2: _endPoints2,
              animationValue: _animation.value,
              center: center,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: _toggleAnimation,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Center(
                  child: Image.asset(
                    _isPlaying
                        ? "assets/image/pause.webp"
                        : "assets/image/play.webp",
                    width: 64,
                    height: 64,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BezierPainter extends CustomPainter {
  final List<Offset> startPoints1;
  final List<Offset> endPoints1;
  final List<Offset> startPoints2;
  final List<Offset> endPoints2;
  final double animationValue;
  final Offset center;

  BezierPainter({
    required this.startPoints1,
    required this.endPoints1,
    required this.startPoints2,
    required this.endPoints2,
    required this.animationValue,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint1 = Paint()
      ..color = Color.fromARGB((0.5 * 255).round(), 0x69, 0xF0, 0xAE)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Paint pointPaint1 = Paint()
      ..color = Color.fromARGB((0.2 * 255).round(), 0x69, 0xF0, 0xAE)
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;

    Paint paint2 = Paint()
      ..color = Color.fromARGB((0.5 * 255).round(), 0x69, 0xF0, 0xAE)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Paint pointPaint2 = Paint()
      ..color = Color.fromARGB((0.2 * 255).round(), 0x69, 0xF0, 0xAE)
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;

    _drawBezierCurve(
        canvas, startPoints1, endPoints1, animationValue, paint1, pointPaint1);
    _drawBezierCurve(
        canvas, startPoints2, endPoints2, animationValue, paint2, pointPaint2);

    Paint ringPaint = Paint()
      ..color = Color.fromARGB((0.7 * 255).round(), 0x69, 0xF0, 0xAE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawCircle(center, 75, ringPaint);
  }

  void _drawBezierCurve(
      Canvas canvas,
      List<Offset> startPoints,
      List<Offset> endPoints,
      double animationValue,
      Paint paint,
      Paint pointPaint) {
    List<Offset> currentPoints = List.generate(startPoints.length, (index) {
      double dx = startPoints[index].dx +
          (endPoints[index].dx - startPoints[index].dx) * animationValue;
      double dy = startPoints[index].dy +
          (endPoints[index].dy - startPoints[index].dy) * animationValue;
      return Offset(dx, dy);
    });

    Path path = Path();

    for (int i = 0; i < currentPoints.length; i++) {
      int nextIndex = (i + 1) % currentPoints.length;
      int prevIndex = (i - 1 + currentPoints.length) % currentPoints.length;

      Offset p0 = currentPoints[prevIndex];
      Offset p1 = currentPoints[i];
      Offset p2 = currentPoints[nextIndex];

      Offset midPoint1 = Offset(
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2,
      );
      Offset midPoint2 = Offset(
        (p1.dx + p2.dx) / 2,
        (p1.dy + p2.dy) / 2,
      );

      if (i == 0) {
        path.moveTo(midPoint1.dx, midPoint1.dy);
      }

      path.quadraticBezierTo(p1.dx, p1.dy, midPoint2.dx, midPoint2.dy);
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(path, pointPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
