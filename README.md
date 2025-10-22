# Widget Simple

一个展示多种自定义 Flutter 组件的示例项目，包括动态贝塞尔曲线动画、渐变进度条、自定义滑动条、图片灰度对比和对角线分割图片灰度对比组件。

## 项目结构

```
lib/
├── main.dart                  # 应用入口点
├── page/
│   ├── animated_bezier_curve_examples.dart  # 贝塞尔曲线动画示例页面
│   ├── drag_gray_image_example.dart         # 图片灰度对比示例页面
│   ├── gradient_progress_example.dart       # 渐变进度条示例页面
│   ├── home_page.dart                      # 主页，展示所有示例的导航入口
│   ├── ratio_diagonal_gray_compare_example.dart  # 对角线分割图片灰度对比示例页面
│   └── seek_bar_example.dart               # 滑动条示例页面
├── router/
│   └── router_config.dart                  # 路由配置
└── widgets/
    ├── animated_bezier_curve.dart          # 动态贝塞尔曲线动画组件
    ├── gradient_progress_label.dart        # 渐变进度条组件
    └── seek_bar_widget.dart                # 自定义滑动条组件
```

## 功能介绍

### 1. 动态贝塞尔曲线动画 (Animated Bezier Curve)

位于 `lib/widgets/animated_bezier_curve.dart` 的 `AnimatedBezierCurve` 组件展示了一个动态变化的贝塞尔曲线动画。该动画通过随机生成控制点并平滑过渡来创建流动的视觉效果。

特性：
- 使用 `CustomPainter` 实现自定义绘制
- 通过 `AnimationController` 控制动画播放/暂停
- 支持自定义控制点数量
- 中心有一个播放/暂停按钮控制动画状态

### 2. 渐变进度条 (Gradient Progress)

位于 `lib/widgets/gradient_progress_label.dart` 的 `GradientProgressLabel` 组件展示了一个带有渐变效果的进度条，可以包含文本和图标。

特性：
- 支持自定义渐变颜色
- 可以在进度条上显示文本和图标
- 支持前景色和背景色分别设置
- 可以通过进度值控制渐变区域的大小
- 支持点击事件

### 3. 自定义滑动条 (Seek Bar)

位于 `lib/widgets/seek_bar_widget.dart` 的 `SeekBarWidget` 组件是一个高度可定制的滑动条，支持多种样式和交互方式。

特性：
- 支持自定义高度、颜色、边框等外观属性
- 可以显示左右图标
- 支持自定义滑块大小和颜色
- 支持拖拽和点击交互
- 使用 `CustomPainter` 实现自定义绘制

### 4. 图片灰度对比 (Drag Gray Image)

位于 `lib/page/drag_gray_image_example.dart` 的 `DragGrayImageCompare` 组件展示了一个可交互的图片灰度对比功能，用户可以通过拖动分割线来控制图片的灰化比例。

特性：
- 使用 `GestureDetector` 处理水平拖动事件
- 通过 `ColorFiltered` 和颜色矩阵实现图片灰度效果
- 使用 `Stack` 布局实现图层叠加效果
- 包含可拖动的分割线和手柄
- 通过 `AspectRatio` 保持图片显示比例

### 5. 对角线分割图片灰度对比 (Diagonal Gray Compare)

位于 `lib/page/ratio_diagonal_gray_compare_example.dart` 的 `RatioDiagonalGrayCompare` 组件展示了一个可交互的图片灰度对比功能，用户可以通过拖动对角线分割线来控制图片的灰化比例。

特性：
- 使用 `GestureDetector` 处理水平拖动事件
- 通过 `ColorFiltered` 和颜色矩阵实现图片灰度效果
- 使用 `Stack` 布局实现图层叠加效果
- 包含可拖动的对角线分割线和手柄
- 通过自定义 `CustomClipper` 实现对角线裁剪效果
- 通过 `AspectRatio` 保持图片显示比例

## 路由配置

项目使用 `go_router` 进行路由管理，配置文件位于 `lib/router/router_config.dart`。

路由包括：
- `/` - 主页 (`HomePage`)
- `/animated-bezier-curve` - 贝塞尔曲线动画示例页面
- `/gradient-progress` - 渐变进度条示例页面
- `/seek-bar` - 滑动条示例页面
- `/drag-gray-image` - 图片灰度对比示例页面
- `/ratio-diagonal-gray-compare` - 对角线分割图片灰度对比示例页面

## 依赖项

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  go_router: ^14.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## 使用说明

1. 克隆项目到本地
2. 运行 `flutter pub get` 安装依赖
3. 运行 `flutter run` 启动应用

在主页中，您可以点击不同的卡片导航到相应的示例页面，查看各个组件的效果和用法。
