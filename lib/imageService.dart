import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_me/UserState.dart';

class ImageService with ChangeNotifier {
  FirebaseStorage storage = FirebaseStorage.instance;
  String _imageUrl;
  UserState _userState;

  get imageUrl => _imageUrl;

  set userState(UserState userState) {
    this._userState = userState;
    if (_userState.isAuthenticated()) _updateImageUrl();
    else{
      _imageUrl = null;
      notifyListeners();
    }
  }

  Future<void> _updateImageUrl() async {
    _imageUrl =
    await storage.ref('avatars').child(_userState.useId).getDownloadURL();
    notifyListeners();
  }

  Future<bool> pickAndUploadImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) {
      return false;
    }
    File file = File(result.files.single.path);
    try {
      await storage.ref("avatars").child(_userState.useId).putFile(file);
      _updateImageUrl();
    } catch (e) {
      print(e);
    }
    return true;
  }
}
