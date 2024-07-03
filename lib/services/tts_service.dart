import 'package:dictation/utils/pinyin_replace.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TtsService extends GetxService {
  late FlutterTts tts;
  late GetStorage box;
  late List<String> languages;
  late String language;
  late List<String> engines;
  late String engine;
  late List<Map<String, String>> voices;
  late Map<String, String> voice;
  late double speechRate;
  late double pitch;
  late double volume;

  Future<TtsService> init() async {
    tts = FlutterTts();
    box = GetStorage();

    // 设置引擎
    if (GetPlatform.isIOS) {
      engines = ["ios"];
      engine = "ios";
    } else {
      final rEngines = await tts.getEngines;
      engines = List<String>.from(rEngines.map((e) => e.toString()));
      final boxEngine = box.read("tts:engine");
      if (boxEngine != null && engines.contains(boxEngine)) {
        engine = boxEngine;
        await tts.setEngine(engine);
      } else {
        final rDefaultEngine = await tts.getDefaultEngine;
        engine = rDefaultEngine ?? "android";
        box.write("tts:engine", engine);
      }
    }
    // print(engine);
    // 设置语言
    final rLanguages = await tts.getLanguages;
    languages = filterLanguages(List<String>.from(rLanguages.map((e) => e.toString())));
    final boxLanguage = box.read("tts:language");
    if (boxLanguage != null && languages.contains(boxLanguage)) {
      language = boxLanguage;
      await tts.setLanguage(language);
    } else {
      language = ["zh-Hans-CN", "zh-CN", "zh-Hans", "zh"].firstWhere(
          (element) => languages.contains(element),
          orElse: () => "zh");
      await tts.setLanguage(language);
      box.write("tts:language", language);
    }
    // print(language);

    // 设置声音
    final rVoices = await tts.getVoices;
    voices = List<Map<String, String>>.from(rVoices
        .map((e) => Map<String, String>.from(e))
        .where((element) => element["locale"] == language));
    final boxVoiceName = box.read("tts:voiceName");
    if (boxVoiceName != null &&
        voices.any((element) => element["name"] == boxVoiceName)) {
      voice = voices.firstWhere(
          (element) =>
              element["name"] == boxVoiceName && element["locale"] == language,
          orElse: () => voices.first);
      await tts.setVoice(voice);
    } else {
      voice = voices.firstWhere((element) => element["locale"] == language,
          orElse: () => voices.first);
      await tts.setVoice(voice);
      final voiceName = voice["name"];
      box.write("tts:voiceName", voiceName);
    }
    // print(voice);

    // 设置语速
    final boxSpeechRate = box.read("tts:speechRate");
    if (boxSpeechRate != null) {
      speechRate = boxSpeechRate;
      await tts.setSpeechRate(boxSpeechRate);
    } else {
      setSpeechRate(0.5);
    }

    // 设置声调
    final boxPitch = box.read("tts:pitch");
    if (boxPitch != null) {
      pitch = boxPitch;
      await tts.setPitch(boxPitch);
    } else {
      setPitch(1.0);
    }

    // 设置音量
    final boxVolume = box.read("tts:volume");
    if (boxVolume != null) {
      volume = boxVolume;
      await tts.setVolume(boxVolume);
    } else {
      setVolume(1.0);
    }

    return this;
  }

  List<String> filterLanguages(List<String> langs) {
    return langs
        .where((element) => ['zh', 'en'].contains(element.split("-")[0])).toList();
  }

  /// 设置引擎
  setEngine(String eng) async {
    await tts.setEngine(eng);
    engine = eng;
    box.write("tts:engine", eng);
    await setLanguageByEngine();
  }

  /// 设置语言
  setLanguageByEngine() async {
    final rLanguages = await tts.getLanguages;
    languages = filterLanguages(List<String>.from(rLanguages.map((e) => e.toString())));
    if (!languages.contains(language)) {
      language = ["zh-Hans-CN", "zh-CN", "zh-Hans", "zh"].firstWhere(
          (element) => languages.contains(element),
          orElse: () => "zh");
      await tts.setLanguage(language);
      box.write("tts:language", language);
    }
    await setVoiceByLocale();
  }

  /// 设置语言
  setLanguage(String lang) async {
    if (languages.contains(lang) == false) return;
    await tts.setLanguage(lang);
    language = lang;
    box.write("tts:language", lang);
    await setVoiceByLocale();
  }

  /// 设置声音
  setVoiceByLocale() async {
    final rVoices = await tts.getVoices;
    voices = List<Map<String, String>>.from(rVoices
        .map((e) => Map<String, String>.from(e))
        .where((element) => element["locale"] == language));
    voice = voices.firstWhere((element) => element["locale"] == language,
        orElse: () => voices.first);
    await tts.setVoice(voice);
    box.write("tts:voiceName", voice["name"]);
  }

  /// 设置声音
  setVoiceByName(String voiceName) async {
    voice = voices.firstWhere(
        (element) =>
            element["name"] == voiceName && element["locale"] == language,
        orElse: () => voices.first);
    await tts.setVoice(voice);
    box.write("tts:voiceName", voiceName);
  }

  /// 设置语速
  setSpeechRate(double rate) async {
    await tts.setSpeechRate(rate);
    box.write("tts:speechRate", rate);
    speechRate = rate;
  }

  /// 设置音量
  setVolume(double vol) async {
    await tts.setVolume(vol);
    box.write("tts:volume", vol);
    volume = vol;
  }

  /// 设置声调
  setPitch(double pit) async {
    await tts.setPitch(pit);
    box.write("tts:pitch", pit);
    pitch = pit;
  }

  Future<void> speak(String text) async {
    /// 处理text中的拼音
    if (engine == 'ios') {
      /// ios拼音朗读规则：chang2
      text = text.replaceAllMapped(RegExp(r"[\u4e00-\u9fa5]@([a-z]{1,6}[0-9])"),
          (match) {
        return '${match.group(1)}';
      });
    } else if (engine == "com.iflytek.speechsuite") {
      // print("讯飞");
      /// 讯飞拼音朗读：长[=chang2]
      text = text.replaceAllMapped(
          RegExp(r"([\u4e00-\u9fa5])@([a-z]{1,6}[0-9])"), (match) {
        return '${match.group(1)}[=${match.group(2)}]';
      });
    } else if (engine == "com.baidu.duersdk.opensdk") {
      /// 百度拼音朗读：长(chang2)
      text = text.replaceAllMapped(
          RegExp(r"([\u4e00-\u9fa5])@([a-z]{1,6}[0-9])"), (match) {
        return '${match.group(1)}(${match.group(2)})';
      });
    } else {
      /// 其他则替换为同音字或删除拼音
      text = text.replaceAllMapped(
          RegExp(r"([\u4e00-\u9fa5])@([a-z]{1,6}[0-9])"), (match) {
        final newWord = getPinYinReplace(match.group(2)!);
        return newWord ?? match.group(1)!;
      });
    }
    await tts.speak(text);
    await tts.awaitSpeakCompletion(true);
  }

  Future<void> stop() async {
    await tts.stop();
  }
}
