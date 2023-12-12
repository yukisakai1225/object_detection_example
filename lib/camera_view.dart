import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class CameraView extends StatefulWidget with WidgetsBindingObserver {
  const CameraView({
    super.key,
    required this.processImage,
    this.overlay,
  });

  final Function(InputImage inputImage) processImage;

  final Widget? overlay;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? cameraController;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.max)
      ..initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).then((value) =>
          cameraController!.startImageStream((CameraImage image) async {
            final inputImage = _inputImageFromCameraImage(image);

            if (inputImage == null) return;
            widget.processImage(inputImage);
          }));
  }

  @override
  void dispose() {
    cameraController?.stopImageStream();
    cameraController?.dispose();
    cameraController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container();
    }

    return Center(
      child: CameraPreview(
        cameraController!,
        child: widget.overlay,
      ),
    );
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = cameras[0];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    if (rotation == null) return null;

    // Imageフォーマットを取得
    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    // サポートしているフォーマット:
    // * bgra8888 for iOS
    if (format == null || (format != InputImageFormat.bgra8888)) return null;

    // フォーマットがbgra8888しか対応していない、1つのプレーンしか持たない
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // Androidのみで使用される
        format: format, // iOSのみで使用される
        bytesPerRow: plane.bytesPerRow, // iOSのみで使用される
      ),
    );
  }
}
