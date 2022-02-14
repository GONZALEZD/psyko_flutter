import 'package:flutter/material.dart';

class WebDialog extends StatelessWidget {
  final String title;
  final Size? size;

  static const DEFAULT_SIZE = Size(280, 400);

  final Widget content;

  const WebDialog(
      {Key? key, required this.title, required this.content, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      child: SizedBox.fromSize(
        size: size ?? DEFAULT_SIZE,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle(context),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 40.0),
          Expanded(
              child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.white),
          )),
          IconButton(
            onPressed: () => _onBackPressed(context),
            icon: const Icon(Icons.close),
            color: Colors.white,
          )
        ],
      ),
    );
  }

  void _onBackPressed(BuildContext context) {
    Navigator.of(context).maybePop();
  }
}
