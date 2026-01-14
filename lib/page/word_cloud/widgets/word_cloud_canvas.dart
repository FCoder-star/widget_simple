import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/word_cloud_state.dart';

/// 词云画布组件
/// 使用 RepaintBoundary 包裹 CustomPaint，支持图片导出
class WordCloudCanvas extends StatelessWidget {
  final WordCloudState state;
  final GlobalKey canvasKey;

  const WordCloudCanvas({
    super.key,
    required this.state,
    required this.canvasKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        // RepaintBoundary 用于将画布内容转换为图片
        child: RepaintBoundary(
          key: canvasKey,
          child: CustomPaint(
            painter: WordCloudPainter(
              words: state.sampleWords,
              layout: state.layout,
              getColor: state.getColor,
              getFontSize: state.getFontSize,
              seed: state.randomSeed,
            ),
            size: Size.infinite,
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

/// 已放置的词语数据
/// 记录词语的位置、绘制器和边界矩形，用于碰撞检测
class _PlacedWord {
  final String word;          // 词语文本
  final Offset position;      // 绘制位置（左上角）
  final TextPainter painter;  // 文本绘制器
  final Rect rect;            // 边界矩形，用于碰撞检测

  _PlacedWord(this.word, this.position, this.painter, this.rect);
}

/// 词云绘制器
/// 实现螺旋布局算法和多种形状边界判断
class WordCloudPainter extends CustomPainter {
  final List<WordItem> words;                    // 词语列表
  final LayoutAlgorithm layout;                  // 布局形状
  final Color Function(int) getColor;            // 颜色生成函数
  final double Function(int, int) getFontSize;   // 字体大小计算函数
  final int seed;                                // 随机种子

  WordCloudPainter({
    required this.words,
    required this.layout,
    required this.getColor,
    required this.getFontSize,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 画布尺寸检查
    if (size.width <= 0 || size.height <= 0) return;

    // 绘制白色背景
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // 按权重降序排序词语，确保重要的词优先放置
    final sortedWords = List<WordItem>.from(words)
      ..sort((a, b) => b.weight.compareTo(a.weight));

    final maxWeight = sortedWords.first.weight;
    final placedWords = <_PlacedWord>[];

    // 遍历所有词语，尝试放置到画布上
    for (int i = 0; i < sortedWords.length; i++) {
      final word = sortedWords[i];
      final fontSize = getFontSize(word.weight, maxWeight);
      final color = getColor(i);

      // 创建文本绘制器并测量尺寸
      final textPainter = TextPainter(
        text: TextSpan(
          text: word.word,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // 使用螺旋布局算法寻找有效位置
      Offset? position;
      position = _findShapePosition(size, textPainter, placedWords, layout, seed + i);

      // 如果找到有效位置，记录并绘制词语
      if (position != null) {
        final rect = Rect.fromLTWH(
          position.dx,
          position.dy,
          textPainter.width,
          textPainter.height,
        );
        placedWords.add(_PlacedWord(word.word, position, textPainter, rect));
        textPainter.paint(canvas, position);
      }
    }
  }

  /// 使用螺旋布局算法寻找词语的有效放置位置
  ///
  /// [size] 画布尺寸
  /// [painter] 词语的文本绘制器
  /// [placed] 已放置的词语列表
  /// [shape] 布局形状
  /// [localSeed] 随机种子，用于生成不同的起始角度
  ///
  /// 算法原理：
  /// 1. 从画布中心开始
  /// 2. 沿阿基米德螺旋线向外扫描（r = r + radiusStep, θ = θ + angleStep）
  /// 3. 每个位置检查是否在选定形状内部
  /// 4. 检查是否与已放置的词语重叠
  /// 5. 找到有效位置后返回，否则尝试下一个位置
  /// 6. 最多尝试 500 次
  Offset? _findShapePosition(
    Size size,
    TextPainter painter,
    List<_PlacedWord> placed,
    LayoutAlgorithm shape,
    int localSeed,
  ) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.45;

    // 螺旋布局参数
    double angle = localSeed * 0.1;  // 起始角度（基于种子）
    double r = 0;                     // 起始半径
    const angleStep = 0.3;            // 角度增量
    const radiusStep = 2.0;           // 半径增量
    const maxAttempts = 500;          // 最大尝试次数

    for (int i = 0; i < maxAttempts; i++) {
      Offset testPoint;

      // 根据形状类型判断点是否在形状内
      bool inShape = false;
      switch (shape) {
        case LayoutAlgorithm.circle:
          if (r <= radius) {
            testPoint = Offset(
              center.dx + r * cos(angle),
              center.dy + r * sin(angle),
            );
            inShape = true;
          } else {
            testPoint = center;
          }
          break;
        case LayoutAlgorithm.square:
          final side = radius * 1.6;
          final x = r * cos(angle);
          final y = r * sin(angle);
          if (x.abs() <= side / 2 && y.abs() <= side / 2) {
            testPoint = Offset(center.dx + x, center.dy + y);
            inShape = true;
          } else {
            testPoint = center;
          }
          break;
        case LayoutAlgorithm.diamond:
          final x = r * cos(angle);
          final y = r * sin(angle);
          testPoint = Offset(center.dx + x, center.dy + y);
          inShape = _isInDiamond(testPoint, center, radius * 1.2);
          break;
        case LayoutAlgorithm.triangle:
          final x = r * cos(angle);
          final y = r * sin(angle);
          testPoint = Offset(center.dx + x, center.dy + y);
          inShape = _isInTriangle(testPoint, center, radius * 1.1);
          break;
        case LayoutAlgorithm.triangleRight:
          final x = r * cos(angle);
          final y = r * sin(angle);
          testPoint = Offset(center.dx + x, center.dy + y);
          inShape = _isInTriangleRight(testPoint, center, radius * 1.1);
          break;
        case LayoutAlgorithm.pentagon:
        case LayoutAlgorithm.star:
          if (r <= radius * 1.2) {
            testPoint = Offset(
              center.dx + r * cos(angle),
              center.dy + r * sin(angle),
            );
            inShape = true;
          } else {
            testPoint = center;
          }
          break;
        case LayoutAlgorithm.heart:
          final x = r * cos(angle);
          final y = r * sin(angle);
          testPoint = Offset(center.dx + x, center.dy + y);
          inShape = _isInHeart(testPoint, center, radius * 1.4);
          break;
      }

      // 如果点在形状内，检查是否与已放置的词重叠
      if (inShape) {
        final x = testPoint.dx - painter.width / 2;
        final y = testPoint.dy - painter.height / 2;
        final rect = Rect.fromLTWH(x, y, painter.width, painter.height);

        // 检查位置是否有效（不越界且不重叠）
        if (_isValidPosition(rect, size, placed)) {
          return Offset(x, y);
        }
      }

      // 沿螺旋线继续向外扫描
      angle += angleStep;
      r += radiusStep;
    }

    return null;
  }

  /// 判断点是否在三角形内（尖朝上）
  /// 使用重心坐标法判断点是否在三角形内部
  bool _isInTriangle(Offset point, Offset center, double radius) {
    // 定义等边三角形的三个顶点
    final p1 = Offset(center.dx, center.dy - radius);                      // 顶点（上）
    final p2 = Offset(center.dx - radius * 0.866, center.dy + radius * 0.5); // 左下
    final p3 = Offset(center.dx + radius * 0.866, center.dy + radius * 0.5); // 右下

    // 计算点相对于三条边的位置
    final d1 = _sign(point, p1, p2);
    final d2 = _sign(point, p2, p3);
    final d3 = _sign(point, p3, p1);

    // 如果点在所有边的同一侧，则在三角形内
    final hasNeg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    final hasPos = (d1 > 0) || (d2 > 0) || (d3 > 0);

    return !(hasNeg && hasPos);
  }

  /// 判断点是否在三角形内（尖朝右）
  bool _isInTriangleRight(Offset point, Offset center, double radius) {
    // 定义三角形的三个顶点（尖朝右）
    final p1 = Offset(center.dx + radius, center.dy);                        // 顶点（右）
    final p2 = Offset(center.dx - radius * 0.5, center.dy - radius * 0.866); // 左上
    final p3 = Offset(center.dx - radius * 0.5, center.dy + radius * 0.866); // 左下

    final d1 = _sign(point, p1, p2);
    final d2 = _sign(point, p2, p3);
    final d3 = _sign(point, p3, p1);

    final hasNeg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    final hasPos = (d1 > 0) || (d2 > 0) || (d3 > 0);

    return !(hasNeg && hasPos);
  }

  /// 计算点相对于线段的位置（叉积）
  /// 用于判断点在线段的哪一侧
  double _sign(Offset p1, Offset p2, Offset p3) {
    return (p1.dx - p3.dx) * (p2.dy - p3.dy) - (p2.dx - p3.dx) * (p1.dy - p3.dy);
  }

  /// 判断点是否在菱形内
  /// 使用曼哈顿距离判断
  bool _isInDiamond(Offset point, Offset center, double radius) {
    final dx = (point.dx - center.dx).abs();
    final dy = (point.dy - center.dy).abs();
    // 曼哈顿距离归一化后小于等于 1 则在菱形内
    return (dx / radius + dy / radius) <= 1.0;
  }

  /// 判断点是否在心形内
  /// 使用心形方程：(x² + y² - 1)³ - x²y³ ≤ 0
  bool _isInHeart(Offset point, Offset center, double radius) {
    // 归一化坐标
    final dx = (point.dx - center.dx) / radius;
    final dy = -(point.dy - center.dy) / radius;  // Y 轴翻转

    // 缩放参数，调整心形的宽度和高度
    const scaleX = 1.45;
    const scaleY = 1.45;
    const verticalShift = 0.08;  // 垂直偏移，使心形居中

    final x = dx * scaleX;
    final y = (dy + verticalShift) * scaleY;

    // 心形方程
    final term1 = pow(x * x + y * y - 1, 3);
    final term2 = x * x * y * y * y;

    // 添加容差以增加心形内部区域
    const tolerance = 0.02;
    return term1 - term2 <= tolerance;
  }

  /// 检查位置是否有效
  /// 1. 不能超出画布边界
  /// 2. 不能与已放置的词语重叠
  bool _isValidPosition(Rect rect, Size size, List<_PlacedWord> placed) {
    // 边界检查
    if (rect.left < 0 || rect.top < 0 ||
        rect.right > size.width || rect.bottom > size.height) {
      return false;
    }

    // 碰撞检测：检查是否与已放置的词重叠
    for (final word in placed) {
      if (rect.overlaps(word.rect)) {
        return false;
      }
    }

    return true;
  }

  @override
  bool shouldRepaint(WordCloudPainter oldDelegate) => true;
}
