# Flutter Widget Examples with Go Router

这个项目展示了一个使用 go_router 实现的易于扩展的路由系统。

## 路由系统特点

1. **易于扩展**: 只需要在 `router/router_config.dart` 中添加新的路由配置即可
2. **命名路由**: 使用命名路由避免硬编码路径
3. **清晰的结构**: 路由配置与页面组件分离

## 如何添加新的示例页面

1. 创建新的示例页面文件在 `lib/page/` 目录下
2. 在 `lib/router/router_config.dart` 中：
   - 在 `AppRoutes` 类中添加新的路由常量
   - 在 `GoRouter` 的 `routes` 列表中添加新的 `GoRoute`
   - 添加对应的 import 语句
3. 在 `lib/page/home_page.dart` 中的 `examples` 列表中添加新的示例项

## 路由配置说明

路由配置在 `lib/router/router_config.dart` 文件中：

```dart
final GoRouter routerConfig = GoRouter(
  routes: [
    // 主页路由
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    // 其他示例页面路由...
  ],
);
```

## 示例页面导航

主页 (`lib/page/home_page.dart`) 包含一个列表，展示了所有可用的示例页面。点击任意项即可导航到对应的示例页面。

## 运行项目

```bash
flutter pub get
flutter run
```
