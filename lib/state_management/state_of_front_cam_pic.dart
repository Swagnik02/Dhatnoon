import 'package:camera/camera.dart';
import 'package:get/get.dart';

class StateOfFrontCamPic {
  final frontCameraPic = Rx<XFile>(XFile(''));

  void setFrontCameraPic(XFile value) {
    frontCameraPic.value = value;
    print("inside the setter" + frontCameraPic.value.path);
  }
}