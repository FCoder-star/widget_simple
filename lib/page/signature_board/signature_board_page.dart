import 'package:flutter/material.dart';
import '../../components/app_scaffold.dart';
import '../../components/page_title_bar.dart';
import 'models/signature_state.dart';
import 'widgets/signature_canvas.dart';
import 'widgets/signature_toolbar.dart';

/// 签字板主页面
/// 整合签字板画布、工具栏等子组件，管理状态和保存功能
class SignatureBoardPage extends StatefulWidget {
  const SignatureBoardPage({super.key});

  @override
  State<SignatureBoardPage> createState() => _SignatureBoardPageState();
}

class _SignatureBoardPageState extends State<SignatureBoardPage> {
  // 签字板状态管理对象
  late final SignatureState _state;

  // 画布的 GlobalKey，用于图片导出
  final GlobalKey _canvasKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // 初始化状态对象
    _state = SignatureState();
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
  /// 当画笔粗细、背景色、笔画等状态改变时，重新构建 UI
  void _onStateChanged() {
    setState(() {});
  }

  /// 处理图片保存
  /// 通过 RepaintBoundary 将画布转换为 PNG 图片
  Future<void> _handleSave() async {
    final canvas = SignatureCanvas(state: _state, canvasKey: _canvasKey);
    final imageBytes = await canvas.exportImage();

    // 检查组件是否仍然挂载，避免异步操作后使用已销毁的 context
    if (!mounted) return;

    // 根据保存结果显示提示信息
    if (imageBytes != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('签名已保存为图片')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存失败')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          // 页面标题栏
          const PageTitleBar(title: '签字板'),
          // 签字板画布（占据剩余空间）
          Expanded(
            child: SignatureCanvas(
              state: _state,
              canvasKey: _canvasKey,
            ),
          ),
          // 底部工具栏（画笔粗细、背景色、操作按钮）
          SignatureToolbar(
            state: _state,
            onSave: _handleSave,
          ),
        ],
      ),
    );
  }
}
