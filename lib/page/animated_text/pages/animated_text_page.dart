
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_simple/page/animated_text/widget/wave_gradient_text.dart';

class AnimatedTextPage extends StatefulWidget {
  const AnimatedTextPage({super.key, required this.title});

  final String title;

  @override
  State<AnimatedTextPage> createState() => _AnimatedTextPageState();
}

class _AnimatedTextPageState extends State<AnimatedTextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDemoCard(
              title: 'None Strategy',
              subtitle: '无溢出处理，自然渲染',
              child: WaveGradientText(
                text: 'Cyberpunk 2077',
                overflowStrategy: TextOverflowStrategy.none,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
                amplitude: 8.0,
                charPhase: 0.5,
                gradientColors: const [
                  Color(0xFFFF0080),
                  Color(0xFFFF8C00),
                  Color(0xFFFFE600),
                  Color(0xFF00FF9F),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildEllipsisDemo(),
            const SizedBox(height: 24),
            _buildScaleDemo(),
            const SizedBox(height: 24),
            _buildMarqueeDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.white38),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildEllipsisDemo() {
    return _buildDemoCard(
      title: 'Ellipsis Strategy',
      subtitle: '超出宽度时截断并显示省略号（带动效）',
      child: WaveGradientText(
        text: 'The quick brown fox jumps over the lazy dog',
        overflowStrategy: TextOverflowStrategy.ellipsis,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        amplitude: 6.0,
        charPhase: 0.4,
        gradientColors: const [
          Color(0xFF00D9FF),
          Color(0xFF00FFA3),
          Color(0xFFB8FF00),
        ],
      ),
    );
  }

  Widget _buildScaleDemo() {
    return _buildDemoCard(
      title: 'Scale Strategy',
      subtitle: '自动缩小字体以适应宽度',
      child: WaveGradientText(
        text: 'NEON GENESIS EVANGELION',
        overflowStrategy: TextOverflowStrategy.scale,
        minFontSize: 16.0,
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
        amplitude: 5.0,
        charPhase: 0.3,
        gradientColors: const [
          Color(0xFFFF00FF),
          Color(0xFF00FFFF),
          Color(0xFFFF00FF),
        ],
      ),
    );
  }

  Widget _buildMarqueeDemo() {
    return _buildDemoCard(
      title: 'Marquee Strategy',
      subtitle: '超出宽度时水平滚动',
      child: WaveGradientText(
        text: 'Welcome to the Future — Infinite Scroll Animation Demo',
        overflowStrategy: TextOverflowStrategy.marquee,
        marqueeSpeed: 50.0,
        marqueeGap: 40.0,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        amplitude: 4.0,
        charPhase: 0.5,
        gradientColors: const [
          Color(0xFFFFD700),
          Color(0xFFFF6B6B),
          Color(0xFFFF00FF),
          Color(0xFF4169E1),
        ],
      ),
    );
  }
}
