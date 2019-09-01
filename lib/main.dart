import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/facePage.dart';
import 'stateModel/appstate.dart';

List<CameraDescription> cameras;
Future<void> main() async{
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }

    runApp(MyApp());
}
void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
class MyApp extends StatelessWidget {
final  AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
        builder: (_) => _appState,
        child :MaterialApp(
      title: 'Firebase Ml Vision',
      theme: ThemeData(
       primarySwatch: Colors.blue,
      ),
      home: FacePage()
    ));
  }
}
