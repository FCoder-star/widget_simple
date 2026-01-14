import 'package:flutter/material.dart';

/// 笔画粗细枚举
/// 定义三种画笔粗细选项
enum StrokeWidth {
  thin(1.5),    // 细笔画
  medium(3.0),  // 中等笔画
  thick(5.0);   // 粗笔画

  final double value;
  const StrokeWidth(this.value);
}

/// 画布背景枚举
/// 定义画布的背景颜色选项
enum CanvasBackground {
  white(Colors.white),              // 白色背景
  transparent(Colors.transparent);  // 透明背景

  final Color color;
  const CanvasBackground(this.color);
}

/// 笔画数据模型
/// 存储一条完整笔画的所有点和粗细信息
class Stroke {
  final List<Offset> points;  // 笔画的所有点
  final double width;          // 笔画粗细

  Stroke({required this.points, required this.width});

  /// 判断笔画是否为空（少于2个点无法绘制）
  bool get isEmpty => points.length < 2;
}

/// 签字板状态管理类
/// 管理笔画数据、撤销/重做栈、画笔设置等
class SignatureState extends ChangeNotifier {
  final List<Stroke> _strokes = [];         // 已完成的笔画列表
  final List<Stroke> _redoStack = [];       // 重做栈
  final List<Offset> _currentStroke = [];   // 当前正在绘制的笔画

  StrokeWidth _currentWidth = StrokeWidth.medium;        // 当前画笔粗细
  CanvasBackground _background = CanvasBackground.white; // 当前背景色

  // Getters
  List<Stroke> get strokes => _strokes;
  List<Offset> get currentStroke => _currentStroke;
  StrokeWidth get currentWidth => _currentWidth;
  CanvasBackground get background => _background;

  /// 是否可以撤销（有已完成的笔画）
  bool get canUndo => _strokes.isNotEmpty;

  /// 是否可以重做（重做栈不为空）
  bool get canRedo => _redoStack.isNotEmpty;

  /// 设置画笔粗细
  void setStrokeWidth(StrokeWidth width) {
    _currentWidth = width;
    notifyListeners();
  }

  /// 设置画布背景色
  void setBackground(CanvasBackground bg) {
    _background = bg;
    notifyListeners();
  }

  /// 开始新笔画
  /// 清空当前笔画并添加起始点
  void startStroke(Offset point) {
    _currentStroke.clear();
    _currentStroke.add(point);
    notifyListeners();
  }

  /// 添加点到当前笔画
  /// 在手指/鼠标移动时持续调用
  void addPoint(Offset point) {
    _currentStroke.add(point);
    notifyListeners();
  }

  /// 结束当前笔画
  /// 将当前笔画添加到已完成列表，并清空重做栈
  void endStroke() {
    // 至少需要2个点才能形成有效笔画
    if (_currentStroke.length >= 2) {
      _strokes.add(Stroke(
        points: List.from(_currentStroke),
        width: _currentWidth.value,
      ));
      // 新笔画产生时清空重做栈
      _redoStack.clear();
    }
    _currentStroke.clear();
    notifyListeners();
  }

  /// 撤销最后一笔
  /// 将最后一笔移到重做栈
  void undo() {
    if (_strokes.isNotEmpty) {
      _redoStack.add(_strokes.removeLast());
      notifyListeners();
    }
  }

  /// 重做上一次撤销的笔画
  /// 从重做栈恢复笔画到已完成列表
  void redo() {
    if (_redoStack.isNotEmpty) {
      _strokes.add(_redoStack.removeLast());
      notifyListeners();
    }
  }

  /// 清除所有笔画
  /// 清空已完成笔画、重做栈和当前笔画
  void clear() {
    _strokes.clear();
    _redoStack.clear();
    _currentStroke.clear();
    notifyListeners();
  }
}
