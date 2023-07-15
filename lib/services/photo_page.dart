import 'dart:io';

import 'package:flutter/material.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String cameraMode;

  const DisplayPictureScreen({super.key, required this.imagePath, required this.cameraMode});

  @override
  Widget build(BuildContext context) {
    print("The path of the image is $imagePath");

    return Scaffold(
      appBar: AppBar(title: Text('$cameraMode Camera Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.network(imagePath),
    );
  }
}