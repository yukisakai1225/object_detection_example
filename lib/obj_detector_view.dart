import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:obj_detection/camera_view.dart';
import 'package:obj_detection/object_detector_painter.dart';

class ObjDetectorView extends StatefulWidget {
  const ObjDetectorView({super.key});

  @override
  State<ObjDetectorView> createState() => _DetectorViewState();
}

class _DetectorViewState extends State<ObjDetectorView> {
  ObjectDetector? _objectDetector;
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;

  @override
  void initState() {
    _objectDetector = ObjectDetector(
      options: ObjectDetectorOptions(
        mode: DetectionMode.stream,
        classifyObjects: false,
        multipleObjects: false,
      ),
    );
    _canProcess = true;

    super.initState();
  }

  @override
  void dispose() {
    _objectDetector?.close();
    _objectDetector = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      processImage: _processImage,
      overlay: _customPaint,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (_objectDetector == null) return;
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {});
    final objects = await _objectDetector!.processImage(inputImage);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = ObjectDetectorPainter(
        objects,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
      );
      _customPaint = CustomPaint(painter: painter);
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
