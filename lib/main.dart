import 'package:flnewpr/Screen/CameraScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chụp ảnh PDF',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: CameraScreen());
  }
}
