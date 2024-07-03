import 'package:dictation/controllers/tts_controller.dart';
import 'package:get/get.dart';

class TtsSettingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TtsController());
  }
}
