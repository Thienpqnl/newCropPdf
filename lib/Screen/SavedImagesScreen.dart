import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flnewpr/Controller/ImageStorageService.dart';

class SavedImagesScreen extends StatefulWidget {
  final ImageStorageService imageStorageService;
  const SavedImagesScreen({super.key, required this.imageStorageService});

  @override
  // ignore: library_private_types_in_public_api
  _SavedImagesScreenState createState() => _SavedImagesScreenState();
}

class _SavedImagesScreenState extends State<SavedImagesScreen> {
  late List<String> _savedImages;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    _savedImages = await widget.imageStorageService.getSavedImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ảnh đã lưu')),
      body: _buildImageGallery(),
    );
  }

  Widget _buildImageGallery() {
    print('ảnh đã lưu ${_savedImages.length}');
    return ListView.builder(
      itemCount: _savedImages.length,
      itemBuilder: (context, index) {
        String imagePath = _savedImages[index];
        if (!File(imagePath).existsSync()) {
          return SizedBox();
        }
        return ListTile(
          leading: GestureDetector(
            onTap: () => _showImageDialog(context, imagePath),
            child: Image.file(File(imagePath),
                width: 50, height: 50, fit: BoxFit.cover),
          ),
          title: Text('Ảnh ${index + 1}'),
        );
      },
    );
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(File(imagePath), fit: BoxFit.contain),
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
