import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LayoutAction {
  final int id;
  final String name;
  final IconData icon;
  final String routeName;

  LayoutAction({
    required this.id,
    required this.name,
    required this.icon,
    required this.routeName,
  });
}

enum LayoutActionRendering {
  bottomBar,
  navBar,
  drawer,
  inBody,
}

typedef LayoutActionRenderingBuilder = LayoutActionRendering Function(
    LayoutAction action,
    TargetPlatform platform,
    Size screenSize,
    Orientation orientation);
typedef ActionCallback = Function(LayoutAction);

typedef LayoutBodyBuidler = Widget Function(
    TargetPlatform platform, List<LayoutAction> actions);

class LayoutScaffold extends StatelessWidget {
  final List<LayoutAction> actions;
  final LayoutActionRenderingBuilder actionBuilder;
  final ActionCallback actionCallback;
  final Color selectedActionTint;
  final int selectedActionIndex;
  final Widget navigationTitle;
  final LayoutBodyBuidler bodyBuilder;

  const LayoutScaffold({
    Key? key,
    required this.actions,
    required this.actionCallback,
    required this.actionBuilder,
    required this.selectedActionTint,
    required this.navigationTitle,
    required this.bodyBuilder,
    required this.selectedActionIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final orientation = MediaQuery.of(context).orientation;
    final size = MediaQuery.of(context).size;
    final actionRendering = actions.asMap().map((_, value) =>
        MapEntry(value, actionBuilder(value, platform, size, orientation)));
    actionsFinder(LayoutActionRendering type) {
      return actionRendering.entries
          .where((element) => element.value == type)
          .map((entry) => entry.key)
          .toList();
    }

    final bottomActions = actionsFinder(LayoutActionRendering.bottomBar);
    final navActions = actionsFinder(LayoutActionRendering.navBar);
    final bodyActions = actionsFinder(LayoutActionRendering.inBody);
    final drawerActions = actionsFinder(LayoutActionRendering.drawer);
    switch (platform) {
      case TargetPlatform.iOS:
        return CupertinoPageScaffold(
          navigationBar: buildAppBar(
              context, platform, navActions, drawerActions.isNotEmpty),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              bodyBuilder(platform, bodyActions),
              if (bodyActions.isNotEmpty)
                buildBottomBar(
                    actions[selectedActionIndex], platform, bottomActions),
            ],
          ),
        );
      default:
        return Scaffold(
          appBar: buildAppBar(
              context, platform, navActions, drawerActions.isNotEmpty),
          bottomNavigationBar: buildBottomBar(
              actions[selectedActionIndex], platform, bottomActions),
          body: bodyBuilder(platform, bodyActions),
        );
    }
  }

  Widget buildBottomBar(LayoutAction selected, TargetPlatform platform,
      List<LayoutAction> actions) {
    final items = actions
        .map((action) => BottomNavigationBarItem(
              icon: Icon(action.icon),
              label: action.name,
            ))
        .toList();
    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoTabBar(
          currentIndex: actions.indexOf(selected),
          activeColor: selectedActionTint,
          onTap: (index) => actionCallback(actions[index]),
          items: items,
        );
      default:
        return BottomNavigationBar(
          enableFeedback: true,
          selectedItemColor: selectedActionTint,
          onTap: (index) => actionCallback(actions[index]),
          items: items,
          currentIndex: actions.indexOf(selected),
        );
    }
  }

  dynamic buildAppBar(BuildContext context, TargetPlatform platform,
      List<LayoutAction> actions, bool addDrawerAction) {
    List<Widget> items = actions
        .map((action) => GestureDetector(
              onTap: () => actionCallback(action),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(action.icon),
              ),
            ))
        .toList();
    if (addDrawerAction) {
      items.add(GestureDetector(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(Icons.menu),
        ),
      ));
    }
    switch (platform) {
      case TargetPlatform.iOS:
        return CupertinoNavigationBar(
          middle: navigationTitle,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: items,
          ),
        );
      default:
        return AppBar(
          title: navigationTitle,
          actions: items,
        );
    }
  }
}
