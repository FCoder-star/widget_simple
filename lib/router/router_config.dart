import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:widget_simple/page/animated_bezier_curve_examples.dart';
import 'package:widget_simple/page/gradient_progress_example.dart';
import 'package:widget_simple/page/seek_bar_example.dart';
import 'package:widget_simple/page/home_page.dart';
import 'package:widget_simple/page/drag_gray_image_example.dart';
import 'package:widget_simple/page/ratio_diagonal_gray_compare_example.dart';

// 定义路由名称常量
class AppRoutes {
  static const String home = '/';
  static const String animatedBezierCurve = '/animated-bezier-curve';
  static const String gradientProgress = '/gradient-progress';
  static const String seekBar = '/seek-bar';
  static const String dragGrayImage = '/drag-gray-image';
  static const String ratioDiagonalGrayCompare = '/ratio-diagonal-gray-compare';
}

// 路由配置
final GoRouter routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: AppRoutes.animatedBezierCurve,
      name: AppRoutes.animatedBezierCurve,
      builder: (BuildContext context, GoRouterState state) {
        return const AnimatedBezierCurveExamples();
      },
    ),
    GoRoute(
      path: AppRoutes.gradientProgress,
      name: AppRoutes.gradientProgress,
      builder: (BuildContext context, GoRouterState state) {
        return const GradientProgressExample();
      },
    ),
    GoRoute(
      path: AppRoutes.seekBar,
      name: AppRoutes.seekBar,
      builder: (BuildContext context, GoRouterState state) {
        return const SeekBarExample();
      },
    ),
    GoRoute(
      path: AppRoutes.dragGrayImage,
      name: AppRoutes.dragGrayImage,
      builder: (BuildContext context, GoRouterState state) {
        return const DragGrayImageCompare();
      },
    ),
    GoRoute(
      path: AppRoutes.ratioDiagonalGrayCompare,
      name: AppRoutes.ratioDiagonalGrayCompare,
      builder: (BuildContext context, GoRouterState state) {
        return const SlantedSplitImage();
      },
    ),
  ],
);