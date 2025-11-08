import 'package:flutter/material.dart';
import 'package:widget_simple/components/app_scaffold.dart';
import 'package:widget_simple/components/page_title_bar.dart';
import 'package:widget_simple/page/chamfered/widgets/chamfered_container.dart';

class ChamferedDemoPage extends StatelessWidget {
  const ChamferedDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PageTitleBar(title: 'Chamfered Container · Demo'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('v1.0.0 - 基础示例'),
          const SizedBox(height: 16),
          _buildBasicExamples(),
          const SizedBox(height: 32),
          _buildSectionTitle('v1.0.0 - 宽高独立设置'),
          const SizedBox(height: 16),
          _buildCustomSizeExamples(),
          const SizedBox(height: 32),
          _buildSectionTitle('v2.0.0 - 圆弧过渡新特性 🎉'),
          const SizedBox(height: 8),
          _buildFeatureDescription(),
          const SizedBox(height: 16),
          _buildArcTransitionExamples(),
          const SizedBox(height: 32),
          _buildSectionTitle('v2.0.0 - 圆弧过渡对比'),
          const SizedBox(height: 16),
          _buildComparisonExamples(),
          const SizedBox(height: 32),
          _buildSectionTitle('v2.0.0 - 圆角支持 🎯'),
          const SizedBox(height: 8),
          _buildRoundedCornerDescription(),
          const SizedBox(height: 16),
          _buildRoundedCornerExamples(),
          const SizedBox(height: 32),
          _buildSectionTitle('v2.0.0 - 多角圆弧过渡'),
          const SizedBox(height: 16),
          _buildMultipleArcExamples(),
          const SizedBox(height: 32),
          _buildSectionTitle('实际应用'),
          const SizedBox(height: 16),
          _buildPracticalExamples(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBasicExamples() {
    return Row(
      children: [
        Expanded(
          child: ChamferedContainer(
            color: const Color(0xFFFFC107),
            bottomLeftChamfer: const ChamferSize.all(24),
            height: 120,
            child: const Center(
              child: Text(
                '左下角切角\n24x24',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ChamferedContainer(
            color: const Color(0xFF2196F3),
            topRightChamfer: const ChamferSize.all(24),
            height: 120,
            child: const Center(
              child: Text(
                '右上角切角\n24x24',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomSizeExamples() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ChamferedContainer(
                color: const Color(0xFFFF6B6B),
                topLeftChamfer: const ChamferSize(width: 40, height: 20),
                height: 120,
                child: const Center(
                  child: Text(
                    '左上角\n宽40 高20',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ChamferedContainer(
                color: const Color(0xFF4ECDC4),
                bottomRightChamfer: const ChamferSize(width: 20, height: 40),
                height: 120,
                child: const Center(
                  child: Text(
                    '右下角\n宽20 高40',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ChamferedContainer(
          color: const Color(0xFF95E1D3),
          bottomLeftChamfer: const ChamferSize(width: 60, height: 30),
          height: 100,
          child: const Center(
            child: Text(
              '左下角矩形切角 - 宽60 高30',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨ 圆弧过渡原理',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '通过设置 radius 参数（偏移量N），在切角线与边缘线的交点处，'
            '创建内切圆弧，实现平滑过渡效果。',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArcTransitionExamples() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ChamferedContainer(
                color: const Color(0xFF2196F3),
                bottomLeftChamfer: const ChamferSize.all(40, radius: 10),
                height: 120,
                child: const Center(
                  child: Text(
                    '左下角\n切角+圆弧\nradius: 8',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ChamferedContainer(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                topRightChamfer: const ChamferSize.all(40, radius: 12),
                height: 120,
                child: const Center(
                  child: Text(
                    '右上角\n切角+圆弧\nradius: 12',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ChamferedContainer(
          gradient: const LinearGradient(
            colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
          ),
          topLeftChamfer: const ChamferSize(width: 60, height: 30, radius: 10),
          height: 100,
          child: const Center(
            child: Text(
              '矩形切角 (60x30) + 圆弧过渡 (radius: 10)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonExamples() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text(
                    '无圆弧过渡',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ChamferedContainer(
                    color: const Color(0xFFFF6B6B),
                    bottomLeftChamfer: const ChamferSize.all(40),
                    height: 100,
                    child: const Center(
                      child: Text(
                        'radius: 0',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  const Text(
                    '圆弧过渡',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ChamferedContainer(
                    color: const Color(0xFF4CAF50),
                    bottomLeftChamfer: const ChamferSize.all(40, radius: 10),
                    height: 100,
                    child: const Center(
                      child: Text(
                        'radius: 10',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ChamferedContainer(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                ),
                topRightChamfer: const ChamferSize(width: 50, height: 30),
                height: 100,
                child: const Center(
                  child: Text(
                    '矩形切角\n无圆弧',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ChamferedContainer(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                ),
                topRightChamfer: const ChamferSize(
                  width: 50,
                  height: 30,
                  radius: 8,
                ),
                height: 100,
                child: const Center(
                  child: Text(
                    '矩形切角\n+ 圆弧',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundedCornerDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨ 圆角支持',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '无切角的角（width=0, height=0）也支持设置 radius，'
            '此时表现为普通圆角，类似 BorderRadius。',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedCornerExamples() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ChamferedContainer(
                color: const Color(0xFF9C27B0),
                topLeftChamfer: const ChamferSize(radius: 20),
                height: 100,
                child: const Center(
                  child: Text(
                    '左上圆角\nradius: 20',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ChamferedContainer(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BCD4), Color(0xFF009688)],
                ),
                topLeftChamfer: const ChamferSize(radius: 20),
                topRightChamfer: const ChamferSize(radius: 20),
                bottomLeftChamfer: const ChamferSize(radius: 20),
                bottomRightChamfer: const ChamferSize(radius: 20),
                height: 100,
                child: const Center(
                  child: Text(
                    '四角圆角',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ChamferedContainer(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          ),
          topLeftChamfer: const ChamferSize(width: 40, height: 20, radius: 8),
          topRightChamfer: const ChamferSize(radius: 20),
          bottomLeftChamfer: const ChamferSize(radius: 20),
          bottomRightChamfer: const ChamferSize(
            width: 40,
            height: 20,
            radius: 8,
          ),
          height: 120,
          child: const Center(
            child: Text(
              '混合：切角+圆弧 + 普通圆角',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleArcExamples() {
    return Column(
      children: [
        ChamferedContainer(
          gradient: const LinearGradient(
            colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
          ),
          topLeftChamfer: const ChamferSize.all(30, radius: 8),
          bottomRightChamfer: const ChamferSize.all(30, radius: 8),
          height: 100,
          child: const Center(
            child: Text(
              '对角双圆弧过渡',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ChamferedContainer(
          gradient: const LinearGradient(
            colors: [Color(0xFFfa709a), Color(0xFFfee140)],
          ),
          topLeftChamfer: const ChamferSize.all(24, radius: 6),
          topRightChamfer: const ChamferSize.all(24, radius: 6),
          bottomLeftChamfer: const ChamferSize.all(24, radius: 6),
          bottomRightChamfer: const ChamferSize.all(24, radius: 6),
          height: 100,
          child: const Center(
            child: Text(
              '四角圆弧过渡',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ChamferedContainer(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          topLeftChamfer: const ChamferSize(width: 50, height: 25, radius: 8),
          topRightChamfer: const ChamferSize(width: 50, height: 25, radius: 8),
          bottomLeftChamfer: const ChamferSize(
            width: 50,
            height: 25,
            radius: 8,
          ),
          bottomRightChamfer: const ChamferSize(
            width: 50,
            height: 25,
            radius: 8,
          ),
          height: 100,
          child: const Center(
            child: Text(
              '四角矩形切角 + 圆弧过渡',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPracticalExamples() {
    return Column(
      children: [
        ChamferedContainer(
          gradient: const LinearGradient(
            colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
          ),
          bottomLeftChamfer: const ChamferSize(
            width: 50,
            height: 32,
            radius: 10,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(height: 12),
              const Text(
                '新消息通知',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '带圆弧过渡的切角设计',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ChamferedContainer(
                gradient: const LinearGradient(
                  colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                ),
                topRightChamfer: const ChamferSize(
                  width: 40,
                  height: 24,
                  radius: 8,
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  children: [
                    Icon(Icons.trending_up, color: Colors.white, size: 28),
                    SizedBox(height: 8),
                    Text(
                      '128',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '今日销售',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ChamferedContainer(
                gradient: const LinearGradient(
                  colors: [Color(0xFFfa709a), Color(0xFFfee140)],
                ),
                bottomLeftChamfer: const ChamferSize(
                  width: 40,
                  height: 24,
                  radius: 8,
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  children: [
                    Icon(Icons.people, color: Colors.white, size: 28),
                    SizedBox(height: 8),
                    Text(
                      '1.2K',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '活跃用户',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
