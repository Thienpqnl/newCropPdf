import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flnewpr/Controller/ImageStorageService.dart';

class SavedImagesScreen extends StatefulWidget {
  final ImageStorageService imageStorageService; // Nhận từ CameraScreen
  const SavedImagesScreen({super.key, required this.imageStorageService});

  @override
  // ignore: library_private_types_in_public_api
  _SavedImagesScreenState createState() => _SavedImagesScreenState();
}

class _SavedImagesScreenState extends State<SavedImagesScreen> {
  late ImageStorageService _imageStorageService;

  @override
  void initState() {
    super.initState();
    _imageStorageService =
        widget.imageStorageService; // Lấy từ tham số truyền vào
    setState(() {}); // Cập nhật UI sau khi nhận dữ liệu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ảnh đã lưu')),
      body: _buildImageGallery(),
    );
  }

  Widget _buildImageGallery() {
    print('Số lượng ảnh: ${_imageStorageService.savedImages.length}');
    return ListView.builder(
      itemCount: _imageStorageService.savedImages.length,
      itemBuilder: (context, index) {
        Uint8List imageBytes = _imageStorageService
            .getImageBytes(_imageStorageService.savedImages[index]);

        return ListTile(
          leading: GestureDetector(
            onTap: () {
              _showImageDialog(context, imageBytes); // Gọi dialog xem ảnh
            },
            child: Image.memory(imageBytes,
                width: 50, height: 50, fit: BoxFit.cover),
          ),
          title: Text('Ảnh ${index + 1}'),
        );
      },
    );
  }

  /// Hiển thị ảnh lớn hơn khi nhấn vào
  void _showImageDialog(BuildContext context, Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(imageBytes, fit: BoxFit.contain),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Đóng'),
              ),
            ],
          ),
        );
      },
    );
  }
}
