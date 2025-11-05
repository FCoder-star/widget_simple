import 'package:flutter/material.dart';
import 'package:widget_simple/components/app_scaffold.dart';
import 'package:widget_simple/components/page_title_bar.dart';
import 'package:widget_simple/page/seek_bar/seek_bar_widget.dart';

class SeekBarExample extends StatefulWidget {
  const SeekBarExample({super.key});

  @override
  State<SeekBarExample> createState() => _SeekBarExampleState();
}

class _SeekBarExampleState extends State<SeekBarExample> {
  double seekBarValue = 1;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PageTitleBar(title: 'SeekBar Example'),
      body: Column(
        children: [
          // 标题说明
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              '自定义滑动条演示',
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSeekBarExample(
                      context,
                      "SeekBar Example 1",
                      SeekBarWidget(
                        barHeight: 25,
                        value: seekBarValue,
                        // 配色：静谧灰蓝底 + 香槟金高光
                        thumbColor: const Color(0xFFD4B27A), // 低饱和香槟金
                        thumbSize: 25,
                        // 背景：深灰蓝，沉稳且有层次
                        backgroundColor: const Color(0xFF101826),
                        // 渐变条：柔和蓝紫到深蓝，带一点光泽感
                        gradientStartColor: const Color(0xFF6B7BCD), // 柔和蓝
                        gradientEndColor: const Color(0xFF2B3A88), // 深海蓝
                        leftIconAsset:
                            "assets/image/low_brightness_light.webp",
                        rightIconAsset:
                            "assets/image/high_brightness_light.webp",
                        iconSize: 18,
                        iconPadding: 12,
                        drawIcons: true,
                        barPadding: 2,
                        onChange: (value) {
                          setState(() {
                            seekBarValue = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                    _buildSeekBarExample(
                      context,
                      "SeekBar Example 2",
                      SeekBarWidget(
                        value: seekBarValue,
                        // 配色：奶油米 + 黑曜点缀，柔和奢华
                        thumbColor: const Color(0xFF1F1F1F), // 黑曜石
                        backgroundColor: const Color(0xFFF6F0E6), // 奶油米
                        gradientStartColor: const Color(0xFFCEB98A), // 柔和金
                        gradientEndColor: const Color(0xFFB57A6B), // 暗珊瑚
                        drawThumb: false,
                        onChange: (value) {
                          setState(() {
                            seekBarValue = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                    _buildSeekBarExample(
                      context,
                      "SeekBar Example 3",
                      SeekBarWidget(
                        value: seekBarValue,
                        // 配色：月光银 + 深海靛，冷冽科技感
                        thumbColor: const Color(0xFFC0C5CE), // 月光银
                        backgroundColor: const Color(0xFF0F1724), // 极夜黑蓝
                        gradientStartColor: const Color(0xFF2E6AA8), // 深海蓝
                        gradientEndColor: const Color(0xFF12213B), // 极夜深蓝
                        drawThumb: true,
                        onChange: (value) {
                          setState(() {
                            seekBarValue = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                    _buildSeekBarExample(
                      context,
                      "SeekBar Example 4",
                      SeekBarWidget(
                        // paddingColor: const Color(0xff0C0800),
                        // 配色：午夜蓝到珊瑚渐变，带一点活力
                        gradientStartColor: const Color(0xFF07122F), // 极深午夜
                        gradientEndColor: const Color(0xFFFF6B6B), // 珊瑚橙（点缀）
                        backgroundColor: const Color(0xFF07122F),
                        barHeight: 10,
                        barPadding: 2,
                        thumbSize: 10,
                        height: 14,
                        borderColor: const Color(0xFF1B2430),
                        borderWidth: 1,
                        thumbColor: const Color(0xFFFF7A7A),
                        value: seekBarValue,
                        onChange: (value) {
                          setState(() {
                            seekBarValue = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeekBarExample(
    BuildContext context,
    String title,
    Widget seekBar,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: seekBar,
          ),
        ],
      ),
    );
  }
}
