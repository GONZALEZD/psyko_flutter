import 'package:flutter/material.dart';

class ActionData {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  ActionData({required this.name, required this.icon, required this.onTap});

  Widget buildAsLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: onTap,
        child: Text(name),
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(120, 40)),
            textStyle: MaterialStateProperty.all(
                const TextStyle(fontWeight: FontWeight.w500)),
            foregroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onBackground),
            shape: MaterialStateProperty.all(null),
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).toggleableActiveColor.withOpacity(0.1)),
            side: MaterialStateProperty.all(BorderSide.none)),
      ),
    );
  }

  Widget buildAsIcon(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      tooltip: name,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
    );
  }
}
