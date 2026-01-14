import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:widget_simple/page/bezier_curve/animated_bezier_curve_examples.dart';

import 'package:widget_simple/page/gradient_progress/gradient_progress_example.dart';
import 'package:widget_simple/page/gradient_progress_3/slanted_progress_example.dart';
import 'package:widget_simple/page/seek_bar/seek_bar_example.dart';
import 'package:widget_simple/page/home_page.dart';
import 'package:widget_simple/page/drag_gray_image/drag_gray_image_example.dart';
import 'package:widget_simple/page/gradient_progress_2/ratio_diagonal_gray_compare_example.dart';
import 'package:widget_simple/page/slide_verify/slide_verify_page.dart';
import 'package:widget_simple/page/clip_path/clip_path_example.dart';
import 'package:widget_simple/page/chamfered/pages/chamfered_demo_page.dart';
import 'package:widget_simple/page/super/super_ellipse_example.dart';
import 'package:widget_simple/page/shader_mask/shader_mask_example.dart';
import 'package:widget_simple/page/animated_text/pages/animated_text_page.dart';
import 'package:widget_simple/page/signature_board/signature_board_page.dart';
import 'package:widget_simple/page/word_cloud/word_cloud_page.dart';

// 定义路由名称常量
class AppRoutes {
  static const String home = '/';
  static const String animatedBezierCurve = '/animated-bezier-curve';
  static const String gradientProgress = '/gradient-progress';
  static const String seekBar = '/seek-bar';
  static const String dragGrayImage = '/drag-gray-image';
  static const String ratioDiagonalGrayCompare = '/ratio-diagonal-gray-compare';
  static const String glassExample = '/glass-example';
  static const String slideVerify = '/slide-verify';
  static const String clipPath = '/clip-path';
  static const String slantedProgressIndicator = '/slanted-progress-indicator';
  static const String chamfered = '/chamfered';
  static const String superEllipse = '/super-ellipse';
  static const String shaderMask = '/shader-mask';
  static const String animatedText = '/animated-text';
  static const String signatureBoard = '/signature-board';
  static const String wordCloud = '/word-cloud';
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

    GoRoute(
      path: AppRoutes.slideVerify,
      name: AppRoutes.slideVerify,
      builder: (BuildContext context, GoRouterState state) {
        return const SlideVerifyPage();
      },
    ),
    GoRoute(
      path: AppRoutes.clipPath,
      name: AppRoutes.clipPath,
      builder: (BuildContext context, GoRouterState state) {
        return const ClipPathExample();
      },
    ),
    GoRoute(
      path: AppRoutes.slantedProgressIndicator,
      name: AppRoutes.slantedProgressIndicator,
      builder: (BuildContext context, GoRouterState state) {
        return const SlantedProgressExample();
      },
    ),
    GoRoute(
      path: AppRoutes.chamfered,
      name: AppRoutes.chamfered,
      builder: (BuildContext context, GoRouterState state) {
        return const ChamferedDemoPage();
      },
    ),
    GoRoute(
      path: AppRoutes.superEllipse,
      name: AppRoutes.superEllipse,
      builder: (BuildContext context, GoRouterState state) {
        return const SuperEllipseDemo();
      },
    ),
    GoRoute(
      path: AppRoutes.shaderMask,
      name: AppRoutes.shaderMask,
      builder: (BuildContext context, GoRouterState state) {
        return const ShaderMaskExample();
      },
    ),
    GoRoute(
      path: AppRoutes.animatedText,
      name: AppRoutes.animatedText,
      builder: (BuildContext context, GoRouterState state) {
        return const AnimatedTextPage(title: 'Wave Gradient Text');
      },
    ),
    GoRoute(
      path: AppRoutes.signatureBoard,
      name: AppRoutes.signatureBoard,
      builder: (BuildContext context, GoRouterState state) {
        return const SignatureBoardPage();
      },
    ),
    GoRoute(
      path: AppRoutes.wordCloud,
      name: AppRoutes.wordCloud,
      builder: (BuildContext context, GoRouterState state) {
        return const WordCloudPage();
      },
    ),
  ],
);
