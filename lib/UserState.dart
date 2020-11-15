
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum Status { Authenticated, Authenticating, Unauthenticated }

class UserState with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status;

  Status get status => _status;

  User get user => _user;

  String get useId => _user.email;

  bool isAuthenticated() => _status == Status.Authenticated;

  bool isAuthenticating() => _status == Status.Authenticating;

  UserState.instance() {
    _status = Status.Unauthenticated;
    _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> singIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> singUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future singOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}
