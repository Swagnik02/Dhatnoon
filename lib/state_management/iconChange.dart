import 'package:get/get.dart';

class IconChange {
  var isAccordionOpen = true.obs;

  void accordionOpened() {
    isAccordionOpen.value = true;
  }

  void accordionClosed() {
    isAccordionOpen.value = false;
  }

}
