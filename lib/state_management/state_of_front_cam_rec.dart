import 'package:camera/camera.dart';
import 'package:get/get.dart';

class StateOfFrontCamRec {
  final frontCameraRec = Rx<XFile>(XFile(''));

  void setFrontCameraRec(XFile value) {
    frontCameraRec.value = value;
    print("inside the setter" + frontCameraRec.value.path);
  }
}