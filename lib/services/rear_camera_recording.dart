import 'package:camera/camera.dart';
import 'package:components/state_management/state_of_back_cam_rec.dart';
import 'package:components/utils/tabBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'video_page.dart';

class RearCameraRecording extends StatefulWidget {
  const RearCameraRecording({Key? key}) : super(key: key);

  @override
  _RearCameraRecordingState createState() => _RearCameraRecordingState();
}

class _RearCameraRecordingState extends State<RearCameraRecording> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  StateOfBackCamRec stateOfBackCamRec = Get.find();

  @override
  void initState() {
    _initCamera();
    super.initState();

    //this works but it's not the best way to do it
    Future.delayed(Duration(seconds: 2), () {
      callMethod();
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final rear = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(rear, ResolutionPreset.low, enableAudio: false);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      // this file needs to be uploaded to firebase
      final file = await _cameraController.stopVideoRecording();
      
      stateOfBackCamRec.setBackCameraRec(file);
      
      setState(() => _isRecording = false);

      print(file);
      print(file.path);
      print("recording stopped");

    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      print("recording started");
      setState(() => _isRecording = true);
    }
  }

  void callMethod() {
    _recordVideo();
    Future.delayed(Duration(seconds: 10), () {
      _recordVideo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}