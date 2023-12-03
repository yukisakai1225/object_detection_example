import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// サンプルで定義
late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget with WidgetsBindingObserver {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CameraController? cameraController;

  @override
  void initState() {
    cameraController = CameraController(_cameras[0], ResolutionPreset.max)
      ..initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container();
    }

    cameraController!.startImageStream((image) async {
      final now = DateTime.now().millisecondsSinceEpoch;
      print("$now :  $image");
    });

    return MaterialApp(
      home: Center(
        child: CameraPreview(
          cameraController!,
        ),
      ),
    );
  }
}
