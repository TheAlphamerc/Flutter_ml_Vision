import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ml_kit/stateModel/appstate.dart';
import 'package:provider/provider.dart';

import 'helper/customPainter.dart';

class ImageAndFaces extends StatefulWidget {
   ImageAndFaces({this.faces, this.appState});

   final AppState  appState;
   final List<Face> faces;
    File imageFile;

  _ImageAndFacesState createState() => _ImageAndFacesState();
}

class _ImageAndFacesState extends State<ImageAndFaces> {
  AppState  appState;
   List<Face> faces;
  ui.Image image;
  File imageFile;

  @override
  void initState() {
    appState = widget.appState;
    // faces = widget.faces;
    // imageFile = widget.imageFile;
     faces = appState.getfaceList;
     imageFile = appState.getImage;
    initImage();
    super.initState();
  }

  void initImage() async{
    image = await appState.loadImgage();
  }

  // Future<ui.Image> _loadImgage(File file)async{
  //   final data = await file.readAsBytes();
  //   return await decodeImageFromList(data);
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appstate, child) {
      initImage();
      return Column(
       children: <Widget>[
         Flexible(
           flex: 2,
           child: Container(
             constraints: BoxConstraints.expand(),
             child: FittedBox(

               child: SizedBox(
                 width: image != null ? image.width.toDouble() : 0,
                 height: image != null ? image.height.toDouble() : 0,
                 child: CustomPaint(
                   painter: FacePainter(image,appstate.getfaceList,appstate),
                 ),
               ),
             )// Image.file(imageFile,fit: BoxFit.cover,),
           ),),
         Flexible(
         flex: 1,
         child:  ListView(
           children: faces.map<Widget>((f)=>FaceCordinate(face: f,)).toList(),
         )
         ),
       ],
    );});
  }
}
class FaceCordinate extends StatelessWidget {
  const FaceCordinate({this.face});

  final Face face;

  @override
  Widget build(BuildContext context) {
    final pos = face.boundingBox;
   return Consumer<AppState>(builder: (context, appstate, child) { return Container(
      child: ListTile(
        title: Text('${pos.top} , ${pos.left} , ${pos.bottom} , ${pos.right}'),
      ),
    );});
  }
}