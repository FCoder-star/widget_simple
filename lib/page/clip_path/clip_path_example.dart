import 'dart:math' as math;

import 'package:flutter/material.dart';

class ClipPathExample extends StatelessWidget {
  const ClipPathExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClipPath Example')),
      body: Center(
        child: ListView(
          children: [
            // 使用 ClipPath 裁剪出波浪形
            Align(
              alignment: Alignment.center,
              child: ClipPath(
                clipper: WaveClipper(), // 使用自定义的裁剪器
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Wavy Header',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            // 示例 2: 圆形头像裁剪 (虽然有 CircleAvatar，但用 ClipPath 也能实现)
            Align(
              child: ClipPath(
                clipper: CircleClipper(),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey, // 假设这是图片
                  child: const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            ClipPath(
              clipper: CutCornerClipper(cornerSize: 30), // 自定义裁剪器
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Cut Corners",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),

            SizedBox(height: 50),
            ClipPath(
              clipper: PathApiClipper(),
              child: Container(
                width: 320,
                height: 420,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlueAccent.shade100,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 自定义波浪形裁剪器
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30); // 移动到左下角上方

    // 创建波浪效果
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width / 1.5, size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0); // 连接到右上角
    path.close(); // 关闭路径
    return path;
  }

  // 波浪形状只依赖于size，通常不需要重绘
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

/// 自定义裁剪器：切除四个角
class CutCornerClipper extends CustomClipper<Path> {
  final double cornerSize;

  /// [cornerSize] 控制每个角切掉的距离
  const CutCornerClipper({this.cornerSize = 20});

  @override
  Path getClip(Size size) {
    final path = Path();

    // 从左上角开始（略微往右下移动）
    path.moveTo(cornerSize, 0);

    // 顶边到右上角（保留右上角切角）
    path.lineTo(size.width - cornerSize, 0);
    path.lineTo(size.width, cornerSize);

    // 右边到右下角
    path.lineTo(size.width, size.height - cornerSize);
    path.lineTo(size.width - cornerSize, size.height);

    // 底边到左下角
    path.lineTo(cornerSize, size.height);
    path.lineTo(0, size.height - cornerSize);

    // 左边到左上角
    path.lineTo(0, cornerSize);
    path.close(); // 闭合路径形成完整区域

    return path;
  }

  @override
  bool shouldReclip(covariant CutCornerClipper oldClipper) =>
      oldClipper.cornerSize != cornerSize;
}

// 自定义圆形裁剪器 (作为对比示例)
class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // 使用 Path.arcTo 或 Path.addOval 都可以
    var path = Path();
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    path.addOval(rect); // 添加一个椭圆（如果是正方形就是圆形）
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

/// 展示各种 Path API 的使用
class PathApiClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // ===========================================================
    // 1️⃣ moveTo(x, y) - 移动画笔到指定位置（不画线）
    // ===========================================================
    path.moveTo(20, 20);

    // ===========================================================
    // 2️⃣ lineTo(x, y) - 从当前点画直线
    // ===========================================================
    path.lineTo(120, 20);
    path.lineTo(120, 120);
    path.lineTo(20, 120);
    path.close(); // 闭合矩形

    // ===========================================================
    // 3️⃣ addRect() - 直接添加矩形路径
    // ===========================================================
    path.addRect(Rect.fromLTWH(150, 20, 100, 100));

    // ===========================================================
    // 4️⃣ addOval() - 添加椭圆（若长宽相等则为圆形）
    // ===========================================================
    path.addOval(Rect.fromLTWH(20, 150, 100, 60));

    // ===========================================================
    // 5️⃣ addArc() - 在矩形边界上添加弧线
    //     startAngle 从右侧水平线开始（弧度制）
    // ===========================================================
    path.addArc(Rect.fromLTWH(150, 150, 100, 100), math.pi / 2, math.pi);

    // ===========================================================
    // 6️⃣ arcTo() - 与 addArc 类似，但可选择是否连接上一点
    // ===========================================================
    path.arcTo(
      Rect.fromLTWH(20, 250, 100, 100),
      0,
      math.pi / 2,
      true, // true 表示“强制移动”，不连接上一段
    );

    // ===========================================================
    // 7️⃣ quadraticBezierTo() - 二阶贝塞尔曲线（一个控制点）
    // ===========================================================
    path.moveTo(150, 280);
    path.quadraticBezierTo(
      200,
      220, // 控制点
      250,
      300, // 终点
    );

    // ===========================================================
    // 8️⃣ cubicTo() - 三阶贝塞尔曲线（两个控制点）
    // ===========================================================
    path.moveTo(150, 350);
    path.cubicTo(
      180,
      300, // 控制点1
      220,
      400, // 控制点2
      280,
      350, // 终点
    );

    // ===========================================================
    // 9️⃣ addPolygon() - 批量添加多个点（可闭合）
    // ===========================================================
    final polygonPoints = [
      const Offset(50, 370),
      const Offset(80, 400),
      const Offset(20, 400),
    ];
    path.addPolygon(polygonPoints, true);

    // ===========================================================
    // 🔟 其他 Path 方法
    //     - addRRect(Rect, radius)
    //     - relativeLineTo(dx, dy)
    //     - relativeMoveTo(dx, dy)
    //     - addPath() 合并多个 Path
    // ===========================================================

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
