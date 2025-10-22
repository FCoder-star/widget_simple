import 'package:flutter/material.dart';

class GradientProgressLabel extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final InlineSpan textSpan;
  final TextStyle textStyle;
  final List<Color> gradientColors;
  final Color foregroundTextColor; // 渐变区域内文字颜色
  final Color backgroundTextColor; // 非渐变区域文字颜色
  final double borderRadius;
  final Color backgroundColor;
  final EdgeInsets padding;
  final VoidCallback? onTap; // 点击事件回调

  const GradientProgressLabel({
    super.key,
    required this.progress,
    required this.textSpan,
    this.textStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    this.gradientColors = const [Color(0xFFEC008C), Color(0xFF673AB7)],
    required this.foregroundTextColor,
    required this.backgroundTextColor,
    this.borderRadius = 20.0,
    this.backgroundColor = const Color(0xFFECECEC),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.onTap,
  });

  /// 从字符串创建 GradientProgressLabel 的便捷构造函数，保持向后兼容
  GradientProgressLabel.string({
    Key? key,
    required double progress,
    required String text,
    TextStyle textStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    List<Color> gradientColors = const [Color(0xFFEC008C), Color(0xFF673AB7)],
    required Color foregroundTextColor,
    required Color backgroundTextColor,
    double borderRadius = 20.0,
    Color backgroundColor = const Color(0xFFECECEC),
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
    VoidCallback? onTap,
  }) : this(
         key: key,
         progress: progress,
         textSpan: TextSpan(text: text, style: textStyle),
         textStyle: textStyle,
         gradientColors: gradientColors,
         foregroundTextColor: foregroundTextColor,
         backgroundTextColor: backgroundTextColor,
         borderRadius: borderRadius,
         backgroundColor: backgroundColor,
         padding: padding,
         onTap: onTap,
       );

  @override
  Widget build(BuildContext context) {
    // 创建一个临时的 TextPainter 来测量纯文本宽度（不包含 WidgetSpan）
    // 这样可以避免在测量时 WidgetSpan 尺寸未确定的问题
    final tp = TextPainter(
      text: _getTextSpanWithoutWidgets(textSpan),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    final textWidth = tp.width;
    final textHeight = tp.height;
    final double totalWidth = textWidth + padding.horizontal + 24;
    final double totalHeight = textHeight + padding.vertical;

    final pct = progress.clamp(0.0, 1.0);
    final double gradientWidth = totalWidth * pct;

    // 创建核心组件
    final container = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: totalWidth,
        height: totalHeight,
        color: backgroundColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 渐变区域
            if (pct > 0)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: gradientWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradientColors),
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(borderRadius),
                      right: Radius.circular(pct >= 1 ? borderRadius : 0),
                    ),
                  ),
                ),
              ),

            // 背景文字
            Align(
              alignment: Alignment.center,
              child: Text.rich(
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
                textAlign: TextAlign.center,
                _updateWidgetSpanColors(textSpan, backgroundTextColor),
                style: textStyle.copyWith(color: backgroundTextColor),
              ),
            ),

            // 前景文字（只显示在渐变区域）
            if (pct > 0)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRect(
                    clipper: _TextClipper(width: gradientWidth),
                    child: SizedBox(
                      width: totalWidth,
                      child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text.rich(
                            textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                              applyHeightToLastDescent: false,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                            textAlign: TextAlign.center,
                            _updateWidgetSpanColors(
                              textSpan,
                              foregroundTextColor,
                            ),
                            style: textStyle.copyWith(
                              color: foregroundTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    // 如果有点击事件，则包装在 GestureDetector 中
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }

    return container;
  }

  /// 创建一个不包含 WidgetSpan 的 TextSpan，用于测量文本尺寸
  TextSpan _getTextSpanWithoutWidgets(InlineSpan span) {
    if (span is TextSpan) {
      List<InlineSpan>? newChildren;
      if (span.children != null) {
        newChildren = span.children!.map((child) {
          if (child is WidgetSpan) {
            // 将 WidgetSpan 替换为占位文本，以估算尺寸
            return TextSpan(
              text: '\uFFFC', // 对象替换字符，用于占位
              style: child.style ?? textStyle,
            );
          } else if (child is TextSpan) {
            return _getTextSpanWithoutWidgets(child);
          }
          return child;
        }).toList();
      }

      return TextSpan(
        text: span.text,
        style: span.style,
        recognizer: span.recognizer,
        children: newChildren,
      );
    }
    return const TextSpan(text: '');
  }

  /// 更新 WidgetSpan 中的颜色以匹配前景色或背景色
  InlineSpan _updateWidgetSpanColors(InlineSpan span, Color color) {
    if (span is TextSpan) {
      List<InlineSpan>? newChildren;
      if (span.children != null) {
        newChildren = span.children!.map((child) {
          if (child is WidgetSpan) {
            final widget = child.child;

            // 处理 Icon
            if (widget is Icon) {
              return WidgetSpan(
                child: Icon(
                  widget.icon,
                  size: widget.size,
                  color: color,
                  semanticLabel: widget.semanticLabel,
                  textDirection: widget.textDirection,
                ),
                alignment: PlaceholderAlignment.middle, // 👈 垂直居中
              );
            }

            // 处理 Image.asset（或其他 Image）
            // 处理 Image（包括 Image.asset, Image.network 等）
            if (widget is Image) {
              return WidgetSpan(
                child: Image(
                  image: widget.image,
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit,
                  // 👇 关键：应用颜色和混合模式
                  color: color,
                  colorBlendMode: BlendMode.srcIn, // 保留透明度，只着色非透明部分
                  semanticLabel: widget.semanticLabel,
                  excludeFromSemantics: widget.excludeFromSemantics,
                  frameBuilder: widget.frameBuilder,
                  loadingBuilder: widget.loadingBuilder,
                  errorBuilder: widget.errorBuilder,
                  repeat: widget.repeat,
                  centerSlice: widget.centerSlice,
                  matchTextDirection: widget.matchTextDirection,
                  gaplessPlayback: widget.gaplessPlayback,
                  isAntiAlias: widget.isAntiAlias,
                  filterQuality: widget.filterQuality,
                ),
                alignment: PlaceholderAlignment.middle, // 保持垂直居中
              );
            }

            // 其他 WidgetSpan 保持原样（但建议也加 alignment）
            return WidgetSpan(
              child: widget,
              alignment: PlaceholderAlignment.middle,
            );
          } else if (child is TextSpan) {
            return _updateWidgetSpanColors(child, color);
          }
          return child;
        }).toList();
      }

      return TextSpan(
        text: span.text,
        style: span.style,
        recognizer: span.recognizer,
        children: newChildren,
      );
    }
    return span;
  }
}

class _TextClipper extends CustomClipper<Rect> {
  final double width;

  _TextClipper({required this.width});

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, width, size.height);

  @override
  bool shouldReclip(_TextClipper oldClipper) => width != oldClipper.width;
}
