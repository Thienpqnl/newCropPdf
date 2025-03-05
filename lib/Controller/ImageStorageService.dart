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

  Future<List<String>> getSavedImages() async {
    return savedImages;
  }
}
