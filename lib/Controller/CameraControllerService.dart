import 'dart:typed_data';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class CameraControllerService {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  final ImagePicker _picker = ImagePicker();

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _cameraController =
          CameraController(_cameras![0], ResolutionPreset.medium);
      await _cameraController!.initialize();
    }
  }

  CameraController? get cameraController => _cameraController;

  // Chụp ảnh từ Camera
  Future<XFile?> captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return null;
    }
    return await _cameraController!.takePicture();
  }

  // Chọn ảnh từ thư viện
  Future<XFile?> pickImageFromGallery() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  void dispose() {
    _cameraController?.dispose();
  }
}

class ImageStorageService {
  List<String> savedImages = [];

  // Lưu ảnh dưới dạng file trên Mobile/Desktop
  Future<void> saveImage(Uint8List imageBytes, String filename) async {
    final file = File(filename);
    await file.writeAsBytes(imageBytes);
    savedImages.add(file.path);
  }

  Uint8List getImageBytes(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      return file.readAsBytesSync();
    }
    return Uint8List(0);
  }

  Future<List<String>> getSavedImages() async {
    return savedImages;
  }
}
