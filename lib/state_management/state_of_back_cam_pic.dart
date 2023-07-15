import 'package:camera/camera.dart';
import 'package:get/get.dart';

class StateOfBackCamPic {
  final backCameraPic = Rx<XFile>(XFile(''));

  void setBackCameraPic(XFile value) {
    backCameraPic.value = value;
    print("inside the setter" + backCameraPic.value.path);
  }
}