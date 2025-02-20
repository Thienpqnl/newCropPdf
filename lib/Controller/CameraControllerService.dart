import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class CameraControllerService {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  final ImagePicker _picker = ImagePicker();

  Future<void> initializeCameraForWeb() async {
    if (kIsWeb) {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController =
            CameraController(_cameras![0], ResolutionPreset.medium);
        await _cameraController!.initialize();
      }
    }
  }

  CameraController? get cameraController => _cameraController;

  // Chụp ảnh từ Camera
  Future<XFile?> captureImage() async {
    if (kIsWeb) {
      if (_cameraController == null ||
          !_cameraController!.value.isInitialized) {
        return null;
      }
      return await _cameraController!.takePicture();
    } else {
      return await _picker.pickImage(source: ImageSource.camera);
    }
  }

  // Chọn ảnh từ thư viện
  Future<XFile?> pickImageFromGallery() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  void dispose() {
    _cameraController?.dispose();
  }
}
