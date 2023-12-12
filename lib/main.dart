import 'dart:io';

import 'package:flutter/material.dart';
import 'package:obj_detection/obj_detector_view.dart';

void main() {
  // Android実機で動作確認できていないのでサポートしない
  if (Platform.isAndroid) {
    runApp(const AndroidBlock());
    return;
  }

  runApp(const MyApp());
}

class AndroidBlock extends StatelessWidget {
  const AndroidBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Center(
        child: Text('Android is not supported.'),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ObjDetectorView(),
    );
  }
}
