import 'package:flutter/material.dart';
import '../models/word_cloud_state.dart';

/// 词云工具栏组件
/// 提供配色方案、形状布局选择和操作按钮
class WordCloudToolbar extends StatelessWidget {
  final WordCloudState state;      // 词云状态
  final VoidCallback onExport;     // 导出回调

  const WordCloudToolbar({
    super.key,
    required this.state,
    required this.onExport,
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
          // 配色方案选择行
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('配色: ', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 8),
              _buildColorButton(ColorSchemeType.rainbow, '彩虹'),
              const SizedBox(width: 8),
              _buildColorButton(ColorSchemeType.blue, '蓝色'),
              const SizedBox(width: 8),
              _buildColorButton(ColorSchemeType.warm, '暖色'),
              const SizedBox(width: 8),
              _buildColorButton(ColorSchemeType.cool, '冷色'),
            ],
          ),
          const SizedBox(width: 12),
          // 形状布局选择行（第一行）
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('形状: ', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 8),
              _buildLayoutButton(LayoutAlgorithm.circle, '圆形'),
              const SizedBox(width: 4),
              _buildLayoutButton(LayoutAlgorithm.heart, '心形'),
              const SizedBox(width: 4),
              _buildLayoutButton(LayoutAlgorithm.diamond, '菱形'),
              const SizedBox(width: 4),
              _buildLayoutButton(LayoutAlgorithm.square, '方形'),
            ],
          ),
          const SizedBox(height: 8),
          // 形状布局选择行（第二行）
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 48),
              _buildLayoutButton(LayoutAlgorithm.triangle, '三角'),
              const SizedBox(width: 4),
              _buildLayoutButton(LayoutAlgorithm.triangleRight, '三角→'),
              const SizedBox(width: 4),
              _buildLayoutButton(LayoutAlgorithm.pentagon, '五边'),
            ],
          ),
          const SizedBox(height: 12),
          // 操作按钮行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.refresh,
                label: '重新生成',
                onPressed: state.regenerate,
              ),
              _buildActionButton(
                icon: Icons.save,
                label: '导出图片',
                onPressed: onExport,
              ),
              // 轮廓开关
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: state.showContour,
                    onChanged: state.setShowContour,
                    activeColor: Colors.blue,
                  ),
                  const Text(
                    '显示轮廓',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建配色方案按钮
  /// 当前选中的配色方案会高亮显示
  Widget _buildColorButton(ColorSchemeType scheme, String label) {
    final isSelected = state.colorScheme == scheme;
    return ElevatedButton(
      onPressed: () => state.setColorScheme(scheme),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white24,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(50, 36),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  /// 构建布局形状按钮
  /// 当前选中的布局会高亮显示
  Widget _buildLayoutButton(LayoutAlgorithm layout, String label) {
    final isSelected = state.layout == layout;
    return ElevatedButton(
      onPressed: () => state.setLayout(layout),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white24,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(48, 32),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }

  /// 构建操作按钮（重新生成、导出图片）
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: Colors.white,
          iconSize: 28,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
