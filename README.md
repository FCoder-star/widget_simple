# Widget Simple

一个多平台 Flutter 示例项目，展示多种自定义组件与视觉效果：动态贝塞尔曲线、渐变进度、滑动条、图片灰度对比，以及液态玻璃等。

## 目录结构（更新版）

```
lib/
├── main.dart                      # 应用入口
├── router/
│   └── router_config.dart         # 基于 go_router 的路由配置
├── page/
│   ├── home_page.dart             # 主页与示例导航
│   ├── bezier_curve/
│   │   ├── animated_bezier_curve.dart
│   │   └── animated_bezier_curve_examples.dart
│   ├── gradient_progress/
│   │   ├── gradient_progress_label.dart
│   │   └── gradient_progress_example.dart
│   ├── gradient_progress_2/
│   │   └── ratio_diagonal_gray_compare_example.dart
│   ├── seek_bar/
│   │   ├── seek_bar_widget.dart
│   │   └── seek_bar_example.dart
│   ├── drag_gray_image/
│   │   └── drag_gray_image_example.dart
│   └── glass_example/
│       ├── glass_example.dart
│       ├── basic_app.dart
│       ├── clock.dart
│       ├── grid.dart
│       ├── shapes.dart
│       ├── shared.dart
│       ├── main.dart
│       └── widgets/
├── slide_verify/
│       └── slide_verify_page.dart
assets/
└── image/
    ├── glass/                     # 液态玻璃示例资源
    ├── high_brightness_light.webp
    ├── low_brightness_light.webp
    ├── pause.webp
    ├── play.webp
    ├── question.webp
    └── streams.webp
```

## 模块与示例

- 动态贝塞尔曲线：`lib/page/bezier_curve/animated_bezier_curve(.dart|_examples.dart)`
- 渐变进度条：`lib/page/gradient_progress/gradient_progress_label.dart`
- 自定义滑动条：`lib/page/seek_bar/seek_bar_widget.dart`
- 图片灰度对比：`lib/page/drag_gray_image/drag_gray_image_example.dart`
- 对角线灰度对比：`lib/page/gradient_progress_2/ratio_diagonal_gray_compare_example.dart`
- 液态玻璃示例：`lib/page/glass_example/*`（基于 `liquid_glass_renderer`）
- 滑动验证：`lib/page/slide_verify/slide_verify_page.dart`

## 依赖与环境

项目使用的关键依赖（来自 `pubspec.yaml`）：

```yaml
environment:
  sdk: ^3.9.2

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  go_router: ^14.0.0
  liquid_glass_renderer: ^0.1.1-dev.26
  flex_color_picker: ^3.7.1
  flutter_hooks: ^0.21.2
  heroine: ^0.5.0-dev.6
  rivership: ^0.3.0-dev.6
  smooth_sheets: ^0.12.0
  motor: ^1.0.0-dev.3
  google_fonts: ^6.2.1
  stupid_simple_sheet: ^0.5.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

建议使用 Flutter 3.24+ 与 Dart 3.9 以获得最佳兼容性。

## 快速开始

1. 安装依赖：`flutter pub get`
2. 启动应用：`flutter run`
3. Web 运行（可选）：`flutter run -d chrome`

## 在 Android 模拟器上运行

1. 查看可用模拟器：`flutter emulators`
2. 启动模拟器：`flutter emulators --launch <emulator_id>`
3. 查看设备列表：`flutter devices`
4. 运行到指定设备：`flutter run -d <device_id>`

常见问题：
- 若模拟器启动失败（退出码 1），尝试更新 Android Studio 和 AVD，启用硬件加速（HVF/AMDuV），或新建一个 AVD。
- Apple Silicon 建议使用 API 33+ 的 arm64 系统镜像。

## 路由

基于 `go_router` 的集中路由在 `lib/router/router_config.dart` 中维护，主页 `HomePage` 提供到各示例页的导航入口。

## 开发与质量

- 代码规范：`analysis_options.yaml`（`flutter_lints`）
- 静态分析：`dart analyze`
- 单元测试：`flutter test`
- 构建 Android 包：`flutter build apk`

## 许可

本项目仅用于学习与示例展示用途；如需商用请根据实际依赖库的许可条款评估。
