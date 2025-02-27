import 'dart:typed_data';
import 'dart:io';

class ImageStorageService {
  List<String> savedImages = [];
  Map<String, Uint8List> savedImagesMap = {};

  // Lưu ảnh dưới dạng file trên Mobile/Desktop
  Future<void> saveImage(Uint8List imageBytes, String filename) async {
    final file = File(filename);
    await file.writeAsBytes(imageBytes);
    savedImages.add(file.path);
  }

  Uint8List getImageData(String path) {
    return savedImagesMap[path] ?? Uint8List(0);
  }

  Future<List<String>> getSavedImages() async {
    return savedImages;
  }
}
