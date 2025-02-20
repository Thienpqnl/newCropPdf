import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart'; // Để lưu trên Web
import 'dart:html' as html; // Chỉ dùng cho Web
import 'dart:io';

class ImageStorageService {
  List<String> savedImages = [];
  Map<String, Uint8List> savedImagesMap = {};
  // Lưu ảnh

  Future<void> saveImage(Uint8List imageBytes, String filename) async {
    if (kIsWeb) {
      // 🌐 Lưu dưới dạng Base64 trên Web
      String base64Image = "data:image/png;base64,${base64Encode(imageBytes)}";
      savedImages.add(base64Image);

      // Lưu vào SharedPreferences để tránh mất ảnh khi reload Web
      final prefs = await SharedPreferences.getInstance();
      List<String> storedImages = prefs.getStringList('savedImages') ?? [];
      storedImages.add(base64Image);
      await prefs.setStringList('savedImages', storedImages);
    } else {
      // 📱 Lưu dưới dạng file trên Mobile/Desktop
      final file = File(filename);
      await file.writeAsBytes(imageBytes);
      savedImages.add(file.path);
    }
  }

  Uint8List getImageData(String path) {
    return savedImagesMap[path] ?? Uint8List(0);
  }

  Uint8List getImageBytes(String imagePath) {
    if (imagePath.startsWith("data:image")) {
      // ✅ Nếu là chuỗi Base64, giải mã
      String base64Str = imagePath.split(",").last;
      return base64Decode(base64Str);
    } else {
      throw FormatException("Dữ liệu không phải Base64 hợp lệ: $imagePath");
    }
  }

  // Lấy danh sách ảnh
  Future<List<String>> getSavedImages() async {
    if (kIsWeb) {
      return html.window.localStorage.keys.toList();
    } else {
      return savedImages;
    }
  }

  /// Tải danh sách ảnh đã lưu từ SharedPreferences (dành cho Web)
  Future<void> loadSavedImages() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      savedImages = prefs.getStringList('savedImages') ?? [];
    }
  }
}
