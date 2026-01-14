import 'package:flutter/material.dart';

enum StrokeWidth {
  thin(1.5),
  medium(3.0),
  thick(5.0);

  final double value;
  const StrokeWidth(this.value);
}

enum CanvasBackground {
  white(Colors.white),
  transparent(Colors.transparent);

  final Color color;
  const CanvasBackground(this.color);
}

class Stroke {
  final List<Offset> points;
  final double width;

  Stroke({required this.points, required this.width});

  bool get isEmpty => points.length < 2;
}

class SignatureState extends ChangeNotifier {
  final List<Stroke> _strokes = [];
  final List<Stroke> _redoStack = [];
  final List<Offset> _currentStroke = [];

  StrokeWidth _currentWidth = StrokeWidth.medium;
  CanvasBackground _background = CanvasBackground.white;

  List<Stroke> get strokes => _strokes;
  List<Offset> get currentStroke => _currentStroke;
  StrokeWidth get currentWidth => _currentWidth;
  CanvasBackground get background => _background;

  bool get canUndo => _strokes.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void setStrokeWidth(StrokeWidth width) {
    _currentWidth = width;
    notifyListeners();
  }

  void setBackground(CanvasBackground bg) {
    _background = bg;
    notifyListeners();
  }

  void startStroke(Offset point) {
    _currentStroke.clear();
    _currentStroke.add(point);
    notifyListeners();
  }

  void addPoint(Offset point) {
    _currentStroke.add(point);
    notifyListeners();
  }

  void endStroke() {
    if (_currentStroke.length >= 2) {
      _strokes.add(Stroke(
        points: List.from(_currentStroke),
        width: _currentWidth.value,
      ));
      _redoStack.clear();
    }
    _currentStroke.clear();
    notifyListeners();
  }

  void undo() {
    if (_strokes.isNotEmpty) {
      _redoStack.add(_strokes.removeLast());
      notifyListeners();
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      _strokes.add(_redoStack.removeLast());
      notifyListeners();
    }
  }

  void clear() {
    _strokes.clear();
    _redoStack.clear();
    _currentStroke.clear();
    notifyListeners();
  }
}
