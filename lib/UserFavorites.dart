import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_me/UserState.dart';

class UserFavorites with ChangeNotifier {
  UserState _userState;
  FirebaseFirestore _firestore;
  DocumentReference _userDocRef;

  final _favoritesSet = Set<String>();

  void clear(){
    _favoritesSet.clear();
    notifyListeners();
  }

  UserFavorites update(UserState userState) {
    this._userState = userState;
    if (_userState.isAuthenticated()) {
      _userDocRef = _firestore.collection('users').doc(_userState.useId);
      updateFavoritesFromCloud();
    }
    return this;
  }

  void updateFavoritesFromCloud() {
    _userDocRef.get().then((snapshot) {
      if (snapshot.exists) {
        _favoritesSet.addAll(snapshot.data()['favorites'].cast<String>());
        notifyListeners();
      }
      updateFavoritesAtCloud();
    });
  }

  Set<String> get favorites => _favoritesSet;

  bool isFavorite(String name) => _favoritesSet.contains(name);

  UserFavorites.instance() {
    _firestore = FirebaseFirestore.instance;
  }

  void addFavorite(String name)  {
    _favoritesSet.add(name);
    notifyListeners();
    if (_userState.isAuthenticated()) {
       updateFavoritesAtCloud();
    }
  }

  Future<void> updateFavoritesAtCloud() {
    return _userDocRef.set(
      {'favorites': _favoritesSet.toList()},
    );
  }

  void removeFavorite(String name)  {
    _favoritesSet.remove(name);
    notifyListeners();
    if (_userState.isAuthenticated()) updateFavoritesAtCloud();
  }
}
