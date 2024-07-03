import 'package:dictation/services/tts_service.dart';
import 'package:get/get.dart';

enum SpeakStatus { speaking, paused, stopped }

class TtsController extends GetxController {
  final ttsService = Get.find<TtsService>();
  // late FlutterTts tts;
  final speechRate = 0.5.obs;

  final speakStatus = SpeakStatus.stopped.obs;
  final engine = "".obs;
  final engines = <String>[].obs;
  final language = "".obs;
  final languages = <String>[].obs;
  final voiceName = "".obs;
  final voiceNames = <String>[].obs;
  final volume = 1.0.obs;
  final pitch = 1.0.obs;


  // late String engine;

  @override
  void onInit() {
    super.onInit();
    initTts();
  }

  Future<void> initTts() async {
    speechRate.value = ttsService.speechRate;
    engines.value = ttsService.engines;
    engine.value = ttsService.engine;
    languages.value = ttsService.languages;
    language.value = ttsService.language;
    voiceName.value = ttsService.voice["name"] ?? "";
    voiceNames.clear();
    for (var v in ttsService.voices) {
      voiceNames.add(v["name"] ?? "");
    }

    volume.value = ttsService.volume;
    pitch.value = ttsService.pitch;

    ttsService.tts.setStartHandler(() {
      speakStatus.value = SpeakStatus.speaking;
    });

    ttsService.tts.setCompletionHandler(() {
      speakStatus.value = SpeakStatus.stopped;
    });

    ttsService.tts.setErrorHandler((msg) {
      speakStatus.value = SpeakStatus.stopped;
    });

    ttsService.tts.setCancelHandler(() {
      speakStatus.value = SpeakStatus.stopped;
    });

    ttsService.tts.setPauseHandler(() {
      speakStatus.value = SpeakStatus.paused;
    });

    ttsService.tts.setContinueHandler(() {
      speakStatus.value = SpeakStatus.speaking;
    });

    // ttsService.tts.setInitHandler(() {
    //   speakStatus.value = SpeakStatus.stopped;
    // });
  }

  Future<void> speak(String text) async {
    if(speakStatus.value == SpeakStatus.speaking) {
      await ttsService.stop();
    }
    await ttsService.speak(text);

  }

  Future<void> stop() async {
    await ttsService.stop();
  }



  /// 设置引擎
  setEngine(String eng) async {
    await ttsService.setEngine(eng);
    engine.value = ttsService.engine;
    languages.value = ttsService.languages;
    language.value = ttsService.language;
    voiceNames.clear();
    for (var v in ttsService.voices) {
      voiceNames.add(v["name"] ?? "");
    }

    voiceName.value = ttsService.voice["name"] ?? "";
  }

  /// 设置语言
  setLanguage(String lang) async {
    await ttsService.setLanguage(lang);
    language.value = ttsService.language;
    voiceNames.clear();
    for (var v in ttsService.voices) {
      voiceNames.add(v["name"] ?? "");
    }
    voiceName.value = ttsService.voice["name"] ?? "";
  }

  /// 设置声音
  setVoiceByName(String vn) async {
    await ttsService.setVoiceByName(vn);
    voiceName.value =  ttsService.voice["name"] ?? "";
  }

  /// 设置语速
  setSpeechRate(double rate) async {
    await ttsService.setSpeechRate(rate);
    speechRate.value = ttsService.speechRate;
  }

  /// 设置音量
  setVolume(double vol) async {
    await ttsService.setVolume(vol);
    volume.value = ttsService.volume;
  }

  /// 设置声调
  setPitch(double pit) async {
    await ttsService.setPitch(pit);
    pitch.value = ttsService.pitch;
  }
}
