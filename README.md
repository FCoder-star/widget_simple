# Widget Simple

一个多平台 Flutter 示例项目，展示多种自定义组件与视觉效果：动态贝塞尔曲线、渐变进度条、自定义滑动条、图片灰度对比、滑动验证、裁剪路径等实用组件。

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
│   ├── clip_path/                 # 路径裁剪示例
│   ├── drag_gray_image/           # 拖动控制图片灰度示例
│   ├── gradient_progress/         # 渐变进度条示例
│   ├── gradient_progress_2/       # 对角线灰度对比示例
│   ├── gradient_progress_3/       # 斜纹进度指示器示例
│   ├── seek_bar/                  # 自定义滑动条示例
│   └── slide_verify/              # 滑动验证组件示例
assets/
└── image/                         # 项目资源图片
    ├── arrow.png
    ├── circle-arrow.png
    ├── default_avatar.png
    ├── glass/                     # 玻璃效果相关图片
    ├── high_brightness_light.webp
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
- **动态贝塞尔曲线**：展示动画贝塞尔曲线的实现与应用，支持播放状态控制
- **自定义滑动条**：功能丰富的SeekBar组件，支持图标、渐变、背景配置等多种样式
- **裁剪路径**：展示Flutter Path裁剪与基本API用法，包含多种自定义裁剪器
- **渐变进度条**：具有美观渐变效果的进度指示器，支持自定义文本和样式
- **图片灰度对比**：通过拖动控制图片灰度转换比例，展示左右分割的灰度/彩色对比效果
- **对角线灰度对比**：对角线分割的图片灰度对比效果，支持角度调整
- **斜纹进度指示器**：带有斜纹背景的可点击进度条，支持文本和样式自定义
- **滑动验证**：模拟滑块验证功能的交互组件，支持旋转动画和状态反馈

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
  scrollview_observer: ^1.26.2

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
