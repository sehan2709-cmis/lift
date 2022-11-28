import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';

class CameraState extends ChangeNotifier {
  List<CameraDescription> _cameras = <CameraDescription>[];
  List<CameraDescription> get cameras => _cameras;

  CameraState() {
    init();
  }

  Future<void> init() async{
    try {
      // WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      _logError(e.code, e.description);
    }
  }

  void _logError(String code, String? message) {
    if (message != null) {
      print('Error: $code\nError Message: $message');
    } else {
      print('Error: $code');
    }
  }

}