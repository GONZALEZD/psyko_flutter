import 'package:flutter/material.dart';

class WebAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final List<Widget> centeredActions;

  const WebAppBar(
      {Key? key,
        required this.title,
        this.actions,
        required this.centeredActions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _buildTitle(context),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _addMargin(centeredActions),
          ),
          if ((actions?.length ?? 0) > 0)
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: _addMargin(actions!),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _addMargin(List<Widget> list) {
    return list
        .map((item) => Padding(
      child: item,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    ))
        .toList();
  }

  Widget _buildTitle(BuildContext context) {
    final textStyle =
        Theme.of(context).appBarTheme.titleTextStyle ?? const TextStyle();
    return DefaultTextStyle(style: textStyle, child: title);
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}