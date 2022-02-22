import 'package:debug_toolbox/src/widget/toolbox_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MaterialAppConfig {
  final bool showPerfOverlay;
  final TargetPlatform platform;
  final ThemeMode themeMode;
  final bool showBanner;
  final Map<ShortcutActivator, Intent> shortcuts;
  final Map<Type, Action<Intent>> actions;

  MaterialAppConfig({
    this.showPerfOverlay = false,
    required this.platform,
    required this.themeMode,
    this.showBanner = true,
    required this.shortcuts,
    required this.actions,
  });

  static MaterialAppConfig defaultConfig = MaterialAppConfig(
    platform: defaultTargetPlatform,
    themeMode: ThemeMode.system,
    shortcuts: {},
    actions: {},
  );

  MaterialAppConfig copyWith({
    bool? showPerfOverlay,
    TargetPlatform? platform,
    ThemeMode? themeMode,
    bool? showBanner,
    Map<ShortcutActivator, Intent>? shortcuts,
    Map<Type, Action<Intent>>? actions,
  }) {
    return MaterialAppConfig(
      showPerfOverlay: showPerfOverlay ?? this.showPerfOverlay,
      platform: platform ?? this.platform,
      themeMode: themeMode ?? this.themeMode,
      showBanner: showBanner ?? this.showBanner,
      shortcuts: shortcuts ?? this.shortcuts,
      actions: actions ?? this.actions,
    );
  }
}

class DebugToolbox extends ValueNotifier<MaterialAppConfig> {
  TargetPlatform get platform => value.platform;

  set platform(TargetPlatform platform) {
    value = value.copyWith(platform: platform);
    notifyListeners();
  }

  ThemeMode get themeMode => value.themeMode;

  set themeMode(ThemeMode mode) {
    value = value.copyWith(themeMode: mode);
    notifyListeners();
  }

  bool get showBanner => value.showBanner;

  set showBanner(bool show) {
    value = value.copyWith(showBanner: show);
    notifyListeners();
  }

  bool get displayFrames => value.showPerfOverlay;

  set displayFrames(bool display) {
    value = value.copyWith(showPerfOverlay: display);
    notifyListeners();
  }

  Map<ShortcutActivator, Intent> get shortcuts => value.shortcuts;

  set shortcuts(Map<ShortcutActivator, Intent> shortcuts) {
    value = value.copyWith(shortcuts: shortcuts);
    notifyListeners();
  }

  Map<Type, Action<Intent>> get actions => value.actions;

  set actions(Map<Type, Action<Intent>> actions) {
    value = value.copyWith(actions: actions);
    notifyListeners();
  }

  DebugToolbox() : super(MaterialAppConfig.defaultConfig);
}

class ShowToolboxIntent extends Intent {
  final DebugToolbox toolbox;

  const ShowToolboxIntent({required this.toolbox});
}

class CallbackIntent extends Intent {
  final VoidCallback callback;

  const CallbackIntent({required this.callback});
}

class ToolboxAction extends Action<CallbackIntent> {
  @override
  Object? invoke(CallbackIntent intent) {
    intent.callback.call();
  }
}

class ShowToolboxAction extends ContextAction<ShowToolboxIntent> {
  @override
  Object invoke(ShowToolboxIntent intent, [BuildContext? context]) {
    if (!kDebugMode) return Object();
    return showDialog(context: context!, builder: (c) => const ToolboxDialog());
  }
}
