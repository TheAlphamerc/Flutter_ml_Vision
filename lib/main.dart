import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ml_kit/pages/faecPage.dart';
import 'package:flutter_ml_kit/utils/camera_util.dart';

import 'pages/faceContourDetectionPage.dart';

Future<void> main()async {
  CameraDescription cameras;
  try {
     cameras = await  getCamera(CameraLensDirection.front);
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
   runApp(MyApp(cameraDescription: cameras));

}
void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
class MyApp extends StatelessWidget {
  final CameraDescription cameraDescription;
  MyApp({this.cameraDescription});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FaceContourDetectionScreen(cameraDescription: cameraDescription),
    );
  }
}