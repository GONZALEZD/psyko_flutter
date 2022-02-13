import 'dart:typed_data';

import 'package:dgo_puzzle/game/level.dart';
import 'package:dgo_puzzle/service/levels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        constraints: const BoxConstraints.tightFor(height: 256),
        child: AnimatedContainer(
          margin: const EdgeInsets.all(12.0),
          transform: isSelected
              ? Matrix4.identity()
              : Matrix4.identity().scaled(0.9, 0.9),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade800,
                    offset: const Offset(0.0, 1.0),
                    blurRadius: isSelected ? 4.0 : 1.0,
                    spreadRadius: 0.0,
                    blurStyle: BlurStyle.solid)
              ]),
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 250),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(context),
                  Expanded(
                    child: _buildImage(context),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildLocation(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        level.fullName(Localizations.localeOf(context)) + "\n",
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(color: isSelected ? scheme.surface : scheme.onSurface),
      ),
    );
  }

  Widget _buildLocation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(7.0)),
        gradient: LinearGradient(
          colors: [Colors.black, Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter
        )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(
            Icons.location_pin,
            color: Colors.white,
          ),
          Flexible(
            child: Text(
              level.location,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: Levels.of(context).loadThumbnail(level),
      builder: (c, snapshot) {
        Widget child = const Center(child: CircularProgressIndicator());
        if (snapshot.hasData && snapshot.data != null) {
          child = Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
          );
        }
        return ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(8.0)),
          child: child,
        );
      },
    );
  }
}
