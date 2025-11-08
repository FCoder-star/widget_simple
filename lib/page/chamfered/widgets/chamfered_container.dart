import 'dart:math' as math;

import 'package:flutter/material.dart';

/// ChamferedContainer - 切角容器组件
///
/// Version: 2.0.0
/// Author: Flutter Feature Examples
/// Created: 2025-11-08
/// Updated: 2025-11-08 (v2.0.0)
///
/// 功能特性:
/// - 支持四个角独立设置切角尺寸
/// - 每个切角可独立设置宽度和高度（矩形切角）
/// - v2.0.0: 支持圆弧过渡，平滑连接切角与边缘
/// - v2.0.0: 无切角的角支持设置圆角（类似BorderRadius）
/// - 支持纯色和渐变背景
/// - 支持边框样式
/// - 支持自定义尺寸和内边距

/// 切角尺寸 - 定义切角的宽度、高度和圆弧/圆角半径
///
/// 用法：
/// 1. 切角 + 圆弧过渡：width > 0 或 height > 0，且 radius > 0
/// 2. 普通切角：width > 0 或 height > 0，且 radius = 0
/// 3. 圆角：width = 0 且 height = 0，但 radius > 0
/// 4. 直角：width = 0 且 height = 0，且 radius = 0
class ChamferSize {
  const ChamferSize({this.width = 0, this.height = 0, this.radius = 0});

  final double width;
  final double height;

  /// 当有切角时（width>0或height>0）：圆弧过渡的偏移量N
  /// 当无切角时（width=0且height=0）：普通圆角的半径
  final double radius;

  /// 快捷创建正方形切角
  const ChamferSize.all(double size, {this.radius = 0})
    : width = size,
      height = size;

  /// 零切角
  static const ChamferSize zero = ChamferSize(width: 0, height: 0, radius: 0);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChamferSize &&
        other.width == width &&
        other.height == height &&
        other.radius == radius;
  }

  @override
  int get hashCode => Object.hash(width, height, radius);
}

/// 切角容器 - 支持四个角独立设置切角宽高
class ChamferedContainer extends StatelessWidget {
  const ChamferedContainer({
    super.key,
    required this.child,
    this.color,
    this.gradient,
    this.topLeftChamfer = ChamferSize.zero,
    this.topRightChamfer = ChamferSize.zero,
    this.bottomLeftChamfer = ChamferSize.zero,
    this.bottomRightChamfer = ChamferSize.zero,
    this.borderColor,
    this.borderWidth = 0,
    this.width,
    this.height,
    this.padding,
  });

  final Widget child;
  final Color? color;
  final Gradient? gradient;
  final ChamferSize topLeftChamfer;
  final ChamferSize topRightChamfer;
  final ChamferSize bottomLeftChamfer;
  final ChamferSize bottomRightChamfer;
  final Color? borderColor;
  final double borderWidth;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChamferedPainter(
        color: color ?? Colors.transparent,
        gradient: gradient,
        topLeftChamfer: topLeftChamfer,
        topRightChamfer: topRightChamfer,
        bottomLeftChamfer: bottomLeftChamfer,
        bottomRightChamfer: bottomRightChamfer,
        borderColor: borderColor,
        borderWidth: borderWidth,
      ),
      child: ClipPath(
        clipper: _ChamferedClipper(
          topLeftChamfer: topLeftChamfer,
          topRightChamfer: topRightChamfer,
          bottomLeftChamfer: bottomLeftChamfer,
          bottomRightChamfer: bottomRightChamfer,
        ),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// 切角路径裁剪器
class _ChamferedClipper extends CustomClipper<Path> {
  const _ChamferedClipper({
    required this.topLeftChamfer,
    required this.topRightChamfer,
    required this.bottomLeftChamfer,
    required this.bottomRightChamfer,
  });

  final ChamferSize topLeftChamfer;
  final ChamferSize topRightChamfer;
  final ChamferSize bottomLeftChamfer;
  final ChamferSize bottomRightChamfer;

  @override
  Path getClip(Size size) {
    return _createChamferedPath(
      size,
      topLeftChamfer,
      topRightChamfer,
      bottomLeftChamfer,
      bottomRightChamfer,
    );
  }

  @override
  bool shouldReclip(covariant _ChamferedClipper oldClipper) {
    return oldClipper.topLeftChamfer != topLeftChamfer ||
        oldClipper.topRightChamfer != topRightChamfer ||
        oldClipper.bottomLeftChamfer != bottomLeftChamfer ||
        oldClipper.bottomRightChamfer != bottomRightChamfer;
  }
}

/// 切角绘制器
class _ChamferedPainter extends CustomPainter {
  const _ChamferedPainter({
    required this.color,
    this.gradient,
    required this.topLeftChamfer,
    required this.topRightChamfer,
    required this.bottomLeftChamfer,
    required this.bottomRightChamfer,
    this.borderColor,
    this.borderWidth = 0,
  });

  final Color color;
  final Gradient? gradient;
  final ChamferSize topLeftChamfer;
  final ChamferSize topRightChamfer;
  final ChamferSize bottomLeftChamfer;
  final ChamferSize bottomRightChamfer;
  final Color? borderColor;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _createChamferedPath(
      size,
      topLeftChamfer,
      topRightChamfer,
      bottomLeftChamfer,
      bottomRightChamfer,
    );

    // 绘制填充
    final fillPaint = Paint()..style = PaintingStyle.fill;

    if (gradient != null) {
      fillPaint.shader = gradient!.createShader(Offset.zero & size);
    } else {
      fillPaint.color = color;
    }

    canvas.drawPath(path, fillPaint);

    // 绘制边框
    if (borderColor != null && borderWidth > 0) {
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = borderColor!
        ..strokeWidth = borderWidth;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChamferedPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.gradient != gradient ||
        oldDelegate.topLeftChamfer != topLeftChamfer ||
        oldDelegate.topRightChamfer != topRightChamfer ||
        oldDelegate.bottomLeftChamfer != bottomLeftChamfer ||
        oldDelegate.bottomRightChamfer != bottomRightChamfer ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}

/// 创建切角路径（v2.0.0 支持圆弧过渡 + 圆角）
Path _createChamferedPath(
  Size size,
  ChamferSize topLeftChamfer,
  ChamferSize topRightChamfer,
  ChamferSize bottomLeftChamfer,
  ChamferSize bottomRightChamfer,
) {
  final path = Path();

  // 左上角
  final tlW = topLeftChamfer.width;
  final tlH = topLeftChamfer.height;
  final tlN = topLeftChamfer.radius;

  if (tlW > 0 || tlH > 0) {
    // 有切角
    if (tlN > 0) {
      // 切角 + 圆弧过渡
      final l = math.sqrt(tlW * tlW + tlH * tlH);
      path.moveTo(tlW + tlN, 0);

      final d6 = Offset(tlW - tlN * tlW / l, tlN * tlH / l);
      final d2Radius = tlN * (tlW + l) / tlH;
      path.arcToPoint(d6, radius: Radius.circular(d2Radius), clockwise: false);

      final d4 = Offset(tlN * tlW / l, tlH - tlN * tlH / l);
      path.lineTo(d4.dx, d4.dy);

      final d3 = Offset(0, tlH + tlN);
      final d1Radius = tlN * (l + tlH) / tlW;
      path.arcToPoint(d3, radius: Radius.circular(d1Radius), clockwise: false);
    } else {
      // 普通切角
      path.moveTo(tlW, 0);
      path.lineTo(0, tlH);
    }
  } else if (tlN > 0) {
    // 无切角但有圆角
    path.moveTo(tlN, 0);
    path.arcToPoint(
      Offset(0, tlN),
      radius: Radius.circular(tlN),
      clockwise: false,
    );
  } else {
    // 直角
    path.moveTo(0, 0);
  }

  // 左边到左下角
  final blW = bottomLeftChamfer.width;
  final blH = bottomLeftChamfer.height;
  final blN = bottomLeftChamfer.radius;

  if (blW > 0 || blH > 0) {
    // 下一个角有切角
    if (blN > 0) {
      path.lineTo(0, size.height - blH - blN);
    } else {
      path.lineTo(0, size.height - blH);
    }
  } else if (blN > 0) {
    // 下一个角是圆角
    path.lineTo(0, size.height - blN);
  } else {
    // 下一个角是直角
    path.lineTo(0, size.height);
  }

  // 左下角
  if (blW > 0 || blH > 0) {
    // 有切角
    if (blN > 0) {
      // 切角 + 圆弧过渡
      final l = math.sqrt(blW * blW + blH * blH);

      final d4 = Offset(blN * blW / l, size.height - blH + blN * blH / l);
      final d1Radius = blN * (l + blH) / blW;
      path.arcToPoint(d4, radius: Radius.circular(d1Radius), clockwise: false);

      final d6 = Offset(blW - blN * blW / l, size.height - blN * blH / l);
      path.lineTo(d6.dx, d6.dy);

      final d5 = Offset(blW + blN, size.height);
      final d2Radius = blN * (blW + l) / blH;
      path.arcToPoint(d5, radius: Radius.circular(d2Radius), clockwise: false);
    } else {
      // 普通切角
      path.lineTo(blW, size.height);
    }
  } else if (blN > 0) {
    // 无切角但有圆角
    path.arcToPoint(
      Offset(blN, size.height),
      radius: Radius.circular(blN),
      clockwise: false,
    );
  }

  // 底边到右下角
  final brW = bottomRightChamfer.width;
  final brH = bottomRightChamfer.height;
  final brN = bottomRightChamfer.radius;

  if (brW > 0 || brH > 0) {
    // 下一个角有切角
    if (brN > 0) {
      path.lineTo(size.width - brW - brN, size.height);
    } else {
      path.lineTo(size.width - brW, size.height);
    }
  } else if (brN > 0) {
    // 下一个角是圆角
    path.lineTo(size.width - brN, size.height);
  } else {
    // 下一个角是直角
    path.lineTo(size.width, size.height);
  }

  // 右下角
  if (brW > 0 || brH > 0) {
    // 有切角
    if (brN > 0) {
      // 切角 + 圆弧过渡
      final l = math.sqrt(brW * brW + brH * brH);

      final d6 = Offset(
        size.width - brW + brN * brW / l,
        size.height - brN * brH / l,
      );
      final d2Radius = brN * (brW + l) / brH;
      path.arcToPoint(d6, radius: Radius.circular(d2Radius), clockwise: false);

      final d4 = Offset(
        size.width - brN * brW / l,
        size.height - brH + brN * brH / l,
      );
      path.lineTo(d4.dx, d4.dy);

      final d3 = Offset(size.width, size.height - brH - brN);
      final d1Radius = brN * (l + brH) / brW;
      path.arcToPoint(d3, radius: Radius.circular(d1Radius), clockwise: false);
    } else {
      // 普通切角
      path.lineTo(size.width, size.height - brH);
    }
  } else if (brN > 0) {
    // 无切角但有圆角
    path.arcToPoint(
      Offset(size.width, size.height - brN),
      radius: Radius.circular(brN),
      clockwise: false,
    );
  }

  // 右边到右上角
  final trW = topRightChamfer.width;
  final trH = topRightChamfer.height;
  final trN = topRightChamfer.radius;

  if (trW > 0 || trH > 0) {
    // 下一个角有切角
    if (trN > 0) {
      path.lineTo(size.width, trH + trN);
    } else {
      path.lineTo(size.width, trH);
    }
  } else if (trN > 0) {
    // 下一个角是圆角
    path.lineTo(size.width, trN);
  } else {
    // 下一个角是直角
    path.lineTo(size.width, 0);
  }

  // 右上角
  if (trW > 0 || trH > 0) {
    // 有切角
    if (trN > 0) {
      // 切角 + 圆弧过渡
      final l = math.sqrt(trW * trW + trH * trH);

      final d4 = Offset(size.width - trN * trW / l, trH - trN * trH / l);
      final d1Radius = trN * (l + trH) / trW;
      path.arcToPoint(d4, radius: Radius.circular(d1Radius), clockwise: false);

      final d6 = Offset(size.width - trW + trN * trW / l, trN * trH / l);
      path.lineTo(d6.dx, d6.dy);

      final d5 = Offset(size.width - trW - trN, 0);
      final d2Radius = trN * (trW + l) / trH;
      path.arcToPoint(d5, radius: Radius.circular(d2Radius), clockwise: false);
    } else {
      // 普通切角
      path.lineTo(size.width - trW, 0);
    }
  } else if (trN > 0) {
    // 无切角但有圆角
    path.arcToPoint(
      Offset(size.width - trN, 0),
      radius: Radius.circular(trN),
      clockwise: false,
    );
  }

  // 顶边回到起点
  if (tlW > 0 || tlH > 0) {
    // 左上角有切角
    if (tlN > 0) {
      path.lineTo(tlW + tlN, 0);
    } else {
      path.lineTo(tlW, 0);
    }
  } else if (tlN > 0) {
    // 左上角是圆角
    path.lineTo(tlN, 0);
  }

  path.close();
  return path;
}
