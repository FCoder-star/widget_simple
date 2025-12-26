import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Strategies for handling text overflow within available space.
enum TextOverflowStrategy {
  /// No overflow handling; render at natural size.
  none,

  /// Truncate with ellipsis when text exceeds available width.
  ellipsis,

  /// Scale down font size to fit (respects minFontSize).
  scale,

  /// Scroll text horizontally like a marquee.
  marquee,
}

/// A text widget that displays characters with a wave animation and animated gradient.
///
/// Each character oscillates vertically with a phase offset, creating a wave effect.
/// The text is filled with a gradient that animates over time.
///
/// Example:
/// ```dart
/// WaveGradientText(
///   text: 'Hello World',
///   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
///   amplitude: 8.0,
///   gradientColors: [Colors.blue, Colors.purple, Colors.pink],
/// )
/// ```
class WaveGradientText extends StatefulWidget {
  const WaveGradientText({
    super.key,
    required this.text,
    this.style,
    this.amplitude = 6.0,
    this.charPhase = 0.5,
    this.wavePeriod = const Duration(milliseconds: 1500),
    this.gradientColors,
    this.gradientPeriod = const Duration(milliseconds: 2000),
    this.textAlign = TextAlign.left,
    this.overflowStrategy = TextOverflowStrategy.none,
    this.minFontSize = 12.0,
    this.marqueeSpeed = 40.0,
    this.marqueeGap = 24.0,
  });

  /// The text to display. Must be single-line (no newlines).
  final String text;

  /// Base text style. The foreground color will be overridden by the gradient.
  final TextStyle? style;

  /// Wave amplitude in logical pixels. Default is 6.0.
  final double amplitude;

  /// Phase offset between consecutive characters in radians. Default is 0.5.
  final double charPhase;

  /// Duration for one complete wave cycle. Default is 1500ms.
  final Duration wavePeriod;

  /// Colors for the animated gradient. If null, uses a default blue-purple gradient.
  final List<Color>? gradientColors;

  /// Duration for one complete gradient animation cycle. Default is 2000ms.
  final Duration gradientPeriod;

  /// Horizontal alignment of the text.
  final TextAlign textAlign;

  /// Strategy for handling text overflow.
  final TextOverflowStrategy overflowStrategy;

  /// Minimum font size for the scale strategy.
  final double minFontSize;

  /// Scroll speed in logical pixels per second for marquee strategy.
  final double marqueeSpeed;

  /// Gap between repeated text instances for marquee strategy.
  final double marqueeGap;

  @override
  State<WaveGradientText> createState() => _WaveGradientTextState();
}

class _WaveGradientTextState extends State<WaveGradientText>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _gradientController;
  AnimationController? _marqueeController;
  late Listenable _combinedAnimation;

  // Marquee state
  bool _needsMarquee = false;
  double _marqueeOffset = 0;

  // Cached glyph data to avoid recreating TextPainters every frame
  List<_GlyphInfo>? _cachedGlyphs;
  String? _cachedText;
  TextStyle? _cachedStyle;
  TextDirection? _cachedTextDirection;
  double _cachedBaseline = 0;
  double _cachedTotalWidth = 0;
  double _cachedTextHeight = 0;
  double? _cachedMaxWidth;

  // Cached ellipsis painter for truncation strategy
  TextPainter? _ellipsisPainter;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: widget.wavePeriod,
    )..repeat();

    _gradientController = AnimationController(
      vsync: this,
      duration: widget.gradientPeriod,
    )..repeat();

    _combinedAnimation = Listenable.merge([_waveController, _gradientController]);
  }

  @override
  void didUpdateWidget(covariant WaveGradientText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.wavePeriod != widget.wavePeriod) {
      _waveController.duration = widget.wavePeriod;
      if (!_waveController.isAnimating) _waveController.repeat();
    }

    if (oldWidget.gradientPeriod != widget.gradientPeriod) {
      _gradientController.duration = widget.gradientPeriod;
      if (!_gradientController.isAnimating) _gradientController.repeat();
    }

    // Invalidate cache if text or style changed
    if (oldWidget.text != widget.text || oldWidget.style != widget.style) {
      _invalidateCache();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _gradientController.dispose();
    _marqueeController?.dispose();
    _disposeGlyphs();
    super.dispose();
  }

  void _invalidateCache() {
    _disposeGlyphs();
    _cachedGlyphs = null;
    _cachedText = null;
    _cachedStyle = null;
    _cachedTextDirection = null;
    _cachedMaxWidth = null;
    _ellipsisPainter = null;
  }

  void _disposeGlyphs() {
    // TextPainter is a lightweight object without dispose method
    // Just clear the reference and let GC handle it
    _cachedGlyphs = null;
  }

  List<Color> get _effectiveGradientColors =>
      widget.gradientColors ??
      const [
        Color(0xFF00C6FF),
        Color(0xFF0072FF),
        Color(0xFF7F00FF),
        Color(0xFFE100FF),
      ];

  TextStyle get _effectiveStyle =>
      widget.style ??
      const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      );

  void _buildGlyphCache(
    TextDirection textDirection, {
    double? maxWidth,
    TextStyle? styleOverride,
  }) {
    final style = styleOverride ?? _effectiveStyle;
    final isSameCache = _cachedText == widget.text &&
        _cachedStyle == style &&
        _cachedTextDirection == textDirection &&
        _cachedMaxWidth == maxWidth;

    if (isSameCache && _cachedGlyphs != null) {
      return;
    }

    _disposeGlyphs();

    final clusters = widget.text.characters.toList();
    final glyphs = <_GlyphInfo>[];

    double x = 0;
    double maxAscent = 0;
    double maxDescent = 0;

    // Build ellipsis painter if needed for truncation
    if (maxWidth != null && maxWidth.isFinite) {
      // Always rebuild ellipsis painter to match current style
      _ellipsisPainter = TextPainter(
        text: TextSpan(text: '…', style: style),
        textDirection: textDirection,
        maxLines: 1,
      )..layout();
    }

    final ellipsisWidth = _ellipsisPainter?.width ?? 0;
    final effectiveMaxWidth =
        maxWidth != null && maxWidth.isFinite ? maxWidth - ellipsisWidth : null;

    bool needsEllipsis = false;

    for (final char in clusters) {
      final painter = TextPainter(
        text: TextSpan(text: char, style: style),
        textDirection: textDirection,
        maxLines: 1,
      )..layout();

      final ascent =
          painter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
      final descent = painter.height - ascent;

      // Check if adding this glyph would exceed max width
      if (effectiveMaxWidth != null && (x + painter.width) > effectiveMaxWidth) {
        needsEllipsis = true;
        break;
      }

      maxAscent = math.max(maxAscent, ascent);
      maxDescent = math.max(maxDescent, descent);

      glyphs.add(_GlyphInfo(
        painter: painter,
        ascent: ascent,
        x: x,
      ));

      x += painter.width;
    }

    // Append ellipsis if truncated
    if (needsEllipsis && _ellipsisPainter != null) {
      final ellipsisAscent = _ellipsisPainter!
          .computeDistanceToActualBaseline(TextBaseline.alphabetic);
      final ellipsisDescent = _ellipsisPainter!.height - ellipsisAscent;

      maxAscent = math.max(maxAscent, ellipsisAscent);
      maxDescent = math.max(maxDescent, ellipsisDescent);

      glyphs.add(_GlyphInfo(
        painter: _ellipsisPainter!,
        ascent: ellipsisAscent,
        x: x,
        // ampScale will be set by _applyEdgeAttenuation
      ));

      x += _ellipsisPainter!.width;

      // Apply amplitude attenuation near the right edge
      _applyEdgeAttenuation(glyphs, x);
    }

    _cachedGlyphs = glyphs;
    _cachedText = widget.text;
    _cachedStyle = style;
    _cachedTextDirection = textDirection;
    _cachedMaxWidth = maxWidth;
    _cachedBaseline = maxAscent;
    _cachedTotalWidth = x;
    _cachedTextHeight = maxAscent + maxDescent;
  }

  /// Apply amplitude attenuation to glyphs near the right edge.
  /// Ensures a minimum amplitude for the ellipsis to maintain wave animation.
  void _applyEdgeAttenuation(List<_GlyphInfo> glyphs, double totalWidth) {
    const fadeWidth = 32.0;
    const minEllipsisAmp = 0.6; // Minimum amplitude for ellipsis animation
    final lastIndex = glyphs.length - 1;

    for (int i = 0; i < glyphs.length; i++) {
      final glyph = glyphs[i];
      final glyphRight = glyph.x + glyph.painter.width;
      final distFromEdge = totalWidth - glyphRight;
      final baseAmp = (distFromEdge / fadeWidth).clamp(0.0, 1.0);

      // Ensure ellipsis (last glyph) has minimum amplitude for animation
      if (i == lastIndex) {
        glyph.ampScale = math.max(baseAmp, minEllipsisAmp);
      } else {
        glyph.ampScale = baseAmp;
      }
    }
  }

  Size _computeSize() {
    return Size(
      _cachedTotalWidth,
      _cachedTextHeight + widget.amplitude * 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      !widget.text.contains('\n'),
      'WaveGradientText only supports single-line text.',
    );

    if (widget.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final textDirection = Directionality.of(context);

    // Use LayoutBuilder for overflow strategies that need constraints
    if (widget.overflowStrategy != TextOverflowStrategy.none) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return _buildContent(
            textDirection,
            maxWidth: constraints.maxWidth,
          );
        },
      );
    }

    return _buildContent(textDirection);
  }

  Widget _buildContent(TextDirection textDirection, {double? maxWidth}) {
    // Calculate font scale for scale strategy
    double fontScale = 1.0;
    TextStyle? scaledStyle;

    if (widget.overflowStrategy == TextOverflowStrategy.scale &&
        maxWidth != null &&
        maxWidth.isFinite) {
      final result = _calculateFontScale(textDirection, maxWidth);
      fontScale = result.scale;
      scaledStyle = result.style;
    }

    final effectiveMaxWidth = _getEffectiveMaxWidth(maxWidth);
    _buildGlyphCache(
      textDirection,
      maxWidth: effectiveMaxWidth,
      styleOverride: scaledStyle,
    );

    // Amplitude scales with font
    double effectiveAmplitude = widget.amplitude * fontScale;

    // Check if marquee is needed
    final enableMarquee = widget.overflowStrategy == TextOverflowStrategy.marquee &&
        maxWidth != null &&
        maxWidth.isFinite &&
        _cachedTotalWidth > maxWidth;

    if (enableMarquee) {
      return _buildMarqueeContent(
        textDirection,
        maxWidth,
        effectiveAmplitude,
      );
    } else {
      _stopMarqueeAnimation();
    }

    final size = Size(
      _cachedTotalWidth,
      _cachedTextHeight + effectiveAmplitude * 2,
    );

    return Semantics(
      label: widget.text,
      textDirection: textDirection,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _combinedAnimation,
            builder: (context, _) {
              return CustomPaint(
                size: size,
                painter: _WaveGradientTextPainter(
                  glyphs: _cachedGlyphs!,
                  baseline: _cachedBaseline,
                  totalWidth: _cachedTotalWidth,
                  textHeight: _cachedTextHeight,
                  amplitude: effectiveAmplitude,
                  charPhase: widget.charPhase,
                  waveProgress: _waveController.value,
                  gradientProgress: _gradientController.value,
                  gradientColors: _effectiveGradientColors,
                  textAlign: widget.textAlign,
                ),
                isComplex: true,
                willChange: true,
              );
            },
          ),
        ),
      ),
    );
  }

  /// Calculate font scale factor for scale strategy.
  ({double scale, TextStyle? style}) _calculateFontScale(
    TextDirection textDirection,
    double maxWidth,
  ) {
    final baseStyle = _effectiveStyle;
    final baseFontSize = baseStyle.fontSize ?? 28.0;

    // Measure natural width
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: baseStyle),
      textDirection: textDirection,
      maxLines: 1,
    )..layout();

    final naturalWidth = painter.width;
    if (naturalWidth <= maxWidth) {
      return (scale: 1.0, style: null);
    }

    // Calculate scale factor
    final scaleByWidth = maxWidth / naturalWidth;
    final scaleByMinFont = widget.minFontSize / baseFontSize;
    final scale = math.max(scaleByWidth, scaleByMinFont).clamp(0.0, 1.0);

    final newFontSize = baseFontSize * scale;
    final scaledStyle = baseStyle.copyWith(fontSize: newFontSize);

    return (scale: scale, style: scaledStyle);
  }

  double? _getEffectiveMaxWidth(double? constraintMaxWidth) {
    if (widget.overflowStrategy == TextOverflowStrategy.none) {
      return null;
    }
    if (widget.overflowStrategy == TextOverflowStrategy.ellipsis) {
      return constraintMaxWidth;
    }
    return null;
  }

  /// Build marquee scrolling content.
  Widget _buildMarqueeContent(
    TextDirection textDirection,
    double visibleWidth,
    double baseAmplitude,
  ) {
    // Reduce amplitude during marquee for better legibility
    final amplitude = baseAmplitude * 0.7;
    final segment = _cachedTotalWidth + widget.marqueeGap;

    // Setup animation
    _setupMarqueeAnimation(segment);

    final painterSize = Size(
      _cachedTotalWidth,
      _cachedTextHeight + amplitude * 2,
    );

    return Semantics(
      label: widget.text,
      textDirection: textDirection,
      child: SizedBox(
        width: visibleWidth,
        height: painterSize.height,
        child: _buildMarqueeShaderMask(
          visibleWidth,
          painterSize,
          segment,
          amplitude,
        ),
      ),
    );
  }

  /// Build shader mask for edge fade effect.
  Widget _buildMarqueeShaderMask(
    double visibleWidth,
    Size painterSize,
    double segment,
    double amplitude,
  ) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        final edge = math.min(rect.width * 0.08, 16.0);
        final leftStop = (edge / rect.width).clamp(0.0, 0.5);
        final rightStop = (1.0 - edge / rect.width).clamp(0.5, 1.0);
        return LinearGradient(
          colors: const [
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [0.0, leftStop, rightStop, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          minWidth: 0,
          maxWidth: double.infinity,
          child: AnimatedBuilder(
            animation: _combinedAnimation,
            builder: (context, _) {
              final offset = (_marqueeController?.value ?? 0) * segment;
              return _buildMarqueeRow(painterSize, amplitude, offset);
            },
          ),
        ),
      ),
    );
  }

  /// Build the scrolling row with two copies of text.
  Widget _buildMarqueeRow(Size painterSize, double amplitude, double offset) {
    return Transform.translate(
      offset: Offset(-offset, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMarqueePainter(painterSize, amplitude),
          SizedBox(width: widget.marqueeGap),
          _buildMarqueePainter(painterSize, amplitude),
        ],
      ),
    );
  }

  /// Build a single CustomPaint for marquee.
  Widget _buildMarqueePainter(Size size, double amplitude) {
    return CustomPaint(
      size: size,
      painter: _WaveGradientTextPainter(
        glyphs: _cachedGlyphs!,
        baseline: _cachedBaseline,
        totalWidth: _cachedTotalWidth,
        textHeight: _cachedTextHeight,
        amplitude: amplitude,
        charPhase: widget.charPhase,
        waveProgress: _waveController.value,
        gradientProgress: _gradientController.value,
        gradientColors: _effectiveGradientColors,
        textAlign: TextAlign.left,
      ),
      isComplex: true,
      willChange: true,
    );
  }

  /// Setup marquee animation controller when needed.
  void _setupMarqueeAnimation(double scrollDistance) {
    final speed = widget.marqueeSpeed > 0 ? widget.marqueeSpeed : 40.0;
    final durationMs = (scrollDistance / speed * 1000).round().clamp(1, 60000);

    _marqueeController ??= AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationMs),
    );

    if (_marqueeController!.duration?.inMilliseconds != durationMs) {
      _marqueeController!.duration = Duration(milliseconds: durationMs);
    }

    if (!_marqueeController!.isAnimating) {
      _marqueeController!.repeat();
    }

    // Update combined animation to include marquee
    _combinedAnimation = Listenable.merge([
      _waveController,
      _gradientController,
      _marqueeController!,
    ]);
  }

  /// Stop marquee animation.
  void _stopMarqueeAnimation() {
    if (_marqueeController?.isAnimating ?? false) {
      _marqueeController!.stop();
      _marqueeController!.reset();
    }
  }
}

/// Cached information for a single glyph (grapheme cluster).
class _GlyphInfo {
  _GlyphInfo({
    required this.painter,
    required this.ascent,
    required this.x,
    this.ampScale = 1.0,
  });

  final TextPainter painter;
  final double ascent;
  final double x;

  /// Amplitude scale factor for edge attenuation (0.0 to 1.0).
  double ampScale;
}

/// CustomPainter that renders the wave animation and gradient.
class _WaveGradientTextPainter extends CustomPainter {
  _WaveGradientTextPainter({
    required this.glyphs,
    required this.baseline,
    required this.totalWidth,
    required this.textHeight,
    required this.amplitude,
    required this.charPhase,
    required this.waveProgress,
    required this.gradientProgress,
    required this.gradientColors,
    required this.textAlign,
  });

  final List<_GlyphInfo> glyphs;
  final double baseline;
  final double totalWidth;
  final double textHeight;
  final double amplitude;
  final double charPhase;
  final double waveProgress;
  final double gradientProgress;
  final List<Color> gradientColors;
  final TextAlign textAlign;

  @override
  void paint(Canvas canvas, Size size) {
    if (glyphs.isEmpty) return;

    // Calculate horizontal offset based on text alignment
    final startX = _calculateStartX(size.width);

    // Vertical centering with room for wave amplitude
    final startY = (size.height - textHeight) / 2;

    // Create animated gradient shader
    final shader = _createAnimatedShader(size);

    // Calculate wave phase based on animation progress
    final globalPhase = waveProgress * 2 * math.pi;

    // Single saveLayer for all glyphs - much better performance
    canvas.saveLayer(Offset.zero & size, Paint());

    // Draw all glyphs first
    for (int i = 0; i < glyphs.length; i++) {
      final glyph = glyphs[i];

      // Calculate vertical wave offset for this character
      final waveOffset =
          math.sin(globalPhase + i * charPhase) * amplitude * glyph.ampScale;

      // Position: x from cache, y adjusted for baseline and wave
      final xPos = startX + glyph.x;
      final yPos = startY + (baseline - glyph.ascent) + waveOffset;

      glyph.painter.paint(canvas, Offset(xPos, yPos));
    }

    // Apply gradient to all glyphs at once using srcIn blend
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = shader
        ..blendMode = BlendMode.srcIn,
    );

    canvas.restore();
  }

  double _calculateStartX(double availableWidth) {
    switch (textAlign) {
      case TextAlign.center:
        return (availableWidth - totalWidth) / 2;
      case TextAlign.right:
      case TextAlign.end:
        return availableWidth - totalWidth;
      case TextAlign.left:
      case TextAlign.start:
      case TextAlign.justify:
        return 0;
    }
  }

  Shader _createAnimatedShader(Size size) {
    // Shift the gradient horizontally based on animation progress
    final shiftAmount = size.width * gradientProgress;

    return LinearGradient(
      colors: gradientColors,
      tileMode: TileMode.mirror,
      transform: _GradientTranslate(shiftAmount, 0),
    ).createShader(Offset.zero & size);
  }

  @override
  bool shouldRepaint(covariant _WaveGradientTextPainter oldDelegate) {
    return oldDelegate.waveProgress != waveProgress ||
        oldDelegate.gradientProgress != gradientProgress ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.charPhase != charPhase ||
        oldDelegate.textAlign != textAlign ||
        oldDelegate.totalWidth != totalWidth ||
        oldDelegate.textHeight != textHeight ||
        oldDelegate.baseline != baseline ||
        oldDelegate.glyphs.length != glyphs.length ||
        !identical(oldDelegate.glyphs, glyphs) ||
        !_listEquals(oldDelegate.gradientColors, gradientColors);
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Custom GradientTransform for translating the gradient.
class _GradientTranslate extends GradientTransform {
  const _GradientTranslate(this.dx, this.dy);

  final double dx;
  final double dy;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(dx, dy, 0);
  }
}
