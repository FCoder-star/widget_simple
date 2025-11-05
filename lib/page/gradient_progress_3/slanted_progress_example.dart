import 'dart:async';
import 'package:flutter/material.dart';
import 'package:widget_simple/page/gradient_progress_3/slanted_progress.dart';

/// 示例：带斜纹的进度指示器页面
class SlantedProgressExample extends StatefulWidget {
  const SlantedProgressExample({super.key});

  @override
  State<SlantedProgressExample> createState() =>
      _SlantedProgressExampleState();
}

class _SlantedProgressExampleState
    extends State<SlantedProgressExample> {
  double progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    const total = 30; // 30 秒
    const tick = 30;  // 每 30 ms 更新一次
    final step = 1 / (total * 1000 / tick);
    _timer = Timer.periodic(const Duration(milliseconds: tick), (timer) {
      if (mounted) {
        setState(() {
          progress += step;
          if (progress >= 1) {
            progress = 1;
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('斜纹进度指示器')),
      body: Center(
        child: SlantedProgress(
          progress: progress, // 65% 进度
          angle: 15,
          background: const AssetImage('assets/image/indicator_bg.png'),
          text: "Reward in 30 seconds",
          leftTextStyle: TextStyle(
            fontSize: 14,
            color: const Color(0xff130C00),
          ),
          rightTextStyle: TextStyle(
            fontSize: 14,
            color: const Color(0xffFFFFFF).withValues(alpha: 0.5),
          ),
          onTap: () {
            // 可用于跳转详情、刷新等
          },
        ),
      ),
    );
  }
}
