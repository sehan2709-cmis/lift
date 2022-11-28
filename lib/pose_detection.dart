import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:lift/state_management/CameraState.dart';
import 'package:provider/provider.dart';

class PoseDetectionPage extends StatefulWidget {
  const PoseDetectionPage({super.key});

  @override
  State<PoseDetectionPage> createState() => _PoseDetectionPageState();
}

class _PoseDetectionPageState extends State<PoseDetectionPage> {
  List<CameraDescription> _cameras = <CameraDescription>[];
  List<CameraDescription> get cameras => _cameras;
  late CameraController camera;
  bool cameraReady = false;

  void _logError(String code, String? message) {
    if (message != null) {
      log('Error: $code\nError Message: $message');
    } else {
      log('Error: $code');
    }
  }

  @override
  Future<void> initState() async {
    super.initState();
    try {
      // WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      _logError(e.code, e.description);
      return;
    }
    camera = CameraController(_cameras[0], ResolutionPreset.max);
    camera.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      await camera.startImageStream((CameraImage image) => _processCameraImage(image));
      setState(() {
        cameraReady = true;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            log('User denied camera access.');
            break;
          default:
            log('Handle other errors.');
            break;
        }
      }
    });
  }
  final options = PoseDetectorOptions();
  final poseDetector = PoseDetector(options: PoseDetectorOptions());

  void _processCameraImage(CameraImage image) async {
    InputImage image2 = InputImage.fromBytes(
        bytes: image.planes[0].bytes,
      inputImageData: InputImageData(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        imageRotation: InputImageRotation.rotation0deg,
        inputImageFormat: InputImageFormat.yuv420,
        planeData: null,
      ),
    );
    final List<Pose> poses = await poseDetector.processImage(image2);

    for (Pose pose in poses) {
      // to access all landmarks
      pose.landmarks.forEach((_, landmark) {
        final type = landmark.type;
        final x = landmark.x;
        final y = landmark.y;
      });

      // to access specific landmarks
      final landmark = pose.landmarks[PoseLandmarkType.nose];
    }
    setState(() {
      inputImage = image;
    });
  }

  @override
  void dispose() {
    camera.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = camera;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // onNewCameraSelected(cameraController.description);
      log("onNewCameraSelected");
    }
  }

  CameraImage? inputImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: SafeArea(
        child: Text("body"),
      ),
      // floatingActionButton:
    );
  }
}
