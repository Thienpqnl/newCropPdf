import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flnewpr/Controller/CameraControllerService.dart'
    as camera_service;
import 'package:flnewpr/Controller/ImageStorageService.dart' as storage_service;
import 'package:flnewpr/Screen/SavedImagesScreen.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final camera_service.CameraControllerService _cameraService =
      camera_service.CameraControllerService();
  final storage_service.ImageStorageService _imageStorageService =
      storage_service.ImageStorageService();
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _cameraService.initializeCamera();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _captureImage() async {
    print('chup anh');
    final image = await _cameraService.captureImage();
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = '${directory.path}/app_flutter';

      Uint8List imageBytes = await image.readAsBytes();
      String filename =
          "$folderPath/image_${DateTime.now().millisecondsSinceEpoch}.png";

      // Tạo thư mục nếu nó chưa tồn tại
      final folder = Directory(folderPath);
      if (!folder.existsSync()) {
        folder.createSync(
            recursive: true); // Tạo thư mục và tất cả các thư mục cha nếu cần
      }

      await _imageStorageService.saveImage(imageBytes, filename);

      // 📌 Cấp quyền trước khi lưu
      var status = await Permission.storage.request();

      if (status.isGranted) {
        // 📌 Lưu ảnh vào bộ sưu tập
        await FlutterImageGallerySaver.saveImage(imageBytes);
        _showSnackBar('📸 Ảnh đã lưu vào bộ sưu tập');
      } else {
        _showSnackBar('❌ Không có quyền lưu ảnh vào bộ sưu tập');
      }
      setState(() {});
    }
  }

  Future<void> _pickImageFromGallery() async {
    final image = await _cameraService.pickImageFromGallery();
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = '${directory.path}/app_flutter';
      Uint8List imageBytes = await image.readAsBytes();
      String filename =
          "$folderPath/image_${DateTime.now().millisecondsSinceEpoch}.png";

      // Tạo thư mục nếu nó chưa tồn tại
      final folder = Directory(folderPath);
      if (!folder.existsSync()) {
        folder.createSync(
            recursive: true); // Tạo thư mục và tất cả các thư mục cha nếu cần
      }

      await _imageStorageService.saveImage(imageBytes, filename);
      _showSnackBar('🖼 Ảnh đã được thêm từ thư viện!');
      setState(() {});
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chụp & Xem ảnh'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'view_images') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavedImagesScreen(
                        imageStorageService: _imageStorageService),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 'view_images', child: Text('📂 Xem ảnh đã lưu')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isCameraInitialized
                ? AspectRatio(
                    aspectRatio:
                        _cameraService.cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraService.cameraController!),
                  )
                : Center(child: Text('Không có camera khả dụng')),
          ),
          ElevatedButton(onPressed: _captureImage, child: Text('📸 Chụp ảnh')),
          ElevatedButton(
              onPressed: _pickImageFromGallery, child: Text('🖼 Chọn ảnh')),
        ],
      ),
    );
  }
}
