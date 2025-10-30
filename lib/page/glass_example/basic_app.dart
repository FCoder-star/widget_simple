import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:rivership/rivership.dart';
import 'package:widget_simple/page/glass_example/shared.dart';
import 'package:widget_simple/page/glass_example/widgets/bottom_bar.dart';

void main() {
  runApp(CupertinoApp(home: BasicApp()));
}

final settingsNotifier = ValueNotifier(
  LiquidGlassSettings(
    thickness: 20,
    blur: 10,
    refractiveIndex: 1.2,
    lightIntensity: .8,
    saturation: 1.2,
    lightAngle: pi / 4,
    glassColor: Colors.white.withValues(alpha: 0.2),
  ),
);

class BasicApp extends HookWidget {
  const BasicApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tab = useState(0);
    final fake = useState(false);

    final light = useRotatingAnimationController();

    return GestureDetector(
      onTap: () {
        SettingsSheet(
          settingsNotifier: settingsNotifier,
          lightAngleAnimation: light,
        ).show(context);
      },
      child: CupertinoPageScaffold(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            fit: BoxFit.cover,
                            'https://picsum.photos/1000/500?random=$index',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: CupertinoSwitch(
                  value: fake.value,
                  onChanged: (v) => fake.value = v,
                ),
              ),
            ),
            Center(
              child: ListenableBuilder(
                listenable: Listenable.merge([settingsNotifier, light]),
                builder: (context, child) {
                  final settings = settingsNotifier.value.copyWith(
                    glassColor: CupertinoTheme.of(
                      context,
                    ).barBackgroundColor.withValues(alpha: 0.4),
                  );
                  return LiquidGlassLayer(
                    fake: fake.value,
                    settings: settings.copyWith(lightAngle: light.value),
                    child: Column(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 16,
                          children: [
                            LiquidStretch(
                              child: LiquidGlass.inLayer(
                                shape: LiquidRoundedSuperellipse(
                                  borderRadius: Radius.circular(20),
                                ),
                                child: GlassGlow(
                                  child: SizedBox.square(
                                    dimension: 100,
                                    child: Center(
                                      child: fake.value
                                          ? Text('FAKE')
                                          : Text('REAL'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            LiquidStretch(
                              child: LiquidGlass.inLayer(
                                shape: LiquidRoundedSuperellipse(
                                  borderRadius: Radius.circular(20),
                                ),
                                child: GlassGlow(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    child: SizedBox.square(
                                      dimension: 100,
                                      child: Center(
                                        child: fake.value
                                            ? Text('FAKE')
                                            : Text('REAL'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        LiquidStretch(
                          child: LiquidGlass.inLayer(
                            shape: LiquidRoundedSuperellipse(
                              borderRadius: Radius.circular(20),
                            ),
                            child: GlassGlow(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                child: SizedBox(
                                  width: 400,
                                  height: 64,
                                  child: Center(
                                    child: fake.value
                                        ? Text('FAKE')
                                        : Text('REAL'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: LiquidGlassBottomBar(
                  fake: fake.value,
                  extraButton: LiquidGlassBottomBarExtraButton(
                    icon: CupertinoIcons.add_circled,
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => CupertinoPageScaffold(
                            child: SizedBox(),
                            navigationBar: CupertinoNavigationBar.large(),
                          ),
                        ),
                      );
                    },
                    label: '',
                  ),
                  tabs: [
                    LiquidGlassBottomBarTab(
                      label: 'Home',
                      icon: CupertinoIcons.home,
                    ),
                    LiquidGlassBottomBarTab(
                      label: 'Profile',
                      icon: CupertinoIcons.person,
                    ),
                    LiquidGlassBottomBarTab(
                      label: 'Settings',
                      icon: CupertinoIcons.settings,
                    ),
                  ],
                  selectedIndex: tab.value,
                  onTabSelected: (index) {
                    tab.value = index;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Blink extends StatelessWidget {
  const Blink({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SequenceMotionBuilder(
      converter: SingleMotionConverter(),
      sequence: StepSequence.withMotions([
        (0.0, Motion.linear(Duration(seconds: 1))),
        (1.0, Motion.linear(Duration(seconds: 1))),
        (1.0, Motion.linear(Duration(seconds: 1))),
      ], loop: LoopMode.loop),
      builder: (context, value, phase, child) =>
          Opacity(opacity: value, child: child),
      child: child,
    );
  }
}
