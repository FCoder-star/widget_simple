import 'package:flutter/material.dart';
import 'word_cloud_state.dart';

/// 形状轮廓配置
/// 定义轮廓的颜色和宽度
class ShapeContour {
  final Color color;
  final double width;

  const ShapeContour({
    required this.color,
    this.width = 1.5,
  });
}

/// 形状渐变配置
/// 定义渐变的颜色列表和可选的停止点
class ShapeGradientConfig {
  final List<Color> colors;
  final List<double>? stops;

  const ShapeGradientConfig({
    required this.colors,
    this.stops,
  });
}

/// 形状样式
/// 包含形状类型、轮廓配置、渐变配置和显示开关
class ShapeStyle {
  final LayoutAlgorithm shape;
  final ShapeContour contour;
  final ShapeGradientConfig gradient;
  final bool showContour;

  const ShapeStyle({
    required this.shape,
    required this.contour,
    required this.gradient,
    this.showContour = true,
  });
}
