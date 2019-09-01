import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ml_kit/stateModel/appstate.dart';
import 'package:flutter_ml_kit/utility/camera_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'imageAndFaces.dart';

class FacePage extends StatefulWidget {
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  CameraController controller;
  List<Face> _faces;
  bool _isImageLoadSuccess = false;
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    CameraDescription description = cameras[0];
    getCamera(CameraLensDirection.front).then((desc) => {description = desc});
    try {
      controller = CameraController(description, ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        } else {
          print('Camera initilised success');
        }
        setState(() {});
      });
    } on CameraException catch (error) {
      print('Error :  $error , ${error?.description}');
    }
    super.initState();
  }

  void _processImage(File imageFile, AppState state) async {
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
        FaceDetectorOptions(
            mode: FaceDetectorMode.accurate,
            enableLandmarks: true,
            enableTracking: true));
    if (image != null) {
      var faces = await faceDetector.detectInImage(image);
      setState(() {
        if (mounted) {
          print('Found face in image face count [${faces.length}]');
          state.setFaceList = faces;
          state.setImage = imageFile;
          _faces = faces;
        }
      });
      var uiImage = await state.loadImgage();
      setState(() {
        _isImageLoadSuccess = !_isImageLoadSuccess;
      });
    }
  }

  void _openImagePicker(BuildContext context, AppState state) {
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
                    _getImage(context, ImageSource.camera, state);
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery, state);
                  },
                )
              ],
            ),
          );
        });
  }

  void _getImage(BuildContext context, ImageSource source, AppState state) {
    ImagePicker.pickImage(source: source, maxWidth: 400).then((File file) {
      setState(() {
        _processImage(file, state);
      });
      Navigator.pop(context);
    });
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appstate, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Face Detection'),
        ),
        body: _faces == null
            ? Container(
                height: MediaQuery.of(context).size.height,
                child: _cameraPreviewWidget(),
              )
            : _isImageLoadSuccess
                ? ImageAndFaces(appState: appstate)
                : ImageAndFaces(appState: appstate),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _openImagePicker(context, appstate);
          },
          tooltip: 'Pick an image',
          child: Icon(Icons.add_a_photo),
        ),
      );
    });
  }
}
