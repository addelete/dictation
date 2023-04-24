import 'package:dictation/controllers/tts_controller.dart';
import 'package:dictation/widgets/counter.dart';
import 'package:dictation/widgets/simple_button.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dictation/controllers/play_dictation_controller.dart';
import 'package:dictation/widgets/speaking_icon.dart';
import 'package:dictation/widgets/show_popup.dart';

class PlayDictationView extends GetView<PlayDictationController> {
  final TtsController ttsController = Get.find();

  PlayDictationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back), onPressed: Get.back),
            titleSpacing: 0,
            title: const Text("听写", style: TextStyle(fontSize: 18)),
            // centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () async {
                   Get.toNamed("/tts_setting");
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller.playStatus.value == PlayStatus.stopped)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: SimpleButton(
                            onPressed: () {
                              controller.shuffleWords();
                            },
                            icon: const Icon(
                              Icons.waving_hand,
                              size: 16,
                            ),
                            child: const Text("打乱顺序")),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: SimpleButton(
                          onPressed: () {
                            if (controller.isAutoPlay.value) {
                              controller.disableAutoPlay();
                            } else {
                              showAutoPlayPopup();
                            }
                          },
                          icon: Icon(
                            controller.isAutoPlay.value
                                ? Icons.playlist_remove
                                : Icons.playlist_play,
                            size: 18,
                          ),
                          child: Text(
                              controller.isAutoPlay.value ? "关闭自动" : "开启自动")),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: controller.dictation.value == null
                      ? const Text("加载中")
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SpeakingIcon(
                                isSpeaking: ttsController.speakStatus.value ==
                                    SpeakStatus.speaking),
                            Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(controller.title,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold))),
                            Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(controller.subTitle)),
                            Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: controller.playStatus.value ==
                                            PlayStatus.stopped
                                        ? <Widget>[
                                            SimpleButton(
                                                type: SimpleButtonType.primary,
                                                onPressed: () {
                                                  controller.start();
                                                },
                                                icon: const Icon(
                                                    Icons.play_arrow),
                                                child: Text(
                                                    controller.wordIndex.value >
                                                            0
                                                        ? "重新听写"
                                                        : "开始听写")),
                                            const SizedBox(width: 12),
                                            SimpleButton(
                                                onPressed: () {
                                                  showWordsPopup();
                                                },
                                                icon: const Icon(
                                                  Icons.list,
                                                  size: 16,
                                                ),
                                                child: const Text("字词列表")),
                                          ]
                                        : <Widget>[
                                            if (controller.wordIndex.value > 0)
                                              SimpleButton(
                                                  onPressed: () {
                                                    controller.prevWord();
                                                  },
                                                  icon: const Icon(
                                                      Icons.skip_previous),
                                                  child: const Text("上一个")),
                                            if (controller.wordIndex.value > 0)
                                              const SizedBox(width: 12),
                                            SimpleButton(
                                                type: SimpleButtonType.primary,
                                                onPressed: () {
                                                  controller.repeatWord();
                                                },
                                                icon: const Icon(Icons.repeat,
                                                    size: 18),
                                                child: const Text("重播")),
                                            const SizedBox(width: 12),
                                            SimpleButton(
                                                onPressed: () {
                                                  controller.nextWord();
                                                },
                                                icon: controller.wordIndex
                                                                .value +
                                                            1 ==
                                                        controller.dictation
                                                            .value!.wordsCount
                                                    ? const Icon(Icons.stop)
                                                    : const Icon(
                                                        Icons.skip_next),
                                                child: Text(
                                                    controller.wordIndex.value +
                                                                1 ==
                                                            controller
                                                                .dictation
                                                                .value!
                                                                .wordsCount
                                                        ? "停止"
                                                        : "下一个")),
                                          ])),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ));
  }

  /// 显示字词列表的弹窗
  void showWordsPopup() {
    showPopup(
        titleWidget: Obx(
          () => Text(
            controller.wordIndex.value == 0
                ? "字词列表"
                : "正确：${controller.selectedWords.length}/${controller.dictation.value!.wordsCount!}",
          ),
        ),
        child: SizedBox(
            height: 300,
            child: Obx(
              () => ListView.builder(
                itemCount: controller.dictation.value!.wordsCount,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // itemExtent: 50,
                itemBuilder: (context, index) {
                  return Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withAlpha(50),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              height: 20,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary,
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme!
                                          .onPrimary,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(controller
                                      .dictation.value!.words![index].word!),
                                  if (controller.dictation.value!.words![index]
                                              .description !=
                                          null &&
                                      controller.dictation.value!.words![index]
                                          .description!.isNotEmpty)
                                    Opacity(
                                        opacity: 0.5,
                                        child: Text(
                                            controller
                                                    .dictation
                                                    .value!
                                                    .words![index]
                                                    .description ??
                                                '',
                                            style:
                                                const TextStyle(fontSize: 10))),
                                ],
                              ),
                            ),
                          ),

                          // const Spacer(),
                          if (controller.wordIndex.value > 0)
                            Checkbox(
                              value: controller.selectedWords.contains(index),
                              onChanged: (value) {
                                if (value != null && value) {
                                  controller.selectedWords.add(index);
                                } else {
                                  controller.selectedWords.remove(index);
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )));
  }

  /// 显示自动播放的弹窗
  void showAutoPlayPopup() {
    showPopup(
      title: "设置自动播放",
      onOk: () {
        controller.enableAutoPlay();
        Get.back();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(children: [
          Row(
            children: [
              const Text("播放间隔秒数"),
              const Spacer(),
              Counter(count: controller.autoPlayInterval),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text("每条播放次数"),
              const Spacer(),
              Counter(count: controller.autoPlayRepeatCount, min: 1),
            ],
          ),
        ]),
      ),
    );
  }
}
