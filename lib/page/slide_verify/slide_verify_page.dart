import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:widget_simple/components/app_scaffold.dart';
import 'package:widget_simple/components/page_title_bar.dart';

/// 滑动验证组件
class SlideVerifyPage extends StatelessWidget {
  const SlideVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PageTitleBar(title: "SlideVerifyPage"),
      body: Column(
        children: [
          // 标题说明
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              '滑动验证组件演示',
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
          // 内容区域
          Expanded(
            child: Center(
              child: SlideVerify(
                sliderImage: "assets/image/circle-arrow.png", // 建议使用 assets
                successText: "验证成功",
                initText: "滑动验证",
// 🩶 背景轨道色：柔和灰蓝，比背景稍亮一点
                bgColor: const Color(0xFF8C91B0),

                // 💜 进度条与滑块移动色：亮紫蓝，氛围风主色
                moveColor: const Color(0xFFB39DDB),

                // ✅ 成功文本样式：亮一点但非纯白
                successTextStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFF0E9FF),
                  fontWeight: FontWeight.w600,
                ),

                // 🩶 初始文字：浅灰蓝带透明度，与背景区分
                initTextStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFCDD1E0),
                  fontWeight: FontWeight.w500,
                ),
                onVerifySuccess: () {
                  // 处理验证成功逻辑
                  debugPrint("滑动验证成功!");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SlideVerify extends StatefulWidget {
  final double height;
  final double width;
  final Color? borderColor;
  final Color bgColor;
  final Color moveColor;
  final String? successText;
  final String? sliderImage;
  final String? initText;
  final String? initImage; // initImage 似乎未在 UI 中使用，已移除或可复用
  final TextStyle successTextStyle;
  final TextStyle initTextStyle;
  final VoidCallback? onVerifySuccess; // 重命名回调，更语义化

  const SlideVerify({
    super.key,
    this.height = 60,
    this.width = 250,
    this.successText = "验证成功", // 提供默认值
    this.initText = "滑动验证", // 提供默认值
    required this.sliderImage, // 建议设为必需，或提供默认图标
    this.initImage,
    this.successTextStyle = const TextStyle(fontSize: 14, color: Colors.white),
    this.initTextStyle = const TextStyle(fontSize: 14, color: Colors.black12),
    this.bgColor = Colors.grey,
    this.moveColor = Colors.blue,
    this.borderColor,
    this.onVerifySuccess,
  });

  @override
  State<SlideVerify> createState() => _SlideVerifyState();
}

class _SlideVerifyState extends State<SlideVerify>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _resetAnimation;
  late double _sliderWidth;
  late double _maxDragDistance; // 预计算最大拖拽距离

  double _currentDragDistance = 1.0;
  bool _isVerified = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _initSliderWidth();
    _initAnimation();
    _calculateMaxDragDistance();
  }

  void _initSliderWidth() {
    _sliderWidth = widget.height - 4.0; // 滑块直径
  }

  void _initAnimation() {
    _animController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _resetAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    )..addListener(_onAnimationUpdate);

    _animController.addStatusListener(_onAnimationStatus);
  }

  void _calculateMaxDragDistance() {
    _maxDragDistance = widget.width - _sliderWidth - 1.0;
  }

  void _onAnimationUpdate() {
    // 计算动画过程中滑块应移动的距离
    final progress = _resetAnimation.value;
    setState(() {
      _currentDragDistance = _currentDragDistance * (1.0 - progress);
    });
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _isDragging = true; // 重置动画完成后，允许再次拖拽
    }
  }

  void _onDragStart(DragStartDetails details) {
    if (_isVerified) return; // 验证成功时禁止拖拽
    // 如果正在回弹动画，停止动画，允许用户立即拖动
    if (_animController.isAnimating) {
      _animController.stop();
    }
    _isDragging = true;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isVerified) return; // 验证成功后禁止拖拽

    final newDistance = _currentDragDistance + details.delta.dx;
    final clampedDistance = newDistance.clamp(0.0, _maxDragDistance);

    if (clampedDistance >= _maxDragDistance) {
      // 验证成功
      setState(() {
        _currentDragDistance = _maxDragDistance;
        _isVerified = true;
      });
      // 触发成功回调
      if (widget.onVerifySuccess != null) {
        widget.onVerifySuccess!();
      }
    } else {
      setState(() {
        _currentDragDistance = clampedDistance;
      });
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isVerified) return; // 验证成功后无操作

    // 未达到验证条件，执行回弹动画
    _isDragging = false;
    // 关键修复：每次都从 0 重新播放回弹动画
    if (_animController.isAnimating) {
      _animController.stop();
    }
    _animController.reset();
    _animController.forward();
  }

  // 根据当前拖拽进度计算旋转角度：从起点到终点刚好一整圈
  double _getRotationAngle() {
    if (_maxDragDistance == 0) return 0.0;
    final progress = _currentDragDistance / _maxDragDistance; // 0.0 ~ 1.0
    return progress * 2 * math.pi; // 弧度
  }

  @override
  void dispose() {
    _animController
      ..removeListener(_onAnimationUpdate)
      ..removeStatusListener(_onAnimationStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onDragStart,
      onPanUpdate: _onDragUpdate,
      onPanEnd: _onDragEnd,
      child: Container(
        height: widget.height,
        width: widget.width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: widget.bgColor,
          border: widget.borderColor != null
              ? Border.all(color: widget.borderColor!)
              : null,
          borderRadius: BorderRadius.circular(widget.height / 2), // 使用半径更语义化
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // 填充已滑动部分的色块
            Positioned(
              top: 1.0, // 微调以适应边框
              left: 1.0,
              height: widget.height - 2.0,
              width: _currentDragDistance + _sliderWidth / 2,
              child: Container(
                decoration: BoxDecoration(
                  color: _isVerified
                      ? widget.moveColor
                      : widget.moveColor.withOpacity(0.8), // 可选：成功后颜色更明显
                ),
              ),
            ),
            // 中心文字
            Center(
              child: Text(
                _isVerified ? widget.successText! : widget.initText!,
                style: _isVerified
                    ? widget.successTextStyle
                    : widget.initTextStyle,
              ),
            ),
            // 滑块
            Positioned(
              top: 2.0, // 微调
              left: _currentDragDistance,
              child: Transform.rotate(
                angle: _getRotationAngle(), // 按进度旋转：到终点一整圈
                child: Container(
                  width: _sliderWidth,
                  height: _sliderWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_sliderWidth / 2),
                    border: widget.borderColor != null
                        ? Border.all(color: widget.borderColor!, width: 1.5)
                        : null, // 可选：滑块边框
                  ),
                  child: widget.sliderImage != null
                      ? Image.asset(
                          widget.sliderImage!,
                          fit: BoxFit.contain, // BoxFit.cover 可能会裁剪，contain 更安全
                          width: _sliderWidth * 0.6, // 图标大小适中
                          height: _sliderWidth * 0.6,
                        )
                      : const Icon(
                          Icons.chevron_right,
                          color: Colors.blue,
                        ), // 提供默认图标
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
