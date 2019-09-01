import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ml_kit/stateModel/appstate.dart';
import 'package:provider/provider.dart';
import 'helper/customPainter.dart';

class ImageAndFaces extends StatefulWidget {
  // ui.Image image;
  final AppState appState;
  ImageAndFaces({this.appState});
  _ImageAndFacesState createState() => _ImageAndFacesState();
}

class _ImageAndFacesState extends State<ImageAndFaces> {
  List<Face> faces;
  ui.Image image;
  ui.Image _image;
  File imageFile;
  @override
  void initState() {
    _image = widget.appState.getUIImage;
    super.initState();
  }

  void initImage(AppState appState) async {
    await appState.loadImgage().then((img) {
      // setState(() {
      //   //image = img;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appstate, child) {
      if (appstate.getImage != null) {}
      return appstate.getImage == null
          ? Container()
          : Column(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Container(
                      constraints: BoxConstraints.expand(),
                      child: FittedBox(
                        child: SizedBox(
                          width: widget.appState.getUIImage?.width != null
                              ? widget.appState.getUIImage.width.toDouble()
                              : 0,
                          height: widget.appState.getUIImage?.width != null
                              ? widget.appState.getUIImage.height.toDouble()
                              : 0,
                          child: CustomPaint(
                            painter: FacePainter(widget.appState.getUIImage,
                                appstate.getfaceList, appstate),
                          ),
                        ),
                      )),
                ),
                Flexible(
                    flex: 1,
                    child: ListView(
                      children: appstate.getfaceList
                          .map<Widget>((f) => FaceCordinate(
                                face: f,
                              ))
                          .toList(),
                    )),
              ],
            );
    });
  }
}

class FaceCordinate extends StatelessWidget {
  const FaceCordinate({this.face});

  final Face face;

  @override
  Widget build(BuildContext context) {
    final pos = face.boundingBox;
    return Consumer<AppState>(builder: (context, appstate, child) {
      return Container(
        child: ListTile(
          title:
              Text('${pos.top} , ${pos.left} , ${pos.bottom} , ${pos.right}'),
        ),
      );
    });
  }
}
