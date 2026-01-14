import 'dart:math';
import 'package:flutter/material.dart';

/// 词语数据模型
/// 包含词语文本和权重（频率）
class WordItem {
  final String word;   // 词语文本
  final int weight;    // 词语权重，用于决定字体大小

  WordItem(this.word, this.weight);
}

/// 配色方案枚举
/// 定义词云支持的颜色主题
enum ColorSchemeType {
  rainbow,  // 彩虹色：多彩渐变
  blue,     // 蓝色系：蓝色到青色
  warm,     // 暖色系：红色到黄色
  cool,     // 冷色系：青色到蓝色
}

/// 布局算法枚举
/// 定义词云支持的形状布局
enum LayoutAlgorithm {
  circle,         // 圆形布局
  heart,          // 心形布局
  diamond,        // 菱形布局
  square,         // 方形布局
  triangle,       // 三角形布局（尖朝上）
  triangleRight,  // 三角形布局（尖朝右）
  pentagon,       // 五边形布局
  star,           // 星形布局
}

/// 词云状态管理类
/// 管理词云的布局、配色、数据等状态
class WordCloudState extends ChangeNotifier {
  // 当前选择的布局算法
  LayoutAlgorithm _layout = LayoutAlgorithm.circle;

  // 当前选择的配色方案
  ColorSchemeType _colorScheme = ColorSchemeType.rainbow;

  // 随机数生成器，用于生成随机种子
  final Random _random = Random();

  // 获取当前布局
  LayoutAlgorithm get layout => _layout;

  // 获取当前配色方案
  ColorSchemeType get colorScheme => _colorScheme;

  /// 预设的示例词语数据
  /// 包含49个Flutter相关的技术词汇，权重从100到1递减
  final List<WordItem> sampleWords = [
    WordItem('Flutter', 100),
    WordItem('Dart', 95),
    WordItem('Widget', 90),
    WordItem('State', 85),
    WordItem('Build', 80),
    WordItem('Context', 75),
    WordItem('Material', 70),
    WordItem('Scaffold', 68),
    WordItem('Column', 65),
    WordItem('Row', 63),
    WordItem('Container', 60),
    WordItem('Text', 58),
    WordItem('StatefulWidget', 55),
    WordItem('StatelessWidget', 53),
    WordItem('BuildContext', 50),
    WordItem('Animation', 48),
    WordItem('Provider', 46),
    WordItem('Navigator', 44),
    WordItem('Route', 42),
    WordItem('Theme', 40),
    WordItem('Color', 38),
    WordItem('Icon', 36),
    WordItem('Button', 34),
    WordItem('Padding', 32),
    WordItem('Margin', 30),
    WordItem('Align', 28),
    WordItem('Center', 26),
    WordItem('Stack', 24),
    WordItem('Positioned', 22),
    WordItem('ListView', 20),
    WordItem('GridView', 19),
    WordItem('AppBar', 18),
    WordItem('Drawer', 17),
    WordItem('BottomSheet', 16),
    WordItem('Dialog', 15),
    WordItem('SnackBar', 14),
    WordItem('TextField', 13),
    WordItem('Form', 12),
    WordItem('Gesture', 11),
    WordItem('InkWell', 10),
    WordItem('Hero', 9),
    WordItem('Opacity', 8),
    WordItem('Transform', 7),
    WordItem('ClipRRect', 6),
    WordItem('CustomPaint', 5),
    WordItem('Canvas', 4),
    WordItem('Paint', 3),
    WordItem('Path', 2),
    WordItem('Curve', 1),
  ];

  /// 设置布局算法
  /// 切换词云的形状布局并通知监听者重新绘制
  void setLayout(LayoutAlgorithm newLayout) {
    _layout = newLayout;
    notifyListeners();
  }

  /// 设置配色方案
  /// 切换词云的颜色主题并通知监听者重新绘制
  void setColorScheme(ColorSchemeType newScheme) {
    _colorScheme = newScheme;
    notifyListeners();
  }

  /// 重新生成词云
  /// 触发重新布局，产生不同的随机排列效果
  void regenerate() {
    notifyListeners();
  }

  /// 根据权重计算字体大小
  ///
  /// [weight] 当前词语的权重
  /// [maxWeight] 所有词语中的最大权重
  ///
  /// 返回值范围：10-38px
  /// 权重越高，字体越大
  double getFontSize(int weight, int maxWeight) {
    return 10 + (weight / maxWeight) * 28;
  }

  /// 根据索引和配色方案获取颜色
  ///
  /// [index] 词语在列表中的索引
  ///
  /// 使用HSV颜色空间生成不同的颜色：
  /// - rainbow: 彩虹色，色相每30度变化
  /// - blue: 蓝色系，色相在200-260度之间
  /// - warm: 暖色系，色相在0-60度之间（红到黄）
  /// - cool: 冷色系，色相在180-300度之间（青到蓝）
  Color getColor(int index) {
    switch (_colorScheme) {
      case ColorSchemeType.rainbow:
        return HSVColor.fromAHSV(1, (index * 30.0) % 360, 0.8, 0.9).toColor();
      case ColorSchemeType.blue:
        return HSVColor.fromAHSV(1, 200 + (index * 10.0) % 60, 0.7, 0.85).toColor();
      case ColorSchemeType.warm:
        return HSVColor.fromAHSV(1, (index * 15.0) % 60, 0.8, 0.9).toColor();
      case ColorSchemeType.cool:
        return HSVColor.fromAHSV(1, 180 + (index * 15.0) % 120, 0.7, 0.85).toColor();
    }
  }

  /// 获取随机种子
  /// 用于生成不同的布局效果
  int get randomSeed => _random.nextInt(10000);
}
