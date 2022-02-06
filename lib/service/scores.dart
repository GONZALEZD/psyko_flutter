import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dgo_puzzle/game/difficulty.dart';
import 'package:dgo_puzzle/game/score.dart';
import 'package:flutter/widgets.dart';

class PlayerScore extends InheritedModel<String> {
  final FirebaseFirestore _store;

  PlayerScore({required FirebaseFirestore store, required Widget child})
      : _store = store,
        super(child: child);

  @override
  bool updateShouldNotify(covariant PlayerScore oldWidget) => false;

  @override
  bool updateShouldNotifyDependent(
      covariant PlayerScore oldWidget, Set<String> dependencies) {
    return false;
  }

  Future<void> uploadWin(Score data) async {
    await _store.collection("scores").doc().set(data.toMap());
  }

  Future<List<Score>> scoresBoard() async {
    request(Difficulty difficulty) async {
      return _store
          .collection("scores")
          .where("difficulty", isEqualTo: difficulty.index)
          .orderBy("score", descending: true)
          .limit(20)
          .get();
    }

    final easy = await request(Difficulty.easy);
    final medium = await request(Difficulty.medium);
    final hard = await request(Difficulty.hard);
    final data = [...hard.docs, ...medium.docs, ...easy.docs]
        .map((snap) => Score.fromMap(snap.data()))
        .toList();
    return data;
  }

  static PlayerScore of(BuildContext context) =>
      InheritedModel.inheritFrom<PlayerScore>(context)!;
}
