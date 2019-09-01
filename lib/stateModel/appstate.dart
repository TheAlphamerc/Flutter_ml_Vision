import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier{
  AppState();
  List<Face> _face = [];
  File _image  ;
  List<Face> get  getfaceList{
    print('getfaceList face count [${_face.length}]');
    return List.from(_face);
  }
  set setFaceList(List<Face> face){
    _face = face;
    notifyListeners();
    print('setFaceList face count [${_face.length}]');
  }

  File get getImage {
    print('getImage');
    return _image;
  }
  set setImage(File file){
    _image = file;
    notifyListeners();
    print('setImage');
  }
  Future<ui.Image> loadImgage()async{
    final data = await _image.readAsBytes();
    return await decodeImageFromList(data);
  }
}