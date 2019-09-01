import 'dart:math';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'dart:ui';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ml_kit/stateModel/appstate.dart';

class FacePainter extends CustomPainter {
  FacePainter(this.img, this.face, this.state);
  final AppState state;
  final List<Face> face;

  ui.Image img;
  Future<ui.Image> loadImgage() async {
    final data = await state.getImage.readAsBytes();
    return await decodeImageFromList(data);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(img, Offset.zero, Paint());
    for (var i = 0; i < state.getfaceList.length; i++) {
      final rect = _scaleRect(
          rect: face[i].boundingBox, imageSize: size, widgetSize: size);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = Colors.yellow;
      // canvas.drawCircle(rect.center, rect.height/2, paint);
      final lipPaint = Paint()
        ..strokeWidth = 5.0
        ..color = Colors.red;
      var leftEye = face[i].getLandmark(FaceLandmarkType.leftEye).position;
      var rightEye = face[i].getLandmark(FaceLandmarkType.rightEye).position;
      var nose = face[i].getLandmark(FaceLandmarkType.noseBase).position;
      var bottomMouth =
          face[i].getLandmark(FaceLandmarkType.bottomMouth).position;
      var leftmouth = face[i].getLandmark(FaceLandmarkType.leftMouth).position;
      var rightmouth =
          face[i].getLandmark(FaceLandmarkType.rightMouth).position;
      var leftCheek = face[i].getLandmark(FaceLandmarkType.leftCheek).position;
      var rightcheek =
          face[i].getLandmark(FaceLandmarkType.rightCheek).position;
      drawFaceMark(canvas, leftEye, size, lipPaint);
      drawFaceMark(canvas, rightEye, size, lipPaint);
      drawFaceMark(canvas, nose, size, lipPaint);
      drawFaceMark(canvas, bottomMouth, size, lipPaint);
      drawFaceMark(canvas, leftmouth, size, lipPaint);
      drawFaceMark(canvas, rightmouth, size, lipPaint);
      drawFaceMark(canvas, leftCheek, size, lipPaint);
      drawFaceMark(canvas, rightcheek, size, lipPaint);

      final smilePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = rect.height * .07
        ..color = Colors.red;

      drawSmile(canvas, rect, size, smilePaint);
      drawMarks(canvas, rect, leftEye, size);
      drawMarks(canvas, rect, rightEye, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawFaceMark(
      Canvas canvas, Point<double> point, Size size, Paint paint) {
    List<Offset> offset = [Offset(point.x, point.y)];
    //?  Face points
    //canvas.drawPoints(PointMode.points, _scalePoints( offsets: offset, imageSize: size, widgetSize: size), paint);
  }

  void drawSmile(Canvas canvas, Rect rect, Size size, Paint paint) {
    var center = rect.center;
    var radius = math.min(rect.height, rect.width);
    final smilePaint = Paint()..color = Colors.yellow;
    final eyePaint = Paint()..color = Colors.black;
    //? Face backgroung filled yellow circle
    canvas.drawCircle(center, rect.height / 2, smilePaint);

    //? Smile
    canvas.drawArc(
        Rect.fromCenter(center: center, width: radius / 2, height: radius / 2),
        0,
        math.pi,
        false,
        paint);
  }

  void drawMarks(Canvas canvas, Rect rect, Point<double> point, Size size) {
    final eyePaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(point.x, point.y), rect.height * .1, eyePaint);
  }

  Rect _scaleRect({
    @required Rectangle rect,
    @required Size imageSize,
    @required Size widgetSize,
  }) {
    final double scaleX = widgetSize.width / imageSize.width;
    final double scaleY = widgetSize.height / imageSize.height;

    return Rect.fromLTRB(
      rect.left.toDouble() * scaleX,
      rect.top.toDouble() * scaleY,
      rect.right.toDouble() * scaleX,
      rect.bottom.toDouble() * scaleY,
    );
  }

  List<Offset> _scalePoints({
    List<Offset> offsets,
    @required Size imageSize,
    @required Size widgetSize,
  }) {
    final double scaleX = widgetSize.width / imageSize.width;
    final double scaleY = widgetSize.height / imageSize.height;
    return offsets
        .map((offset) => Offset(offset.dx * scaleX, offset.dy * scaleY))
        .toList();
  }
}
