# Widget Simple

一个多平台 Flutter 示例项目，展示多种自定义组件与视觉效果。包含 14 个功能丰富的组件示例：动态贝塞尔曲线、自定义滑动条、路径裁剪、渐变进度条、图片灰度对比、对角线灰度对比、斜纹进度指示器、滑动验证、切角容器、超椭圆 LOGO、ShaderMask 特效、波浪渐变文字、词云可视化、电子签字板等实用组件。所有组件均提供完整的演示页面和详细的使用示例。

## 目录结构

```
lib/
├── main.dart                      # 应用入口
├── components/
│   ├── app_scaffold.dart          # 统一渐变背景的Scaffold组件
│   └── page_title_bar.dart        # 可复用的页面标题栏组件
├── router/
│   └── router_config.dart         # 基于 go_router 的路由配置
├── page/
│   ├── home_page.dart             # 主页与示例导航
│   ├── bezier_curve/              # 动态贝塞尔曲线示例
│   │   ├── animated_bezier_curve.dart
│   │   └── animated_bezier_curve_examples.dart
│   ├── chamfered/                 # 切角容器组件示例
│   │   ├── pages/chamfered_demo_page.dart
│   │   └── widgets/
│   │       ├── chamfered_container.dart
│   │       └── CHANGELOG_CHAMFERED.md
│   ├── clip_path/                 # 路径裁剪示例
│   │   └── clip_path_example.dart
│   ├── drag_gray_image/           # 拖动控制图片灰度示例
│   │   └── drag_gray_image_example.dart
│   ├── gradient_progress/         # 渐变进度条示例
│   │   ├── gradient_progress_example.dart
│   │   └── gradient_progress_label.dart
│   ├── gradient_progress_2/       # 对角线灰度对比示例
│   │   └── ratio_diagonal_gray_compare_example.dart
│   ├── gradient_progress_3/       # 斜纹进度指示器示例
│   │   ├── slanted_progress.dart
│   │   └── slanted_progress_example.dart
│   ├── seek_bar/                  # 自定义滑动条示例
│   │   ├── seek_bar_example.dart
│   │   └── seek_bar_widget.dart
│   ├── slide_verify/              # 滑动验证组件示例
│   │   └── slide_verify_page.dart
│   ├── super/                     # 超椭圆 LOGO 示例
│   │   └── super_ellipse_example.dart
│   ├── shader_mask/               # ShaderMask 特效示例
│   │       └── shader_mask_example.dart
│   ├── animated_text/             # 波浪渐变文字动画示例
│   │   ├── pages/animated_text_page.dart
│   │   └── widget/wave_gradient_text.dart
│   ├── word_cloud/                # 词云可视化示例
│   │   ├── models/word_cloud_state.dart
│   │   ├── widgets/
│   │   │   ├── word_cloud_canvas.dart
│   │   │   └── word_cloud_toolbar.dart
│   │   └── word_cloud_page.dart
│   └── signature_board/           # 电子签字板示例
│       ├── models/signature_state.dart
│       ├── widgets/
│       │   ├── signature_canvas.dart
│       │   └── signature_toolbar.dart
│       └── signature_board_page.dart
assets/
└── image/                         # 项目资源图片
    ├── arrow.png
    ├── circle-arrow.png
    ├── default_avatar.png
    ├── glass/
    │   └── wallpaper.webp
    ├── high_brightness_light.webp
    ├── indicator_bg.png
    ├── low_brightness_light.webp
    ├── pause.webp
    ├── play.webp
    ├── question.webp
    ├── qus.png
    └── streams.webp
```

## 模块与示例

### 可复用组件
- **AppScaffold**：提供统一蓝紫色渐变背景的Scaffold组件，支持自定义装饰和布局属性
- **PageTitleBar**：包含返回按钮和标题文本的可复用页面标题栏组件，支持自定义样式

### 功能示例

#### 1. 动态贝塞尔曲线 (Animated Bezier Curve)
- **功能**：展示动画贝塞尔曲线的实现与应用
- **特性**：支持播放/暂停控制，流畅的曲线动画效果
- **应用场景**：加载动画、过渡效果、数据可视化

#### 2. 自定义滑动条 (Seek Bar)
- **功能**：功能丰富的自定义滑动条组件
- **特性**：
  - 支持左右图标配置（如亮度图标）
  - 支持渐变进度条和自定义背景色
  - 支持滑块样式自定义（颜色、大小）
  - 支持边框和圆角配置
  - 多种配色方案示例
- **应用场景**：音量控制、进度调节、参数设置

#### 3. 路径裁剪 (ClipPath Example)
- **功能**：展示 Flutter Path 裁剪与基本 API 用法
- **特性**：
  - 波浪形裁剪器 (WaveClipper)
  - 圆形裁剪器 (CircleClipper)
  - 自定义路径裁剪
- **应用场景**：自定义形状容器、头像裁剪、装饰性UI元素

#### 4. 渐变进度条 (Gradient Progress)
- **功能**：具有美观渐变效果的进度指示器
- **特性**：
  - 支持自定义渐变颜色
  - 支持文本显示和样式自定义
  - 平滑的动画过渡
- **应用场景**：下载进度、任务完成度、数据展示

#### 5. 图片灰度对比 (Drag Gray Image)
- **功能**：通过拖动控制图片灰度转换比例
- **特性**：
  - 左右分割的灰度/彩色对比效果
  - 实时拖动调节灰度比例
  - 直观的视觉对比展示
- **应用场景**：图片处理预览、滤镜效果对比

#### 6. 对角线灰度对比 (Diagonal Gray Compare)
- **功能**：对角线分割的图片灰度对比效果
- **特性**：
  - 支持对角线分割方向
  - 支持角度调整
  - 实时灰度转换控制
- **应用场景**：图片效果对比、创意展示

#### 7. 斜纹进度指示器 (Slanted Progress Indicator)
- **功能**：带有斜纹背景的可点击进度条
- **特性**：
  - 斜纹背景图案
  - 支持点击交互
  - 支持文本和样式自定义
  - 流畅的动画效果
- **应用场景**：游戏进度、任务完成度、交互式进度展示

#### 8. 滑动验证 (Slide Verify)
- **功能**：模拟滑块验证功能的交互组件
- **特性**：
  - 滑动解锁交互
  - 支持自定义滑块图标
  - 支持成功/初始状态文本
  - 支持旋转动画和状态反馈
  - 自定义颜色和样式配置
- **应用场景**：用户验证、安全解锁、交互式确认

#### 9. 切角容器 (Chamfered Container)
- **功能**：支持四个角独立设置切角尺寸的容器组件
- **特性**：
  - **v1.0.0 基础功能**：
    - 四个角独立设置切角尺寸（宽度和高度）
    - 支持正方形切角和矩形切角
    - 支持纯色和渐变背景
    - 支持边框样式
  - **v2.0.0 新特性**：
    - **圆弧过渡**：在切角线与边缘线交点处添加平滑圆弧过渡，通过 `radius` 参数控制
    - **圆角支持**：无切角的角支持设置圆角（类似 BorderRadius）
    - **混合使用**：可同时使用切角、切角+圆弧过渡、圆角等多种效果
- **应用场景**：卡片设计、按钮样式、装饰性容器、现代化UI元素

#### 10. 超椭圆 LOGO (Super Ellipse Logo)
- **功能**：可实时调节超椭圆指数 n 值，模拟小米 LOGO 的形变过程
- **特性**：
  - 自定义 `CustomPainter` 基于超椭圆参数绘制路径
  - 页面底部提供 1–5 的滑杆，动态调整曲线形状
  - 小米橙色配色，展示填充与描边效果
- **应用场景**：品牌 LOGO 演示、参数化图形教育、定制图标设计

#### 11. ShaderMask 特效 (ShaderMask Effects)
- **功能**：展示 ShaderMask 的多种视觉特效实现
- **特性**：
  - **文字渐变效果**：使用 `SweepGradient` 旋转渐变填充文字，创造彩虹般的多彩效果
  - **渐变高光效果**：使用 `LinearGradient` 实现金色高光主题，适用于图标和文字
  - **闪光动效**：使用 `AnimationController` 配合 ShaderMask 实现流光、扫光等动态效果
  - 支持多种 BlendMode 混合模式
  - 霓虹色系炫酷配色方案
- **应用场景**：品牌 LOGO 展示、按钮特效、加载动画、文字艺术效果

#### 12. 波浪渐变文字 (Wave Gradient Text)
- **功能**：展示带有波浪动画和渐变效果的文字组件
- **特性**：
  - **多种溢出策略**：支持 none（无处理）、ellipsis（省略号）、scale（缩放）、marquee（跑马灯）
  - **波浪动画**：文字随波浪曲线上下浮动，支持自定义振幅和相位
  - **渐变填充**：支持多色渐变填充文字
  - **跑马灯效果**：超出宽度时自动水平滚动
  - 霓虹色系赛博朋克风格配色
- **应用场景**：标题动效、品牌展示、游戏UI、创意文字效果

#### 13. 词云 (Word Cloud)
- **功能**：交互式词云可视化组件，支持多种布局和配色方案
- **特性**：
  - **8种布局算法**：圆形、心形、菱形、方形、三角形（上/右）、五边形、星形
  - **4种配色方案**：彩虹色（多彩渐变）、蓝色系、暖色系（红到黄）、冷色系（青到蓝）
  - **示例数据**：内置49个Flutter相关技术词汇，权重从100到1递减
  - **动态字体**：基于权重自动计算字体大小（10-38px）
  - **图片导出**：支持将词云导出为PNG图片
  - **交互工具栏**：实时切换布局形状和配色方案
  - **状态管理**：使用ChangeNotifier管理词云状态，支持重新生成布局
- **应用场景**：数据可视化、关键词展示、文本分析、内容摘要、演示文稿

#### 14. 电子签字板 (Signature Board)
- **功能**：手写签名和电子签字组件，支持自由绘制和笔画管理
- **特性**：
  - **3种画笔粗细**：细笔画（1.5px）、中等笔画（3.0px）、粗笔画（5.0px）
  - **2种背景模式**：白色背景、透明背景
  - **撤销/重做**：基于栈的撤销重做机制，支持多步操作回退
  - **清除功能**：一键清空所有笔画
  - **图片导出**：将签名导出为PNG图片格式
  - **实时绘制**：流畅的手势追踪和笔画渲染
  - **状态管理**：使用ChangeNotifier管理笔画数据和画笔设置
  - **笔画数据模型**：完整记录每条笔画的点集和粗细信息
- **应用场景**：电子签名、手写批注、绘图工具、合同签署、表单确认

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
  characters: ^1.4.0

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

## 在模拟器上运行

### Android 模拟器

1. 查看可用模拟器：`flutter emulators`
2. 启动模拟器：`flutter emulators --launch <emulator_id>`
3. 查看设备列表：`flutter devices`
4. 运行到指定设备：`flutter run -d <device_id>`

常见问题：
- 若模拟器启动失败（退出码 1），尝试更新 Android Studio 和 AVD，启用硬件加速（HVF/AMDuV），或新建一个 AVD。
- Apple Silicon 建议使用 API 33+ 的 arm64 系统镜像。

### iOS 模拟器

1. 确保已安装 Xcode 和 iOS 模拟器
2. 查看可用设备：`flutter devices`
3. 运行到 iOS 模拟器：`flutter run -d ios`
4. 或指定特定模拟器：`flutter run -d <device_id>`

注意：iOS 模拟器需要在 macOS 系统上运行。

## 路由

基于 `go_router` 的集中路由在 `lib/router/router_config.dart` 中维护，主页 `HomePage` 提供到各示例页的导航入口。路由配置清晰，便于扩展和维护。

## 界面设计

- 主页采用卡片式布局，每个示例卡片都有独特的渐变背景和图标
- 实现了鼠标悬停动画效果，提升用户体验
- 响应式设计，适配不同屏幕尺寸
- 统一的页面风格，基于AppScaffold和PageTitleBar组件实现一致的视觉体验
- 蓝紫色渐变主题背景，提供现代感的视觉效果

## 开发与质量

- 代码规范：`analysis_options.yaml`（`flutter_lints`）
- 静态分析：`dart analyze`
- 单元测试：`flutter test`
- 构建 Android 包：`flutter build apk`
- 组件复用：通过AppScaffold和PageTitleBar实现UI组件复用，减少重复代码
- 统一风格：所有功能页面使用一致的设计模式，提升代码可维护性

## 许可

本项目仅用于学习与示例展示用途；如需商用请根据实际依赖库的许可条款评估。
