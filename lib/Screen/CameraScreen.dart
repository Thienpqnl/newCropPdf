import 'dart:typed_data';
import 'package:flnewpr/Controller/CameraControllerService.dart';
import 'package:flnewpr/Controller/ImageStorageService.dart';
import 'package:flnewpr/Screen/SavedImagesScreen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraControllerService _cameraService = CameraControllerService();
  final ImageStorageService _imageStorageService = ImageStorageService();
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    if (kIsWeb) {
      _imageStorageService.loadSavedImages().then((_) {
        setState(() {}); // Cập nhật giao diện sau khi tải ảnh
      });
    }
  }

  Future<void> _initializeCamera() async {
    if (kIsWeb) {
      await _cameraService.initializeCameraForWeb();
    }
    setState(() {
      _isCameraInitialized = true;
      _imageStorageService.getSavedImages();
    });
  }

  Future<void> _captureImage() async {
    final image = await _cameraService.captureImage();
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      String filename = "image_${DateTime.now().millisecondsSinceEpoch}.png";
      await _imageStorageService.saveImage(imageBytes, filename);
      _showSnackBar('📸 ảnh đã được chụp, và lưu vào thư viện');
      setState(() {
        _imageStorageService.getSavedImages();
      }); // Cập nhật giao diện
    }
  }

  Future<void> _pickImageFromGallery() async {
    final image = await _cameraService.pickImageFromGallery();
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      String filename = "image_${DateTime.now().millisecondsSinceEpoch}.png";
      await _imageStorageService.saveImage(imageBytes, filename);
      _showSnackBar('🖼 Ảnh đã được thêm từ thư viện!');
      setState(() {
        _imageStorageService.getSavedImages();
      }); // Cập nhật giao diện
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
            child: kIsWeb
                ? (_cameraService.cameraController != null &&
                        _isCameraInitialized
                    ? CameraPreview(_cameraService.cameraController!)
                    : Center(child: Text('Không có camera khả dụng')))
                : Center(child: Text('Chỉ hỗ trợ chụp ảnh trên điện thoại')),
          ),
          ElevatedButton(onPressed: _captureImage, child: Text('📸 Chụp ảnh')),
          ElevatedButton(
              onPressed: _pickImageFromGallery, child: Text('🖼 Chọn ảnh')),
        ],
      ),
    );
  }
}
