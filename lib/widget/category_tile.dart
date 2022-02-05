import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String title;
  final Widget icon;

  const CategoryTile({Key? key, required this.icon, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title),
    );
  }
}
