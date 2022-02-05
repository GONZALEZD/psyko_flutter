import 'package:dgo_puzzle/game/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum UserProfileAttribute {
  name,
  email
}

enum ConnectionStatus {
  connected,
  errorUnknownUser,
  errorWrongPassword,
  errorInvalidEmail,
  errorUserDisabled,
  unknown,
}

enum AccountCreationStatus {
  createdSuccessfully,
  errorEmailAlreadyInUse,
  errorInvalidEmail,
  errorOperationNotAllowed,
  errorWeakPassword,
  errorUnknown,
}


class UserLogin extends InheritedModel<UserProfileAttribute> {
  final FirebaseAuth _authenticator;
  UserProfile profile;

  UserLogin({required FirebaseAuth authenticator, required Widget child})
      : _authenticator = authenticator,
        profile = UserProfile.anonymous,
        super(child: child);

  @override
  bool updateShouldNotify(covariant UserLogin oldWidget) {
    return profile != oldWidget.profile;
  }

  @override
  bool updateShouldNotifyDependent(
      covariant UserLogin oldWidget, Set<UserProfileAttribute> dependencies) {
    return dependencies.fold(false, (status, element) {
      switch(element) {
        case UserProfileAttribute.name: {
          return status || profile.name != oldWidget.profile.name;
        }
        case UserProfileAttribute.email: {
          return status || profile.email != oldWidget.profile.email;
        }
      }
    });
  }

  static UserLogin of(BuildContext context) =>
      InheritedModel.inheritFrom<UserLogin>(context)!;

  Future<ConnectionStatus> login({required String email, required String password}) async {
    try {
      final userCredential = await _authenticator.signInWithEmailAndPassword(
          email: email, password: password);

      final name = userCredential.user?.displayName ?? "???";
      profile = UserProfile(
          name: name,
          email: email,
          id: userCredential.user?.uid ?? "");
      return Future.value(ConnectionStatus.connected);
    } on FirebaseAuthException catch (e) {
      ConnectionStatus status = ConnectionStatus.unknown;
      switch (e.code) {
        case 'invalid-email' : {
          status = ConnectionStatus.errorInvalidEmail;
          break;
        }
        case 'user-disabled' : {
          status = ConnectionStatus.errorUserDisabled;
          break;
        }
        case 'user-not-found' : {
          status = ConnectionStatus.errorUnknownUser;
          break;
        }
        case 'wrong-password' : {
          status = ConnectionStatus.errorWrongPassword;
          break;
        }
      }
      return Future.value(status);
    }
  }

  Future<AccountCreationStatus> createAccount({required String email, required String password, required String playerName}) async {
    try {
      final credential = await _authenticator
          .createUserWithEmailAndPassword(email: email, password: password);
      credential.user?.updateDisplayName(playerName);
      return AccountCreationStatus.createdSuccessfully;
    } on FirebaseAuthException catch(e) {
      switch(e.code) {
        case "email-already-in-use" : return AccountCreationStatus.errorEmailAlreadyInUse;
        case "invalid-email" : return AccountCreationStatus.errorInvalidEmail;
        case "operation-not-allowed" : return AccountCreationStatus.errorOperationNotAllowed;
        case "weak-password" : return AccountCreationStatus.errorWeakPassword;
      }
      return AccountCreationStatus.errorUnknown;
    }
  }
}