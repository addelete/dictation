import 'package:get/get.dart';
import 'package:dictation/controllers/search_controller.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchControllerSelf());
  }
}
