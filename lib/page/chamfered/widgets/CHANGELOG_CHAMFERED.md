# ChamferedContainer 组件版本历史

## 版本 2.0.0 (2025-11-08) - 当前版本 ✨

### 新增功能

✅ **圆弧过渡特性**
- 在切角线与边缘线交点处添加平滑圆弧过渡
- 通过 `radius` 参数控制圆弧偏移量（N）
- 基于精确几何计算的内切圆弧算法
- 支持四个角独立设置圆弧过渡参数

✅ **圆角支持**
- 无切角的角（width=0, height=0）支持设置圆角
- `radius` 参数可用作普通圆角半径
- 实现类似 BorderRadius 的圆角效果
- 可混合使用切角、切角+圆弧过渡、圆角

### 技术原理

**几何计算说明**：

以左上角切角为例：
- L1: 左边线（垂直线）
- L2: 上边线（水平线）
- L3: 切角线（斜线）
- D1: L1 与 L3 的交点
- D2: L2 与 L3 的交点

**圆弧生成过程**：

1. **D1处圆弧**（连接左边线和切角线）：
   - 从 D1 沿 L1 方向（下）偏移 N → D3
   - 从 D1 沿 L3 方向（右上）偏移 N → D4
   - 经过 D3、D4 两点做 L1 和 L3 的内切圆
   - 圆心计算：(N(L + h)/w, h + N)，其中 L = sqrt(w² + h²)
   - 半径：r = N(L + h)/w

2. **D2处圆弧**（连接切角线和上边线）：
   - 从 D2 沿 L2 方向（右）偏移 N → D5
   - 从 D2 沿 L3 方向（左下）偏移 N → D6
   - 经过 D5、D6 两点做 L2 和 L3 的内切圆
   - 圆心计算：(w + N, N(w + L)/h)
   - 半径：r = N(w + L)/h

### API 更新

```dart
// ChamferSize 新增 radius 参数
ChamferSize({
  double width = 0,
  double height = 0,
  double radius = 0,  // 新增：圆弧过渡偏移量
})

// 快捷构造函数也支持 radius
ChamferSize.all(double size, {double radius = 0})
```

### 使用示例
#### 1. 圆弧过渡

```dart
// 基础圆弧过渡
ChamferedContainer(
  color: Colors.blue,
  bottomLeftChamfer: ChamferSize.all(40, radius: 8),
  child: Text('圆弧过渡'),
)

// 矩形切角 + 圆弧过渡
ChamferedContainer(
  color: Colors.red,
  topLeftChamfer: ChamferSize(width: 60, height: 30, radius: 10),
  child: Text('矩形切角圆弧'),
)

// 四角圆弧过渡
ChamferedContainer(
  gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
  topLeftChamfer: ChamferSize.all(24, radius: 6),
  topRightChamfer: ChamferSize.all(24, radius: 6),
  bottomLeftChamfer: ChamferSize.all(24, radius: 6),
  bottomRightChamfer: ChamferSize.all(24, radius: 6),
  child: Text('四角圆弧'),
)
```

#### 2. 圆角

```dart
// 单个圆角
ChamferedContainer(
  color: Colors.purple,
  topLeftChamfer: ChamferSize(radius: 20),  // width=0, height=0
  child: Text('左上圆角'),
)

// 四角圆角
ChamferedContainer(
  gradient: LinearGradient(colors: [Colors.cyan, Colors.teal]),
  topLeftChamfer: ChamferSize(radius: 20),
  topRightChamfer: ChamferSize(radius: 20),
  bottomLeftChamfer: ChamferSize(radius: 20),
  bottomRightChamfer: ChamferSize(radius: 20),
  child: Text('四角圆角'),
)
```

#### 3. 混合使用

```dart
// 切角+圆弧 混合 圆角
ChamferedContainer(
  gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
  topLeftChamfer: ChamferSize(width: 40, height: 20, radius: 8),  // 切角+圆弧
  topRightChamfer: ChamferSize(radius: 20),                       // 圆角
  bottomLeftChamfer: ChamferSize(radius: 20),                     // 圆角
  bottomRightChamfer: ChamferSize(width: 40, height: 20, radius: 8),  // 切角+圆弧
  child: Text('混合效果'),
)
```

#### 4. 对比示例

```dart
// 无圆弧 vs 有圆弧
ChamferedContainer(
  color: Colors.green,
  bottomLeftChamfer: ChamferSize.all(40),  // radius: 0（默认）
  child: Text('无圆弧'),
)

ChamferedContainer(
  color: Colors.green,
  bottomLeftChamfer: ChamferSize.all(40, radius: 10),
  child: Text('有圆弧'),
)
```

### 兼容性

- ✅ **完全向后兼容 v1.0.0**
- 默认 `radius = 0`，表现与 v1.0.0 完全一致
- 现有代码无需修改即可正常运行
- 可选择性地为任意角添加圆弧过渡或圆角
- 支持灵活混合：切角、切角+圆弧、圆角、直角

---

## 版本 1.0.0 (2025-11-08)

### 功能特性

✅ **核心功能**
- 支持四个角独立设置切角尺寸（topLeft, topRight, bottomLeft, bottomRight）
- 每个切角支持独立设置宽度和高度（矩形切角）
- 提供 `ChamferSize` 类用于定义切角尺寸
- 提供 `ChamferSize.all(size)` 快捷方法创建正方形切角

✅ **样式支持**
- 纯色背景 (`color`)
- 渐变背景 (`gradient`)
- 边框颜色和宽度 (`borderColor`, `borderWidth`)

✅ **布局控制**
- 自定义容器宽度和高度 (`width`, `height`)
- 内边距设置 (`padding`)

### API 说明

```dart
ChamferedContainer({
  required Widget child,          // 子组件
  Color? color,                   // 背景颜色
  Gradient? gradient,             // 渐变背景
  ChamferSize topLeftChamfer,     // 左上角切角
  ChamferSize topRightChamfer,    // 右上角切角
  ChamferSize bottomLeftChamfer,  // 左下角切角
  ChamferSize bottomRightChamfer, // 右下角切角
  Color? borderColor,             // 边框颜色
  double borderWidth,             // 边框宽度
  double? width,                  // 容器宽度
  double? height,                 // 容器高度
  EdgeInsetsGeometry? padding,    // 内边距
})
```

### 使用示例

```dart
// 正方形切角
ChamferedContainer(
  color: Colors.blue,
  bottomLeftChamfer: ChamferSize.all(24),
  child: Text('正方形切角'),
)

// 矩形切角（宽高独立）
ChamferedContainer(
  color: Colors.red,
  topLeftChamfer: ChamferSize(width: 40, height: 20),
  child: Text('矩形切角'),
)

// 渐变 + 多角切角
ChamferedContainer(
  gradient: LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
  ),
  topRightChamfer: ChamferSize(width: 50, height: 28),
  bottomLeftChamfer: ChamferSize(width: 50, height: 28),
  child: Text('渐变切角'),
)

// 边框样式
ChamferedContainer(
  color: Colors.white,
  borderColor: Colors.blue,
  borderWidth: 3,
  topLeftChamfer: ChamferSize.all(20),
  bottomRightChamfer: ChamferSize.all(20),
  child: Text('边框样式'),
)
```

### 技术实现

- 使用 `CustomPainter` 绘制切角形状
- 使用 `CustomClipper` 裁剪子组件
- 支持硬件加速渲染
- 优化的重绘逻辑

### 文件结构

```
lib/
├── widgets/
│   └── chamfered_container.dart    # 组件核心代码
└── examples/
    └── chamfered/
        └── pages/
            └── chamfered_demo_page.dart  # 示例页面
```

---

## 未来规划

### 可能的功能扩展
- 动画支持（切角尺寸动画过渡）
- 阴影效果（切角形状阴影）
- 更多预设样式
- 切角形状扩展（凹角、多边形等）

