import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widget_simple/page/gradient_progress/gradient_progress_label.dart';

class GradientProgressExample extends StatefulWidget {
  const GradientProgressExample({super.key});

  @override
  State<GradientProgressExample> createState() =>
      _GradientProgressExampleState();
}

class _GradientProgressExampleState extends State<GradientProgressExample> {
  double progress = 0;

  int currentTime = 0;

  int totalTimes = 10;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime++;

      // 处理进度超过100%的情况
      progress = currentTime / totalTimes;
      if (progress > 1.0) {
        progress = progress % 1.0; // 循环显示进度
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
          ),
        ),
        child: Column(
          children: [
            // 自定义 AppBar
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Simple Gradient Progress',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 标题说明
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                '渐变进度条演示',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Simple Gradient Progress Bar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 主要进度条组件 - 添加了WidgetSpan
                    Center(
                      child: GradientProgressLabel(
                        foregroundTextColor: Colors.white,
                        backgroundTextColor: Colors.grey,
                        gradientColors: const [
                          Color(0xFFFF5252), // 红色
                          Color(0xFFFF4081), // 粉色
                          Color(0xFFFF6B35), // 橙色
                        ],
                        progress: progress,
                        textSpan: TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Icon(
                                Icons.star,
                                size: 16,
                                color: Color(0xFFFFFF00), // 亮黄
                              ),
                              alignment: PlaceholderAlignment.middle,
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: "Reward in ${formatSeconds(totalTimes)}",
                              style: const TextStyle(height: 1, fontSize: 16),
                            ),
                            const TextSpan(text: ' '),
                            const WidgetSpan(
                              child: Icon(
                                Icons.emoji_events,
                                size: 16,
                                color: Color(0xFFFFD700), // 金色
                              ),
                              alignment: PlaceholderAlignment.middle,
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 进度百分比显示
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 重置按钮
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentTime = 0;
                          progress = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFFF5252),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Reset Progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatSeconds(int? totalSeconds) {
    if (totalSeconds == null || totalSeconds < 0) {
      return '0 secs';
    }

    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final parts = <String>[];

    if (hours > 0) {
      parts.add('$hours hour${hours == 1 ? '' : 's'}');
    }
    if (minutes > 0) {
      parts.add('$minutes min${minutes == 1 ? '' : 's'}');
    }
    if (seconds > 0 || parts.isEmpty) {
      parts.add('$seconds sec${seconds == 1 ? '' : 's'}');
    }

    return parts.join(' ');
  }
}
