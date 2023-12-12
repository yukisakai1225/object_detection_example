import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ObjectDetectorPainter extends CustomPainter {
  ObjectDetectorPainter(
    this._objects,
    this.imageSize,
  );

  final List<DetectedObject> _objects;
  final Size imageSize;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.lightGreenAccent;

    final Paint background = Paint()..color = const Color(0x99000000);

    for (final DetectedObject detectedObject in _objects) {
      final ParagraphBuilder builder = ParagraphBuilder(
        ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 16,
            textDirection: TextDirection.ltr),
      );
      builder.pushStyle(
          ui.TextStyle(color: Colors.lightGreenAccent, background: background));
      builder.pop();

      final left = _translateX(
        detectedObject.boundingBox.left,
        size,
        imageSize,
      );
      final top = _translateY(
        detectedObject.boundingBox.top,
        size,
        imageSize,
      );
      final right = _translateX(
        detectedObject.boundingBox.right,
        size,
        imageSize,
      );
      final bottom = _translateY(
        detectedObject.boundingBox.bottom,
        size,
        imageSize,
      );

      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint,
      );

      canvas.drawParagraph(
        builder.build()
          ..layout(ParagraphConstraints(
            width: (right - left).abs(),
          )),
        Offset(left, top),
      );
    }
  }

  double _translateX(
    double x,
    Size canvasSize,
    Size imageSize,
  ) {
    return x * canvasSize.width / imageSize.width;
  }

  double _translateY(
    double y,
    Size canvasSize,
    Size imageSize,
  ) {
    return y * canvasSize.height / imageSize.height;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
