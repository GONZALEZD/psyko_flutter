import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dgo_puzzle/game/level.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


class Levels extends InheritedModel<String> {
  final FirebaseFirestore _database;
  final FirebaseStorage _storage;
  List<Level> _levels;
  Map<String, Uint8List> _imagesCache;

  Levels({required FirebaseFirestore database, required FirebaseStorage storage, required Widget child})
      : _database = database,
        _storage = storage,
        _levels = [],
        _imagesCache = {},
        super(child: child);

  static Levels of(BuildContext context) =>
      InheritedModel.inheritFrom<Levels>(context)!;

  @override
  bool updateShouldNotify(covariant Levels oldWidget) {
    return _levels != oldWidget._levels;
  }

  @override
  bool updateShouldNotifyDependent(covariant Levels oldWidget, Set<String> dependencies) {
    return updateShouldNotify(oldWidget);
  }

  Future<List<Level>> retrieveLevels() async {
    if(_levels.isNotEmpty) {
      return _levels;
    }
    final data = await _database.collection("levels").get();
    print("Data:$data");
    print("Data size:${data.size}");
    _levels = data.docs.map((data) => _levelFromMap(data.id, data.data())).toList();
    return _levels;

  }

  Level _levelFromMap(String id, Map<String, dynamic> map) {
    print(map);
    return Level(
      id: id,
      puzzle: map["path"],
      location: map["location"],
      titleFr: map["titleFr"],
      titleEn: map["titleEn"],
      thumbnail: map["thumbnail"]
    );
  }

  Future<Uint8List> _loadFile({required String filename, required String folder}) async {
    if(!_imagesCache.containsKey(filename)) {
      print("Loading file ${filename}");
      final imageBytes = await _storage.ref().child(folder).child(filename).getData();
      _imagesCache[filename] = imageBytes!;
    }
    return Future.value(_imagesCache[filename]);
  }

  Future<Uint8List> loadThumbnail(Level level) async {
    return _loadFile(filename: level.thumbnail, folder: "thumbnail");
  }

  Future<Uint8List> loadPuzzle(Level level) async {
    // final imageBytes = await rootBundle.load("assets/chat__belle.gif");
    // return Future.value(imageBytes.buffer.asUint8List());
    return _loadFile(filename: level.puzzle, folder: "puzzle");
  }

  // Future<void> listExample() async {
  //   final result =
  //   await _storage.ref().listAll();
  //
  //   result.items.forEach((ref) {
  //     print('Found file: $ref');
  //   });
  //
  //   result.prefixes.forEach((ref) {
  //     print('Found directory: $ref');
  //   });
  // }
}