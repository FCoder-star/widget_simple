import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/router_config.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final List<ExampleItem> examples = [
      ExampleItem(
        title: 'Animated Bezier Curve',
        description: '展示动画贝塞尔曲线示例',
        routeName: AppRoutes.animatedBezierCurve,
        gradientColors: [
          colorScheme.primary.withOpacity(0.7),
          colorScheme.secondary.withOpacity(0.7),
        ],
        iconData: Icons.auto_awesome_outlined,
      ),

      ExampleItem(
        title: 'Seek Bar',
        description: '展示自定义滑动条示例',
        routeName: AppRoutes.seekBar,
        gradientColors: [
          Colors.teal.withOpacity(0.7),
          Colors.blue.withOpacity(0.7),
        ],
        iconData: Icons.touch_app,
      ),



      ExampleItem(
        title: 'Gradient Progress',
        description: '展示渐变进度条示例',
        routeName: AppRoutes.gradientProgress,
        gradientColors: [
          Colors.deepPurpleAccent.withOpacity(0.7),
          Colors.pinkAccent.withOpacity(0.7),
        ],
        iconData: Icons.linear_scale,
      ),

      ExampleItem(
        title: 'Drag Gray Image',
        description: '展示拖动图片控制灰化比例示例',
        routeName: AppRoutes.dragGrayImage,
        gradientColors: [
          Colors.grey.withOpacity(0.7),
          Colors.blueGrey.withOpacity(0.7),
        ],
        iconData: Icons.image_outlined,
      ),
      ExampleItem(
        title: 'Diagonal Gray Compare',
        description: '展示对角线分割图片控制灰化比例示例',
        routeName: AppRoutes.ratioDiagonalGrayCompare,
        gradientColors: [
          Colors.orange.withOpacity(0.7),
          Colors.deepOrange.withOpacity(0.7),
        ],
        iconData: Icons.compare_outlined,
      ),

      ExampleItem(
        title: 'Slanted Progress Indicator',
        description: '展示斜纹背景可点击进度条',
        routeName: AppRoutes.slantedProgressIndicator,
        gradientColors: [
          Colors.indigo.withOpacity(0.7),
          Colors.blueAccent.withOpacity(0.7),
        ],
        iconData: Icons.slideshow_outlined,
      ),
      ExampleItem(
        title: 'Slide Verify',
        description: '展示滑动验证组件示例',
        routeName: AppRoutes.slideVerify,
        gradientColors: [
          const Color(0xFF2C3E50).withOpacity(0.8), // 深蓝灰色
          const Color(0xFF3498DB).withOpacity(0.8), // 现代蓝色
        ],
        iconData: Icons.verified_user_outlined,
      ),

      ExampleItem(
        title: 'ClipPath Example',
        description: '展示 Path 裁剪与基本 API 用法',
        routeName: AppRoutes.clipPath,
        gradientColors: [
          Colors.purple.withOpacity(0.7),
          Colors.deepPurple.withOpacity(0.7),
        ],
        iconData: Icons.cut_outlined,
      ),
      ExampleItem(
        title: 'Chamfered Container',
        description: '展示切角容器组件示例',
        routeName: AppRoutes.chamfered,
        gradientColors: [
          const Color(0xFF4CAF50).withOpacity(0.8), // 绿色
          const Color(0xFF2196F3).withOpacity(0.8), // 蓝色
        ],
        iconData: Icons.crop_square_outlined,
      ),
      ExampleItem(
        title: 'Super Ellipse Logo',
        description: '展示超椭圆/小米 LOGO 绘制',
        routeName: AppRoutes.superEllipse,
        gradientColors: [
          const Color(0xFFFFA726).withOpacity(0.85), // 小米橙
          const Color(0xFFFF5722).withOpacity(0.9), // 鲜亮橙红
        ],
        iconData: Icons.blur_circular,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Widgets Examples'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: examples.length,
        itemBuilder: (context, index) {
          return ExampleCard(example: examples[index]);
        },
      ),
    );
  }
}

class ExampleItem {
  final String title;
  final String description;
  final String routeName;
  final List<Color> gradientColors;
  final IconData iconData;

  ExampleItem({
    required this.title,
    required this.description,
    required this.routeName,
    required this.gradientColors,
    required this.iconData,
  });
}

class ExampleCard extends StatefulWidget {
  final ExampleItem example;

  const ExampleCard({super.key, required this.example});

  @override
  State<ExampleCard> createState() => _ExampleCardState();
}

class _ExampleCardState extends State<ExampleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 直接使用ExampleItem中定义的渐变颜色

    return MouseRegion(
      onEnter: (_) {
        _controller.forward();
      },
      onExit: (_) {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.example.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                context.pushNamed(widget.example.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // 左侧图标
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.example.iconData,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 中间文本内容
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.example.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.example.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 右侧箭头图标
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.8),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
