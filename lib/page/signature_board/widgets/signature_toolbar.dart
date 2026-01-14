import 'package:flutter/material.dart';
import '../models/signature_state.dart';

/// 签字板工具栏组件
/// 提供画笔粗细、背景色选择和操作按钮
class SignatureToolbar extends StatelessWidget {
  final SignatureState state;     // 签字板状态
  final VoidCallback onSave;      // 保存回调

  const SignatureToolbar({
    super.key,
    required this.state,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 画笔粗细选择行
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('粗细: ', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 8),
              _buildStrokeButton(StrokeWidth.thin, '细'),
              const SizedBox(width: 8),
              _buildStrokeButton(StrokeWidth.medium, '中'),
              const SizedBox(width: 8),
              _buildStrokeButton(StrokeWidth.thick, '粗'),
            ],
          ),
          const SizedBox(height: 12),
          // 背景色选择行
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('背景: ', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 8),
              _buildBackgroundButton(CanvasBackground.white, '白色'),
              const SizedBox(width: 8),
              _buildBackgroundButton(CanvasBackground.transparent, '透明'),
            ],
          ),
          const SizedBox(height: 12),
          // 操作按钮行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.undo,
                label: '撤销',
                onPressed: state.canUndo ? state.undo : null,
              ),
              _buildActionButton(
                icon: Icons.redo,
                label: '重做',
                onPressed: state.canRedo ? state.redo : null,
              ),
              _buildActionButton(
                icon: Icons.clear,
                label: '清除',
                onPressed: state.clear,
              ),
              _buildActionButton(
                icon: Icons.save,
                label: '保存',
                onPressed: onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建画笔粗细按钮
  /// 当前选中的粗细会高亮显示
  Widget _buildStrokeButton(StrokeWidth width, String label) {
    final isSelected = state.currentWidth == width;
    return ElevatedButton(
      onPressed: () => state.setStrokeWidth(width),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white24,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(60, 36),
      ),
      child: Text(label),
    );
  }

  /// 构建背景色按钮
  /// 当前选中的背景色会高亮显示
  Widget _buildBackgroundButton(CanvasBackground bg, String label) {
    final isSelected = state.background == bg;
    return ElevatedButton(
      onPressed: () => state.setBackground(bg),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white24,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(60, 36),
      ),
      child: Text(label),
    );
  }

  /// 构建操作按钮（撤销、重做、清除、保存）
  /// 根据状态启用或禁用按钮（如撤销/重做）
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: onPressed != null ? Colors.white : Colors.white38,
          iconSize: 28,
        ),
        Text(
          label,
          style: TextStyle(
            color: onPressed != null ? Colors.white : Colors.white38,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
