import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FacePage extends StatefulWidget {
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  List<Face> _faces;
  File _imageFile;

  void _processImage(File imageFile)async {
  final image = FirebaseVisionImage.fromFile(imageFile);
  final faceDetector = FirebaseVision.instance.faceDetector(
    FaceDetectorOptions(
      mode: FaceDetectorMode.accurate,
      )
  );
  if(image != null){
    var faces = await faceDetector.processImage(image);
    setState(() {
      _faces = faces;
      _imageFile = imageFile;
    });
  }
}
 void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Use Camera'),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                )
              ],
            ),
          );
        });
  }
   void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400).then((File file) {
      setState(() {
        _processImage(file);
      });
      Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HEllo'),
      ),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){_openImagePicker(context);},
        tooltip: 'Pick an image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

