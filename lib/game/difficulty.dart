import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Difficulty { easy, medium, hard }

extension BoardDifficulty on Difficulty {
  int get boardSide  {
    switch(this) {
      case Difficulty.easy : return 3;
      case Difficulty.medium: return 4;
      case Difficulty.hard: return 5;
    }
  }

  Color get associatedColor {
    switch(this) {
      case Difficulty.easy : return Colors.lightBlue;
      case Difficulty.medium: return Colors.amberAccent;
      case Difficulty.hard: return Colors.redAccent;
    }
  }

  String localizedName(BuildContext context) {
    final localizedStrings = AppLocalizations.of(context)!;
    switch(this) {
      case Difficulty.hard: return localizedStrings.game_difficulty_hard;
      case Difficulty.medium: return localizedStrings.game_difficulty_medium;
      case Difficulty.easy: return localizedStrings.game_difficulty_easy;
    }
  }
}