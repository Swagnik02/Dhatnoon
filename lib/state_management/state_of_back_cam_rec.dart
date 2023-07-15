import 'package:camera/camera.dart';
import 'package:get/get.dart';

class StateOfBackCamRec {
  final backCameraRec = Rx<XFile>(XFile(''));

  void setBackCameraRec(XFile value) {
    backCameraRec.value = value;
    print("inside the setter" + backCameraRec.value.path);
  }
}