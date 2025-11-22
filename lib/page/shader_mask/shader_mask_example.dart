import 'package:flutter/material.dart';
import 'package:widget_simple/components/app_scaffold.dart';
import 'package:widget_simple/components/page_title_bar.dart';

class ShaderMaskExample extends StatefulWidget {
  const ShaderMaskExample({super.key});

  @override
  State<ShaderMaskExample> createState() => _ShaderMaskExampleState();
}

class _ShaderMaskExampleState extends State<ShaderMaskExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const PageTitleBar(title: 'ShaderMask · Demo'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('1. 文字渐变效果'),
          const SizedBox(height: 16),
          _buildImageCutoutExample(),
          const SizedBox(height: 32),
          _buildSectionTitle('2. 渐变高光效果'),
          const SizedBox(height: 16),
          _buildGradientHighlightExample(),
          const SizedBox(height: 32),
          _buildSectionTitle('3. 闪光动效'),
          const SizedBox(height: 16),
          _buildShimmerAnimationExample(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // 1. 图片纹理填充效果
  Widget _buildImageCutoutExample() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '使用 SweepGradient 旋转渐变填充文字，创造彩虹般的多彩效果',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black87,
          ),
          child: Center(
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                // 使用渐变模拟多彩纹理效果
                return const SweepGradient(
                  colors: [
                    Color(0xFFFF6B6B),
                    Color(0xFFFFE66D),
                    Color(0xFF4ECDC4),
                    Color(0xFF667eea),
                    Color(0xFFf093fb),
                    Color(0xFFFF6B6B),
                  ],
                  center: Alignment.center,
                ).createShader(bounds);
              },
              child: const Text(
                'COLORFUL\nTEXTURE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 2. 渐变高光效果
  Widget _buildGradientHighlightExample() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [
                  Color(0xFFFFD700),
                  Color(0xFFFFE55C),
                  Color(0xFFFFD700),
                  Color(0xFFFFA500),
                ],
                stops: [0.0, 0.3, 0.6, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds);
            },
            child: const Column(
              children: [
                Icon(Icons.star, size: 64, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  '金色高光',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Gradient Highlight',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFFFF6B6B),
                        Color(0xFFFFE66D),
                      ],
                    ).createShader(bounds);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.local_fire_department,
                          size: 48, color: Colors.white),
                      SizedBox(height: 8),
                      Text(
                        '火焰',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFF667eea),
                        Color(0xFF64B5F6),
                      ],
                    ).createShader(bounds);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.water_drop, size: 48, color: Colors.white),
                      SizedBox(height: 8),
                      Text(
                        '水滴',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFF43e97b),
                        Color(0xFF38f9d7),
                      ],
                    ).createShader(bounds);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.eco, size: 48, color: Colors.white),
                      SizedBox(height: 8),
                      Text(
                        '自然',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 3. 闪光动效
  Widget _buildShimmerAnimationExample() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '使用 AnimationController 配合 ShaderMask 实现流光效果',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: const [
                      Color(0xFF667eea), // 深紫蓝
                      Color(0xFF00D4FF), // 霓虹蓝
                      Color(0xFFFF00FF), // 霓虹粉
                      Color(0xFFFFFF00), // 霓虹黄
                      Color(0xFF00D4FF), // 霓虹蓝
                      Color(0xFF667eea), // 深紫蓝
                    ],
                    stops: const [0.0, 0.25, 0.45, 0.55, 0.75, 1.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    transform: _GradientRotation(_controller.value),
                  ).createShader(bounds);
                },
                child: const Text(
                  'SHIMMER EFFECT',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // 背景图片
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/image/streams.webp',
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // 闪光遮罩
                  Positioned.fill(
                    child: ShaderMask(
                      blendMode: BlendMode.srcATop,
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: [
                            Colors.transparent,
                            const Color(0xFF00D4FF).withValues(alpha: 0.4), // 霓虹蓝
                            const Color(0xFFFF00FF).withValues(alpha: 0.6), // 霓虹粉
                            const Color(0xFFFFFF00).withValues(alpha: 0.4), // 霓虹黄
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                          begin: Alignment(-1.5 + _controller.value * 3, -0.3),
                          end: Alignment(-0.5 + _controller.value * 3, 0.3),
                        ).createShader(bounds);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // 文字
                  const Center(
                    child: Text(
                      '图片闪光效果',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              children: [
                Expanded(
                  child: _buildShimmerCard(
                    icon: Icons.flash_on,
                    title: '闪电',
                    progress: _controller.value,
                    colors: const [Color(0xFF00D4FF), Color(0xFF0099FF)], // 霓虹蓝
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildShimmerCard(
                    icon: Icons.whatshot,
                    title: '火焰',
                    progress: _controller.value,
                    colors: const [Color(0xFFFF00FF), Color(0xFFFF0099)], // 霓虹粉
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildShimmerCard({
    required IconData icon,
    required String title,
    required double progress,
    required List<Color> colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: [
              colors[0].withValues(alpha: 0.3),
              colors[0],
              colors[1],
              colors[0],
              colors[0].withValues(alpha: 0.3),
            ],
            stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
            transform: _GradientRotation(progress),
          ).createShader(bounds);
        },
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 渐变旋转变换
class _GradientRotation extends GradientTransform {
  final double progress;

  const _GradientRotation(this.progress);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    // 从左到右移动
    final dx = bounds.width * (progress * 2 - 0.5);
    return Matrix4.translationValues(dx, 0, 0);
  }
}
