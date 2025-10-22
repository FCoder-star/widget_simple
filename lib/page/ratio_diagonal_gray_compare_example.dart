//
// import 'dart:math';
// import 'package:flutter/material.dart';
//
// class VerticalTiltReversedCompare extends StatefulWidget {
//   const VerticalTiltReversedCompare({super.key});
//
//   @override
//   State<VerticalTiltReversedCompare> createState() => _VerticalTiltReversedCompareState();
// }
//
// class _VerticalTiltReversedCompareState extends State<VerticalTiltReversedCompare> {
//   double _ratio = 0.5; // 拖动比例
//   double _angleDeg = 15; // 倾斜角度（底左→顶右）
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("垂直方向斜线（底左 顶右）分割灰度对比"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.rotate_left),
//             onPressed: () {
//               setState(() {
//                 _angleDeg = (_angleDeg - 5).clamp(-45, 45);
//               });
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.rotate_right),
//             onPressed: () {
//               setState(() {
//                 _angleDeg = (_angleDeg + 5).clamp(-45, 45);
//               });
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: AspectRatio(
//           aspectRatio: 1,
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               final w = constraints.maxWidth;
//               final h = constraints.maxHeight;
//               final angle = _angleDeg * pi / 180;
//
//               return GestureDetector(
//                 onHorizontalDragUpdate: (details) {
//                   setState(() {
//                     _ratio = (details.localPosition.dx / w).clamp(0.0, 1.0);
//                   });
//                 },
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     // 背景彩色图
//                     Image.asset('assets/image/streams.webp', fit: BoxFit.cover),
//
//                     // 灰度层（底左→顶右倾斜分割）
//                     ClipPath(
//                       clipper: _ReversedTiltClipper(ratio: _ratio, angle: angle),
//                       child: ColorFiltered(
//                         colorFilter: const ColorFilter.matrix([
//                           0.2126, 0.7152, 0.0722, 0, 0,
//                           0.2126, 0.7152, 0.0722, 0, 0,
//                           0.2126, 0.7152, 0.0722, 0, 0,
//                           0, 0, 0, 1, 0,
//                         ]),
//                         child: Image.asset('assets/image/streams.webp', fit: BoxFit.cover),
//                       ),
//                     ),
//
//                     // 分割线
//                     CustomPaint(
//                       painter: _ReversedTiltLinePainter(
//                         ratio: _ratio,
//                         angle: angle,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// 灰度裁剪路径（底左→顶右）
// class _ReversedTiltClipper extends CustomClipper<Path> {
//   final double ratio;
//   final double angle;
//
//   _ReversedTiltClipper({required this.ratio, required this.angle});
//
//   @override
//   Path getClip(Size size) {
//     final w = size.width;
//     final h = size.height;
//     final centerX = w * ratio;
//
//     // 与上个版本相反的斜向：底部在左侧，顶部在右侧
//     final dx = h * tan(angle) / 2;
//
//     final top = Offset(centerX + dx, 0);
//     final bottom = Offset(centerX - dx, h);
//
//
//
//     // 灰度区域在分割线左下侧
//     final path = Path();
//     path.moveTo(0, h);
//     path.lineTo(0, 0);
//     path.lineTo(top.dx, top.dy);
//     path.lineTo(bottom.dx, bottom.dy);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(_ReversedTiltClipper oldClipper) =>
//       oldClipper.ratio != ratio || oldClipper.angle != angle;
// }
//
// /// 分割线绘制（底左→顶右）
// class _ReversedTiltLinePainter extends CustomPainter {
//   final double ratio;
//   final double angle;
//   final Color color;
//
//   _ReversedTiltLinePainter({
//     required this.ratio,
//     required this.angle,
//     required this.color,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final w = size.width;
//     final h = size.height;
//     final centerX = w * ratio;
//     final dx = h * tan(angle) / 2;
//
//     final top = Offset(centerX + dx, 0);
//     final bottom = Offset(centerX - dx, h);
//
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = 3
//       ..style = PaintingStyle.stroke;
//
//     canvas.drawLine(top, bottom, paint);
//   }
//
//   @override
//   bool shouldRepaint(_ReversedTiltLinePainter oldDelegate) =>
//       oldDelegate.ratio != ratio || oldDelegate.angle != angle;
// }
//
//
// //
// // import 'dart:math';
// // import 'package:flutter/material.dart';
// //
// // class SlantedSplitImage extends StatefulWidget {
// //   const SlantedSplitImage({super.key});
// //
// //   @override
// //   State<SlantedSplitImage> createState() => _SlantedSplitImageState();
// // }
// //
// // class _SlantedSplitImageState extends State<SlantedSplitImage> {
// //   double position = 0.5; // 分割线位置 (0~1)
// //   double angle = 20; // 分割线倾斜角度（正数：左下→右上，负数：左上→右下）
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     const image = AssetImage('assets/image/streams.webp');
// //     final radians = angle * pi / 180;
// //
// //     return GestureDetector(
// //       onPanUpdate: (details) {
// //         setState(() {
// //           position += details.delta.dx / MediaQuery.of(context).size.width;
// //           position = position.clamp(0.0, 1.0);
// //         });
// //       },
// //       child: LayoutBuilder(
// //         builder: (context, constraints) {
// //           final width = constraints.maxWidth;
// //           final height = constraints.maxHeight;
// //
// //           // 🔹 计算分割线两端点
// //           // 以 position 为中心，沿垂直方向加上倾斜偏移
// //           final lineX = width * position;
// //           final offsetY = tan(radians) * width;
// //
// //           final p1 = Offset(lineX - offsetY / 2, 0); // 顶点
// //           final p2 = Offset(lineX + offsetY / 2, height); // 底点
// //
// //           // 🔹 左半部分路径（灰度）
// //           final path = Path()
// //             ..moveTo(0, 0)
// //             ..lineTo(p1.dx, p1.dy)
// //             ..lineTo(p2.dx, p2.dy)
// //             ..lineTo(0, height)
// //             ..close();
// //
// //           return Stack(
// //             fit: StackFit.expand,
// //             children: [
// //               // 背景彩色图
// //               Image(image: image, fit: BoxFit.cover),
// //
// //               // 灰度覆盖层（只显示左侧区域）
// //               ClipPath(
// //                 clipper: _SlantedClipper(path),
// //                 child: ColorFiltered(
// //                   colorFilter: const ColorFilter.matrix([
// //                     0.2126, 0.7152, 0.0722, 0, 0,
// //                     0.2126, 0.7152, 0.0722, 0, 0,
// //                     0.2126, 0.7152, 0.0722, 0, 0,
// //                     0, 0, 0, 1, 0,
// //                   ]),
// //                   child: Image(image: image, fit: BoxFit.cover),
// //                 ),
// //               ),
// //
// //               // 分割线
// //               CustomPaint(
// //                 painter: _LinePainter(p1, p2),
// //               ),
// //
// //               // 🔹 角度与位置可视化控制
// //               Positioned(
// //                 bottom: 20,
// //                 left: 20,
// //                 right: 20,
// //                 child: Column(
// //                   children: [
// //                     Text('角度: ${angle.toStringAsFixed(1)}°'),
// //                     Slider(
// //                       min: -45,
// //                       max: 45,
// //                       value: angle,
// //                       onChanged: (v) => setState(() => angle = v),
// //                     ),
// //                   ],
// //                 ),
// //               )
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// //
// // class _SlantedClipper extends CustomClipper<Path> {
// //   final Path path;
// //   _SlantedClipper(this.path);
// //
// //   @override
// //   Path getClip(Size size) => path;
// //
// //   @override
// //   bool shouldReclip(_SlantedClipper oldClipper) => true;
// // }
// //
// // class _LinePainter extends CustomPainter {
// //   final Offset p1;
// //   final Offset p2;
// //
// //   _LinePainter(this.p1, this.p2);
// //
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final paint = Paint()
// //       ..color = Colors.white
// //       ..strokeWidth = 2
// //       ..style = PaintingStyle.stroke;
// //     canvas.drawLine(p1, p2, paint);
// //   }
// //
// //   @override
// //   bool shouldRepaint(_LinePainter oldDelegate) =>
// //       oldDelegate.p1 != p1 || oldDelegate.p2 != p2;
// // }
// //


import 'dart:math';
import 'package:flutter/material.dart';


class SlantedSplitImage extends StatefulWidget {
  const SlantedSplitImage({super.key});

  @override
  State<SlantedSplitImage> createState() => _SlantedSplitImageState();
}

class _SlantedSplitImageState extends State<SlantedSplitImage> {
  double position = 0.5; // 分割线位置 (0~1)
  double angle = 20;     // 分割线倾斜角度（正数：左下→右上，负数：左上→右下）

  @override
  Widget build(BuildContext context) {
    const image = AssetImage('assets/image/streams.webp'); // 替换成你自己的图片

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("斜线灰度对比"),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta.dx / MediaQuery.of(context).size.width;
            position = position.clamp(0.0, 1.0); // 限制范围
          });
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            final radians = angle * pi / 180;

            // 🔹 计算分割线顶点与底点
            final lineX = width * position;
            final dx = tan(radians) * height / 2;

            final p1 = Offset(lineX + dx, 0);      // 顶点
            final p2 = Offset(lineX - dx, height); // 底点

            // 🔹 左半部分灰度路径
            final path = Path()
              ..moveTo(0, height)
              ..lineTo(0, 0)
              ..lineTo(p1.dx, p1.dy)
              ..lineTo(p2.dx, p2.dy)
              ..close();

            return Stack(
              fit: StackFit.expand,
              children: [
                // 彩色背景
                Image(image: image, fit: BoxFit.cover),

                // 灰度覆盖
                ClipPath(
                  clipper: _SlantedClipper(path),
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix([
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0, 0, 0, 1, 0,
                    ]),
                    child: Image(image: image, fit: BoxFit.cover),
                  ),
                ),

                // 分割线
                CustomPaint(
                  painter: _LinePainter(p1, p2),
                ),

                // 🔹 角度滑条
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Text('角度: ${angle.toStringAsFixed(1)}°',
                          style: const TextStyle(color: Colors.white)),
                      Slider(
                        min: -45,
                        max: 45,
                        value: angle,
                        onChanged: (v) => setState(() => angle = v),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

/// ClipPath 裁剪器
class _SlantedClipper extends CustomClipper<Path> {
  final Path path;
  _SlantedClipper(this.path);

  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(_SlantedClipper oldClipper) => true;
}

/// 分割线绘制器
class _LinePainter extends CustomPainter {
  final Offset p1;
  final Offset p2;

  _LinePainter(this.p1, this.p2);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) =>
      oldDelegate.p1 != p1 || oldDelegate.p2 != p2;
}

