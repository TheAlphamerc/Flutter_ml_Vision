import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  AppState();
  List<Face> _face = [];
  File _file;
  ui.Image _image;
  List<Face> get getfaceList {
    print('getfaceList face count [${_face.length}]');
    return List.from(_face);
  }

  set setFaceList(List<Face> face) {
    _face = face;
    notifyListeners();
    print('setFaceList face count [${_face.length}]');
  }

  File get getImage {
    print('getFile');
    return _file;
  }

  set setImage(File file) {
    _file = file;
    loadImgage();
  }

  ui.Image get getUIImage {
    print('getImage');
    return _image;
  }

  Future<ui.Image> loadImgage() async {
    final data = await _file.readAsBytes();
    _image = await decodeImageFromList(data);
    print('setImage');
    return _image;
  }
}
