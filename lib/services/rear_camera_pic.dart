import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:components/state_management/state_of_back_cam_pic.dart';
import 'package:components/utils/tabBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RearCameraPic extends StatefulWidget {

  @override
  RearCameraPicState createState() => RearCameraPicState();
}

class RearCameraPicState extends State<RearCameraPic> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  StateOfBackCamPic stateOfBackCamPic = Get.find();

  @override
  void initState() {
    super.initState();
    startEverything();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  startEverything() async {
    final cameras = await availableCameras();
    final rearCamera = cameras[0];

    _controller = CameraController(
      rearCamera,
      ResolutionPreset.medium,
    );
    _controller.setFlashMode(FlashMode.off);

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    takeThePhoto();
  }

  takeThePhoto() async {
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await _controller.takePicture();
      stateOfBackCamPic.setBackCameraPic(image);

      if (!mounted) return;

    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

