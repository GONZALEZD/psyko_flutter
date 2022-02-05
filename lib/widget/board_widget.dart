import 'package:dgo_puzzle/animations/board_state.dart';
import 'package:dgo_puzzle/animations/tween_board.dart';
import 'package:flutter/widgets.dart';

class BoardWidget extends StatelessWidget {
  final int side;
  final List<Widget> tiles;
  final Animation<BoardState>? animation;

  const BoardWidget(
      {Key? key, required this.side, required this.tiles, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _EngineDelegate(
        side: side,
        animation:
            animation ?? AlwaysStoppedAnimation(BoardState.identity(side)),
      ),
      children: tiles,
    );
  }
}

class _EngineDelegate extends FlowDelegate {
  final int side;
  Animation<BoardState> animation;

  _EngineDelegate({required this.side, required this.animation})
      : super(repaint: animation);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    final parentSize = getSize(constraints);
    double childSide = parentSize.shortestSide / side;
    return BoxConstraints.tight(Size.square(childSide));
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double paddingLeft = (context.size.width - context.size.shortestSide) / 2;
    double paddingTop = (context.size.height - context.size.shortestSide) / 2;

    for (var tileState in animation.value.tiles.reversed) {
      context.paintChild(
        tileState.id,
        transform: Matrix4.translationValues(
            paddingLeft + context.size.shortestSide * tileState.dx,
            paddingTop + context.size.shortestSide * tileState.dy,
            0.0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => true;
}
