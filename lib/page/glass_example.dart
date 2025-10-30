import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassExample extends StatefulWidget {
  const GlassExample({super.key});

  @override
  State<GlassExample> createState() => _GlassExampleState();
}

class _GlassExampleState extends State<GlassExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _pulse = Tween(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景图
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1526401485004-2fa806b5cbf0?w=1200',
              fit: BoxFit.cover,
            ),
          ),
          // 背景渐变
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.7)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 中间的液态玻璃
          Center(
            child: LiquidGlass(
              shape: const LiquidRoundedSuperellipse(
                  borderRadius: Radius.circular(40)),
              settings: const LiquidGlassSettings(
                thickness: 10,
                glassColor: Color(0x55FFFFFF),
                lightIntensity: 1.2,
                ambientStrength: 0.6,
                blend: 30,
                saturation: 1.1,
              ),
              child: SizedBox(
                height: 300,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FlutterLogo(size: 90),
                    SizedBox(height: 16),
                    Text(
                      'Liquid Glass',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 底部动态发光按钮（替代 StretchGlass）
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: ScaleTransition(
              scale: _pulse,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("💧 Liquid button tapped!"),
                    duration: Duration(seconds: 1),
                  ));
                },
                child: Container(
                  height: 70,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: const LinearGradient(
                      colors: [Colors.white30, Colors.white10],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "PRESS ME",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2),
                    ),
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