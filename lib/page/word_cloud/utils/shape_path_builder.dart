import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/word_cloud_state.dart';
import '../models/shape_style.dart';

/// 形状路径构建器
/// 负责生成各种形状的 Path 对象和渐变 Shader
/// 使用缓存机制优化性能
class ShapePathBuilder {
  // Path 缓存
  Path? _cachedPath;
  Size? _cachedSize;
  LayoutAlgorithm? _cachedShape;

  /// 获取形状的 Path（带缓存）
  /// 只有当形状类型或画布尺寸变化时才重新生成
  Path getPath(LayoutAlgorithm shape, Size size) {
    if (_cachedPath != null &&
        _cachedShape == shape &&
        _cachedSize == size) {
      return _cachedPath!;
    }

    final path = _buildPath(shape, size);
    _cachedPath = path;
    _cachedShape = shape;
    _cachedSize = size;
    return path;
  }

  /// 获取渐变 Shader
  /// 根据形状类型选择径向渐变或线性渐变
  Shader getShader(
    LayoutAlgorithm shape,
    Size size,
    ShapeGradientConfig gradient,
  ) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // 圆形和心形使用径向渐变，其他形状使用线性渐变
    if (shape == LayoutAlgorithm.circle || shape == LayoutAlgorithm.heart) {
      return _createRadialGradient(shape, rect, gradient);
    } else {
      return _createLinearGradient(shape, rect, gradient);
    }
  }

  /// 清除缓存
  void clear() {
    _cachedPath = null;
    _cachedSize = null;
    _cachedShape = null;
  }

  /// 构建形状 Path
  Path _buildPath(LayoutAlgorithm shape, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // 使用容器短边的一半减去边距，确保形状不超出边界
    final baseRadius = min(size.width, size.height) / 2 - 8;

    switch (shape) {
      case LayoutAlgorithm.circle:
        return _buildCircle(center, baseRadius);
      case LayoutAlgorithm.heart:
        return _buildHeart(center, baseRadius * 0.95);
      case LayoutAlgorithm.diamond:
        return _buildDiamond(center, baseRadius);
      case LayoutAlgorithm.square:
        return _buildSquare(center, baseRadius * 1.35);
      case LayoutAlgorithm.triangle:
        return _buildTriangle(center, baseRadius);
      case LayoutAlgorithm.triangleRight:
        return _buildTriangleRight(center, baseRadius);
      case LayoutAlgorithm.pentagon:
        return _buildPentagon(center, baseRadius);
    }
  }

  /// 构建圆形 Path
  Path _buildCircle(Offset center, double radius) {
    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  /// 构建心形 Path
  /// 使用心形参数方程
  Path _buildHeart(Offset center, double radius) {
    final path = Path();
    const steps = 100;  // 曲线平滑度
    const scaleX = 1.0;
    const scaleY = 0.9;
    const verticalShift = 0.1;

    bool firstPoint = true;

    for (int i = 0; i <= steps; i++) {
      final t = (i / steps) * 2 * pi;

      // 心形参数方程
      final x = 16 * pow(sin(t), 3);
      final y = 13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t);

      // 归一化并缩放
      final normalizedX = x / 16 * scaleX;
      final normalizedY = -(y / 16 * scaleY + verticalShift);

      final px = center.dx + normalizedX * radius;
      final py = center.dy + normalizedY * radius;

      if (firstPoint) {
        path.moveTo(px, py);
        firstPoint = false;
      } else {
        path.lineTo(px, py);
      }
    }

    path.close();
    return path;
  }

  /// 构建菱形 Path
  Path _buildDiamond(Offset center, double radius) {
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);  // 上
    path.lineTo(center.dx + radius, center.dy);  // 右
    path.lineTo(center.dx, center.dy + radius);  // 下
    path.lineTo(center.dx - radius, center.dy);  // 左
    path.close();
    return path;
  }

  /// 构建方形 Path
  Path _buildSquare(Offset center, double side) {
    final halfSide = side / 2;
    final path = Path();
    path.addRect(Rect.fromLTWH(
      center.dx - halfSide,
      center.dy - halfSide,
      side,
      side,
    ));
    return path;
  }

  /// 构建三角形 Path（尖朝上）
  Path _buildTriangle(Offset center, double radius) {
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);  // 顶点（上）
    path.lineTo(center.dx - radius * 0.866, center.dy + radius * 0.5);  // 左下
    path.lineTo(center.dx + radius * 0.866, center.dy + radius * 0.5);  // 右下
    path.close();
    return path;
  }

  /// 构建三角形 Path（尖朝右）
  Path _buildTriangleRight(Offset center, double radius) {
    final path = Path();
    path.moveTo(center.dx + radius, center.dy);  // 顶点（右）
    path.lineTo(center.dx - radius * 0.5, center.dy - radius * 0.866);  // 左上
    path.lineTo(center.dx - radius * 0.5, center.dy + radius * 0.866);  // 左下
    path.close();
    return path;
  }

  /// 构建正五边形 Path
  /// 使用数学公式计算 5 个顶点
  Path _buildPentagon(Offset center, double radius) {
    final path = Path();

    for (int k = 0; k < 5; k++) {
      final angle = 2 * pi * k / 5 - pi / 2;  // 从顶部开始（-90度）
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (k == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  /// 创建径向渐变 Shader
  /// 用于圆形和心形
  Shader _createRadialGradient(
    LayoutAlgorithm shape,
    Rect bounds,
    ShapeGradientConfig gradient,
  ) {
    final center = bounds.center;
    final radius = min(bounds.width, bounds.height) * 0.5;

    // 心形的中心稍微向上偏移
    final gradientCenter = shape == LayoutAlgorithm.heart
        ? Offset(center.dx, center.dy - radius * 0.1)
        : center;

    return RadialGradient(
      center: Alignment(
        (gradientCenter.dx - bounds.center.dx) / (bounds.width / 2),
        (gradientCenter.dy - bounds.center.dy) / (bounds.height / 2),
      ),
      radius: 0.6,
      colors: gradient.colors,
      stops: gradient.stops,
    ).createShader(bounds);
  }

  /// 创建线性渐变 Shader
  /// 用于方形、三角形、菱形、五边形
  Shader _createLinearGradient(
    LayoutAlgorithm shape,
    Rect bounds,
    ShapeGradientConfig gradient,
  ) {
    // 根据形状类型选择渐变方向
    Alignment begin;
    Alignment end;

    switch (shape) {
      case LayoutAlgorithm.triangleRight:
        begin = Alignment.centerLeft;
        end = Alignment.centerRight;
        break;
      case LayoutAlgorithm.pentagon:
        begin = Alignment.topLeft;
        end = Alignment.bottomRight;
        break;
      default:
        begin = Alignment.topCenter;
        end = Alignment.bottomCenter;
    }

    return LinearGradient(
      begin: begin,
      end: end,
      colors: gradient.colors,
      stops: gradient.stops,
    ).createShader(bounds);
  }
}
