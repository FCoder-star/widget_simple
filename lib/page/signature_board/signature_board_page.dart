import 'package:flutter/material.dart';
import '../../components/app_scaffold.dart';
import '../../components/page_title_bar.dart';
import 'models/signature_state.dart';
import 'widgets/signature_canvas.dart';
import 'widgets/signature_toolbar.dart';

class SignatureBoardPage extends StatefulWidget {
  const SignatureBoardPage({super.key});

  @override
  State<SignatureBoardPage> createState() => _SignatureBoardPageState();
}

class _SignatureBoardPageState extends State<SignatureBoardPage> {
  late final SignatureState _state;
  final GlobalKey _canvasKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _state = SignatureState();
    _state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    _state.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    setState(() {});
  }

  Future<void> _handleSave() async {
    final canvas = SignatureCanvas(state: _state, canvasKey: _canvasKey);
    final imageBytes = await canvas.exportImage();

    if (!mounted) return;

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
          const PageTitleBar(title: '签字板'),
          Expanded(
            child: SignatureCanvas(
              state: _state,
              canvasKey: _canvasKey,
            ),
          ),
          SignatureToolbar(
            state: _state,
            onSave: _handleSave,
          ),
        ],
      ),
    );
  }
}
