import 'package:dictation/controllers/tts_controller.dart';
import 'package:dictation/models/dictation.dart';
import 'package:get/get.dart';
import 'package:dictation/services/isar_service.dart';

enum PlayStatus { playing, stopped }

class PlayDictationController extends GetxController {
  /// 数据库服务
  final IsarService isarService = Get.find();

  final TtsController ttsController = Get.find();

  final dictation = Rx<Dictation?>(null);

  final wordIndex = 0.obs;
  final repeatId = 0.obs;
  final countdownCount = 0.obs;

  final playStatus = PlayStatus.stopped.obs;
  final isAutoPlay = false.obs;
  final autoPlayInterval = 10.obs;
  final autoPlayRepeatCount = 3.obs;

  final selectedWords = <int>{}.obs;

  bool get isLastIndex => wordIndex.value + 1 == dictation.value!.wordsCount!;

  String get title {
    if (playStatus.value == PlayStatus.playing) {
      return "听写中";
    } else if (wordIndex.value == 0) {
      return dictation.value?.name ?? "";
    } else {
      return "听写完成";
    }
  }

  String get subTitle {
    if (dictation.value == null) {
      return "";
    } else if (playStatus.value == PlayStatus.stopped) {
      return '共${dictation.value!.wordsCount}个字词';
    } else {
      return '${wordIndex.value + 1}/${dictation.value!.wordsCount}';
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadDictation();
    everAll([wordIndex, repeatId], (_) async {
      if (dictation.value == null) return;

      /// 如果已经全部播放完，就结束
      if (wordIndex.value >= dictation.value!.wordsCount!) {
        playStatus.value = PlayStatus.stopped;
        return;
      }
      WordItem word = dictation.value!.words![wordIndex.value];
      String text = word.speak!.isEmpty ? word.word! : word.speak!;
      if (!isAutoPlay.value) {
        speak(text);
      } else {
        var repeatText = "";
        for (var i = 0; i < autoPlayRepeatCount.value; i++) {
          repeatText += text;
        }
        await speak(repeatText);
        startCountdown();
        await Future.delayed(Duration(seconds: autoPlayInterval.value));
        // if (ttsController.speakStatus.value == SpeakStatus.paused) return;
        nextWord();
      }
    });
  }

  void loadDictation() async {
    if (Get.currentRoute == '/play_dictation') {
      final int dictationId = Get.arguments!["dictationId"]!;
      dictation.value = await isarService.isar.dictations.get(dictationId);
      autoPlayInterval.value = dictation.value!.autoInterval!;
      autoPlayRepeatCount.value = dictation.value!.autoRepeatCount!;
    }
  }

  start() {
    wordIndex.value = 0;
    playStatus.value = PlayStatus.playing;
  }

  speak(String text) async {
    await ttsController.speak(text);
  }

  repeatWord() {
    repeatId.value++;
  }

  prevWord() {
    if (wordIndex.value > 0) {
      wordIndex.value--;
    }
  }

  nextWord() {
    wordIndex.value++;
  }

  shuffleWords() {
    if (dictation.value == null) return;
    dictation.value!.words!.shuffle();
  }

  disableAutoPlay() {
    isAutoPlay.value = false;
  }

  enableAutoPlay() async {
    isAutoPlay.value = true;
    dictation.value!.autoInterval = autoPlayInterval.value;
    dictation.value!.autoRepeatCount = autoPlayRepeatCount.value;
    await isarService.isar.writeTxn(() async {
      await isarService.isar.dictations.put(dictation.value!);
    });
    if (playStatus.value == PlayStatus.playing) {
      nextWord();
    }
  }

  startCountdown() async {
    countdownCount.value = dictation.value!.autoInterval!;
    while (countdownCount.value > 0) {
      if (!isAutoPlay.value) {
        countdownCount.value = 0;
        break;
      }
      await Future.delayed(const Duration(seconds: 1));
      countdownCount.value--;
    }
  }
}
