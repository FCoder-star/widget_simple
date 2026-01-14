import 'package:flutter/material.dart';
import '../../components/app_scaffold.dart';
import '../../components/page_title_bar.dart';
import 'models/word_cloud_state.dart';
import 'widgets/word_cloud_canvas.dart';
import 'widgets/word_cloud_toolbar.dart';

/// 词云主页面
/// 整合词云画布、工具栏等子组件，管理状态和导出功能
class WordCloudPage extends StatefulWidget {
  const WordCloudPage({super.key});

  @override
  State<WordCloudPage> createState() => _WordCloudPageState();
}

class _WordCloudPageState extends State<WordCloudPage> {
  // 词云状态管理对象
  late final WordCloudState _state;

  // 画布的 GlobalKey，用于图片导出
  final GlobalKey _canvasKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // 初始化状态对象
    _state = WordCloudState();
    // 监听状态变化，触发 UI 重建
    _state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    // 移除监听器，避免内存泄漏
    _state.removeListener(_onStateChanged);
    _state.dispose();
    super.dispose();
  }

  /// 状态变化回调
  /// 当配色方案、布局算法等状态改变时，重新构建 UI
  void _onStateChanged() {
    setState(() {});
  }

  /// 处理图片导出
  /// 通过 RepaintBoundary 将画布转换为 PNG 图片
  Future<void> _handleExport() async {
    final canvas = WordCloudCanvas(state: _state, canvasKey: _canvasKey);
    final imageBytes = await canvas.exportImage();

    // 检查组件是否仍然挂载，避免异步操作后使用已销毁的 context
    if (!mounted) return;

    // 根据导出结果显示提示信息
    if (imageBytes != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('词云已导出为图片')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('导出失败')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          // 页面标题栏
          const PageTitleBar(title: '词云'),
          // 词云画布（占据剩余空间）
          Expanded(
            child: WordCloudCanvas(
              state: _state,
              canvasKey: _canvasKey,
            ),
          ),
          // 底部工具栏（配色、形状、操作按钮）
          WordCloudToolbar(
            state: _state,
            onExport: _handleExport,
          ),
        ],
      ),
    );
  }
}
