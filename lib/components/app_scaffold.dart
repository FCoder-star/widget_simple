import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final BoxDecoration? customDecoration;
  final bool resizeToAvoidBottomInset;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.customDecoration,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: customDecoration ?? _defaultGradientDecoration,
        child: Column(
          children: [
            if (appBar != null) appBar!,
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  // 默认渐变背景
  static final BoxDecoration _defaultGradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        // Color(0xFFBFC8D8), // 柔和灰蓝，优雅有质感
        // Color(0xFFA7B3C8), // 带点淡紫调，提升高级感
        // Color(0xFF8E9AAF), // 稍深灰蓝，保证白字清晰
        Color(0xFF7A7BA3), // 柔和灰紫，主基调
        Color(0xFF5D628F), // 稍深一点的灰蓝紫，稳重高级
        Color(0xFF4A4F72), // 底部深灰蓝，让白字更有对比
      ],
    ),
  );
}