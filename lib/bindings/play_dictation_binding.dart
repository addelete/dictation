import 'package:dictation/controllers/tts_controller.dart';
import 'package:get/get.dart';
import 'package:dictation/controllers/play_dictation_controller.dart';

class PlayDictationBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(TtsController());
    Get.lazyPut(() => PlayDictationController());
  }
}
