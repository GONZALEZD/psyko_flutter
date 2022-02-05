import 'package:dgo_puzzle/animations/board_state.dart';
import 'package:dgo_puzzle/animations/tween_board.dart';
import 'package:flutter/widgets.dart';

extension TweenBoardSequence on List<BoardState> {
  TweenSequence<BoardState> toSequence() {
    List<TweenSequenceItem<BoardState>> sequenceItems = [];
    for (int i = 1; i < length; i++) {
      sequenceItems.add(TweenSequenceItem(
        tween: TweenBoard(begin: this[i - 1], end: this[i]),
        weight: 1,
      ));
    }
    return TweenSequence(sequenceItems);
  }
}