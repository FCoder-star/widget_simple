import 'package:flutter/material.dart';
import 'package:widget_simple/components/app_scaffold.dart';
import 'package:widget_simple/components/page_title_bar.dart';

class DragGrayImageCompare extends StatefulWidget {
  const DragGrayImageCompare({super.key});

  @override
  State<DragGrayImageCompare> createState() => _DragGrayImageCompareState();
}

class _DragGrayImageCompareState extends State<DragGrayImageCompare> {
  double _grayRatio = 0.5; // 灰化比例 (0 ~ 1)

  @override
  Widget build(BuildContext context) {
    return AppScaffold(

      appBar: PageTitleBar(title:"左右拖动灰度对比效果"),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1, // 方形示例，可换成图片宽高比
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageWidth = constraints.maxWidth;

              return GestureDetector(
                onHorizontalDragUpdate: (details) {
                  final newRatio =
                  (details.localPosition.dx / imageWidth).clamp(0.0, 1.0);
                  setState(() => _grayRatio = newRatio);
                },
                child: Stack(
                  children: [
                    // 背景：彩色完整图
                    Image.asset(
                      'assets/image/streams.webp',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    // 前景：灰度图（只显示左侧部分）
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: _grayRatio, // 根据拖动显示比例
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0, 0, 0, 1, 0,
                          ]),
                          child: Image.asset(
                            'assets/image/streams.webp',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // 分割线
                    Positioned(
                      left: _grayRatio * imageWidth - 1,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),

                    // 拖动手柄
                    Positioned(
                      left: _grayRatio * imageWidth - 20,
                      top: constraints.maxHeight / 2 - 20,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.compare_arrows,
                            color: Colors.black87, size: 22),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
