import 'dart:typed_data';

import 'package:dgo_puzzle/game/level.dart';
import 'package:dgo_puzzle/provider/levels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnLevelSelected = void Function(Level level);

class LevelListviewItem extends StatelessWidget {
  final Level level;
  final OnLevelSelected onLevelSelected;
  final bool isSelected;

  const LevelListviewItem({
    Key? key,
    required this.level,
    this.isSelected = false,
    required this.onLevelSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onLevelSelected(level),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          width: 180,
          height: 240,
        ),
        child: AnimatedContainer(
          margin: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              color: (isSelected)
                  ? Colors.lightBlue.shade100
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 30.0,
                    spreadRadius: 0.0,
                    blurStyle: BlurStyle.solid)
              ]),
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 250),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(level.fullName(Localizations.localeOf(context))),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Theme.of(context).primaryColor,
                    ),
                    Flexible(
                      child: Text(
                        level.location,
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor),
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: _buildImage(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: Levels.of(context).loadThumbnail(level),
      builder: (c, snapshot) {
        Widget child = const SizedBox.shrink();
        if (snapshot.hasData && snapshot.data != null) {
          child = Image.memory(snapshot.data!);
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: child,
          ),
        );
      },
    );
  }
}
