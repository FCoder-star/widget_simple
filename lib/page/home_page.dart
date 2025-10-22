import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/router_config.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ExampleItem> examples = [
      ExampleItem(
        title: 'Animated Bezier Curve',
        description: '展示动画贝塞尔曲线示例',
        routeName: AppRoutes.animatedBezierCurve,
      ),
      ExampleItem(
        title: 'Gradient Progress',
        description: '展示渐变进度条示例',
        routeName: AppRoutes.gradientProgress,
      ),
      ExampleItem(
        title: 'Seek Bar',
        description: '展示自定义滑动条示例',
        routeName: AppRoutes.seekBar,
      ),
      ExampleItem(
        title: 'Drag Gray Image',
        description: '展示拖动图片控制灰化比例示例',
        routeName: AppRoutes.dragGrayImage,
      ),
      ExampleItem(
        title: 'Diagonal Gray Compare',
        description: '展示对角线分割图片控制灰化比例示例',
        routeName: AppRoutes.ratioDiagonalGrayCompare,
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

  ExampleItem({
    required this.title,
    required this.description,
    required this.routeName,
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
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // 为每个示例项定义不同的颜色
    final List<Color> gradientColors = [
      if (widget.example.title.contains('Bezier')) ...[
        colorScheme.primary.withOpacity(0.7),
        colorScheme.secondary.withOpacity(0.7),
      ] else if (widget.example.title.contains('Gradient')) ...[
        Colors.deepPurpleAccent.withOpacity(0.7),
        Colors.pinkAccent.withOpacity(0.7),
      ] else if (widget.example.title.contains('Drag Gray')) ...[
        Colors.grey.withOpacity(0.7),
        Colors.blueGrey.withOpacity(0.7),
      ] else if (widget.example.title.contains('Diagonal')) ...[
        Colors.orange.withOpacity(0.7),
        Colors.deepOrange.withOpacity(0.7),
      ] else ...[
        Colors.teal.withOpacity(0.7),
        Colors.blue.withOpacity(0.7),
      ]
    ];

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        _controller.forward();
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
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
                        widget.example.title.contains('Bezier') 
                          ? Icons.auto_awesome_outlined
                          : widget.example.title.contains('Gradient')
                            ? Icons.linear_scale
                            : widget.example.title.contains('Drag Gray')
                              ? Icons.image_outlined
                              : widget.example.title.contains('Diagonal')
                                ? Icons.compare_outlined
                                : Icons.touch_app,
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