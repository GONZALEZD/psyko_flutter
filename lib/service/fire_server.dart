import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dgo_puzzle/service/levels.dart';
import 'package:dgo_puzzle/service/scores.dart';
import 'package:dgo_puzzle/service/user_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireServer extends InheritedWidget {
  final FirebaseApp _app;

  FireServer(
      {Key? key,
      required FirebaseApp app,
      required FirebaseFirestore database,
      required FirebaseStorage storage,
      required Widget child})
      : _app = app,
        super(
          key: key,
          child: UserLogin(
            authenticator: FirebaseAuth.instanceFor(app: app),
            child: Levels(
              database: database,
              storage: storage,
              child: PlayerScore(
                store: database,
                child: child,
              ),
            ),
          ),
        );

  @override
  bool updateShouldNotify(covariant FireServer oldWidget) {
    return oldWidget._app != _app;
  }
}
