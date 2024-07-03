import 'package:get/get.dart';
import 'package:dictation/controllers/edit_dictation_controller.dart';
import 'package:dictation/controllers/tts_controller.dart';

class EditDictationBinging extends Bindings {
  @override
  void dependencies() {
    Get.put(TtsController());
    Get.lazyPut(
      () => EditDictationController(),
    );
  }
}
