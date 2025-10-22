import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class SeekBarWidget extends StatefulWidget {
  final Function()? onDragStart;
  final Function(double value)? onDragEnd;
  final Function()? onDragUpdate;
  final Function(double value) onChange;
  final double value;
  final bool isDark;

  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double barPadding;
  final double barHeight;
  final double thumbSize;
  final double height;
  final Color backgroundColor;
  final Color thumbColor;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final Color paddingColor;
  final String? leftIconAsset;
  final String? rightIconAsset;
  final double? iconSize;
  final double? iconPadding;
  final bool drawIcons;
  final bool drawThumb;
  final bool showBlur;

  const SeekBarWidget(
      {super.key,
      this.onDragStart,
      this.onDragEnd,
      this.isDark = false,
      this.onDragUpdate,
      required this.value,
      required this.onChange,
      this.borderColor = Colors.transparent,
      this.borderWidth = 2.0,
      this.borderRadius = 16.0,
      this.barPadding = 0,
      this.barHeight = 15.0,
      this.thumbSize = 26.0,
      this.height = 26.0,
      this.backgroundColor = Colors.greenAccent,
      this.thumbColor = Colors.white,
      this.gradientStartColor = Colors.white,
      this.gradientEndColor = Colors.black,
      this.paddingColor = Colors.transparent,
      this.leftIconAsset,
      this.rightIconAsset,
      this.iconSize,
      this.iconPadding,
      this.drawIcons = false,
      this.drawThumb = true,
      this.showBlur = false});

  @override
  State<SeekBarWidget> createState() {
    return _SeekBarState();
  }
}

class _SeekBarState extends State<SeekBarWidget> {
  double _value = 0;

  ui.Image? _leftImage;
  ui.Image? _rightImage;
  bool _imagesLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!widget.value.isNaN) {
      _value = widget.value;
    }
    if (widget.drawIcons &&
        (widget.leftIconAsset ?? "").isNotEmpty &&
        (widget.rightIconAsset ?? "").isNotEmpty) {
      _loadImages().then((value) {
        if (mounted) setState(() => _imagesLoaded = true);
      });
    }
  }

  Future<void> _loadImages() async {
    final oldLeft = _leftImage;
    final oldRight = _rightImage;
    _leftImage = null;
    _rightImage = null;
    oldLeft?.dispose();
    oldRight?.dispose();

    try {
      if (widget.leftIconAsset?.isNotEmpty ?? false) {
        _leftImage = await _loadImage(widget.leftIconAsset!);
        if (_leftImage!.width == 0 || _leftImage!.height == 0) {
          throw Exception('Left image has invalid dimensions');
        }
      }
      if (widget.rightIconAsset?.isNotEmpty ?? false) {
        _rightImage = await _loadImage(widget.rightIconAsset!);
        if (_rightImage!.width == 0 || _rightImage!.height == 0) {
          throw Exception('Right image has invalid dimensions');
        }
      }
    } catch (e) {
      _leftImage = oldLeft;
      _rightImage = oldRight;
    }

    if (mounted) setState(() {});
  }

  Future<ui.Image> _loadImage(String asset) async {
    final ByteData data = await rootBundle.load(asset);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  void didUpdateWidget(covariant SeekBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.value.isNaN) {
      _value = widget.value;
    }
    if (widget.leftIconAsset != oldWidget.leftIconAsset ||
        widget.rightIconAsset != oldWidget.rightIconAsset) {
      _loadImages();
    }
  }

  void seekToRelativePosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    final Offset tapPos = box.globalToLocal(globalPosition);
    print("tapPs-----${tapPos.dx}");
    // Map touch X to the thumb-center range used by the painter so the
    // thumb can reach the visual ends regardless of its size.
    final double width = box.size.width;
    final double leftPadding = widget.barPadding;
    final double rightPadding = widget.barPadding;

    final double halfThumb = widget.drawThumb ? widget.thumbSize / 2 : 0.0;
    final double minCenterX = leftPadding + halfThumb;
    final double maxCenterX = width - rightPadding - halfThumb;

    double relative;
    if (maxCenterX <= minCenterX) {
      // Fallback when available width is too small.
      relative = 0.0;
    } else {
      relative = (tapPos.dx - minCenterX) / (maxCenterX - minCenterX);
      if (relative.isNaN) relative = 0.0;
      relative = relative.clamp(0.0, 1.0) as double;
    }

    _value = relative;
    widget.onChange.call(_value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.drawIcons
        ? (_leftImage != null && _rightImage != null
            ? buildLayoutBuilder()
            : Container())
        : buildLayoutBuilder();
  }

  LayoutBuilder buildLayoutBuilder() {
    return LayoutBuilder(
      builder: (context, size) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: widget.height,
            width: size.maxWidth,
            child: CustomPaint(
              willChange: !_imagesLoaded,
              painter: _ProgressBarPainter(
                  value: _value,
                  borderColor: widget.borderColor,
                  borderWidth: widget.borderWidth,
                  borderRadius: widget.borderRadius,
                  barPadding: widget.barPadding,
                  barHeight: widget.barHeight,
                  thumbSize: widget.thumbSize,
                  thumbColor: widget.thumbColor,
                  backgroundColor: widget.backgroundColor,
                  gradientStartColor: widget.gradientStartColor,
                  gradientEndColor: widget.gradientEndColor,
                  paddingColor: widget.paddingColor,
                  leftImage: _leftImage,
                  rightImage: _rightImage,
                  iconPadding: widget.iconPadding,
                  iconSize: widget.iconSize,
                  drawIcons: widget.drawIcons,
                  drawThumb: widget.drawThumb,
                  showBlur: widget.showBlur),
            ),
          ),
          onHorizontalDragStart: (DragStartDetails details) {
            widget.onDragStart?.call();
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            seekToRelativePosition(details.globalPosition);
            widget.onDragUpdate?.call();
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            widget.onDragEnd?.call(_value);
          },
          onTapDown: (TapDownDetails details) {
            seekToRelativePosition(details.globalPosition);
          },
        );
      },
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final Color backgroundColor;
  final double value;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double barPadding;
  final double barHeight;
  final double thumbSize;
  final Color thumbColor;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final Color paddingColor;

  final double? iconSize;
  final double? iconPadding;
  final bool drawIcons;
  final bool drawThumb;
  final bool showBlur;

  final ui.Image? leftImage;
  final ui.Image? rightImage;

  _ProgressBarPainter({
    required this.value,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.barPadding,
    required this.barHeight,
    required this.thumbSize,
    required this.backgroundColor,
    required this.thumbColor,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.paddingColor,
    this.leftImage,
    this.rightImage,
    this.iconSize,
    this.iconPadding,
    this.drawIcons = false,
    this.drawThumb = true,
    this.showBlur = false,
  });

  @override
  bool shouldRepaint(_ProgressBarPainter oldDelegate) {
    return value != oldDelegate.value ||
        borderColor != oldDelegate.borderColor ||
        borderWidth != oldDelegate.borderWidth ||
        borderRadius != oldDelegate.borderRadius ||
        barPadding != oldDelegate.barPadding ||
        barHeight != oldDelegate.barHeight ||
        thumbSize != oldDelegate.thumbSize ||
        thumbColor != oldDelegate.thumbColor ||
        gradientStartColor != oldDelegate.gradientStartColor ||
        gradientEndColor != oldDelegate.gradientEndColor ||
        paddingColor != oldDelegate.paddingColor ||
        leftImage != oldDelegate.leftImage ||
        rightImage != oldDelegate.rightImage ||
        iconSize != oldDelegate.iconSize ||
        iconPadding != oldDelegate.iconPadding;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final RRect borderRRect = RRect.fromRectAndRadius(
      Rect.fromPoints(const Offset(0.0, 0.0), Offset(size.width, size.height)),
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(borderRRect, borderPaint);

    final double leftPadding = barPadding;
    final double rightPadding = barPadding;

    Paint paddingPaint = Paint()
      ..color = paddingColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height - barHeight - 2 * borderWidth;

    final Rect paddingRect = Rect.fromPoints(
      Offset(borderWidth, borderWidth),
      Offset(size.width - borderWidth, size.height - borderWidth),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(paddingRect, Radius.circular(barHeight)),
      paddingPaint,
    );

    Paint progressPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final Rect backgroundRect = Rect.fromPoints(
      Offset(leftPadding, (size.height - barHeight) / 2),
      Offset(size.width - rightPadding, (size.height + barHeight) / 2),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(backgroundRect, Radius.circular(barHeight)),
      progressPaint,
    );

    // Compute usable width for the thumb center and progress so the thumb's
    // center ranges from (leftPadding + halfThumb) to
    // (size.width - rightPadding - halfThumb). This makes dragging consistent
    // with the visual representation when the thumb is large.
    final double halfThumb = drawThumb ? thumbSize / 2 : 0.0;
    final double usableWidth = (size.width -
            leftPadding -
            rightPadding -
            (drawThumb ? thumbSize : 0.0))
        .clamp(0.0, double.infinity);
    final double clampedValue = (value.isFinite) ? value.clamp(0.0, 1.0) : 0.0;
    final double playedPart =
        usableWidth <= 0 ? halfThumb : (clampedValue * usableWidth + halfThumb);
    final Rect progressRect = Rect.fromPoints(
      Offset(leftPadding, (size.height - barHeight) / 2),
      Offset(leftPadding + playedPart, (size.height + barHeight) / 2),
    );

    progressPaint.shader = LinearGradient(
      colors: [gradientStartColor, gradientEndColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(progressRect);

    final RRect adjustedProgressRRect = RRect.fromLTRBAndCorners(
      progressRect.left,
      progressRect.top,
      progressRect.right,
      progressRect.bottom,
      topLeft: Radius.circular(barHeight),
      topRight: Radius.circular(drawThumb ? 0 : barHeight),
      bottomLeft: Radius.circular(barHeight),
      bottomRight: Radius.circular(drawThumb ? 0 : barHeight),
    );

    canvas.drawRRect(adjustedProgressRRect, progressPaint);

    Offset center = Offset(leftPadding + playedPart, size.height / 2);
    Paint shadowPaint;
    if (drawThumb) {
      if (showBlur) {
        shadowPaint = Paint()
          ..color = thumbColor // 设置阴影颜色和透明度
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1); // 设置模糊效果
      } else {
        shadowPaint = Paint()..color = thumbColor;
      }
      canvas.drawCircle(center, thumbSize / 2, shadowPaint);
    }

    if (drawIcons) {
      if (leftImage != null) {
        _drawImage(
          canvas,
          leftImage!,
          Offset(iconPadding! / 2, size.height / 2 - iconSize! / 2),
          iconSize!,
        );
      }

      if (rightImage != null) {
        _drawImage(
          canvas,
          rightImage!,
          Offset(size.width - iconPadding! / 2 - iconSize!,
              size.height / 2 - iconSize! / 2),
          iconSize!,
        );
      }
    }

    // canvas.drawImageRect(image!, srcRect, Rect.fromCenter(center: center, width: thumbSize, height: thumbSize), thumbPaint);
  }

  void _drawImage(Canvas canvas, ui.Image image, Offset offset, double size) {
    if (image.width == 0 || image.height == 0) {
      return;
    }

    if (image.width == 0 || image.height == 0) {
      return;
    }

    if (size <= 0 || offset.dx.isNaN || offset.dy.isNaN) {
      return;
    }
    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(offset.dx, offset.dy, size, size);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }
}
