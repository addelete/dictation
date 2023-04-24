import 'package:dictation/controllers/tts_controller.dart';
import 'package:dictation/services/tts_service.dart';
import 'package:dictation/widgets/form_item.dart';
import 'package:dictation/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TtsSettingView extends GetView<TtsController> {
  final box = GetStorage();
  final ttsService = Get.find<TtsService>();
  final testTextController = TextEditingController();
  TtsSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    testTextController.text =
        box.read("tts_setting_view:testText") ?? "长@zhang3长@chang2";
    return Obx(() {
      return Scaffold(
          appBar: AppBar(title: const Text("语音设置")),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextField(
                  controller: testTextController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "测试文本",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Spacer(),
                    SimpleButton(
                      child: Text(
                          controller.speakStatus.value == SpeakStatus.speaking
                              ? "暂停"
                              : "播放"),
                      onPressed: () {
                        if (controller.speakStatus.value ==
                            SpeakStatus.speaking) {
                          controller.stop();
                        } else {
                          box.write("tts_setting_view:testText",
                              testTextController.text);
                          controller.speak(testTextController.text);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      if (GetPlatform.isAndroid &&
                          controller.engine.value.isNotEmpty)
                        FormItem(
                          label: "语音引擎",
                          control: DropdownButton<String>(
                            isExpanded: true,
                            value: controller.engine.value,
                            items: controller.engines
                                .map((option) => DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              controller.setEngine(value!);
                            },
                          ),
                        ),
                      FormItem(
                        label: "语言",
                        control: DropdownButton<String>(
                          isExpanded: true,
                          value: controller.language.value,
                          items: controller.languages
                              .map((option) => DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          ))
                              .toList(),
                          onChanged: (value) {
                            controller.setLanguage(value!);
                          },
                        ),
                      ),
                      FormItem(
                        label: "音色",
                        control: DropdownButton<String>(
                          isExpanded: true,
                          value: controller.voiceName.value,
                          items: controller.voiceNames
                              .map((option) => DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          ))
                              .toList(),
                          onChanged: (value) {
                            controller.setVoiceByName(value!);
                          },
                        ),
                      ),
                      FormItem(
                        label: "语速",
                        control: Slider(
                            value: controller.speechRate.value,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: controller.speechRate.value.toString(),
                            onChanged: (value) {
                              controller.setSpeechRate(value);
                            }),
                      ),
                      FormItem(
                        label: "声调",
                        control: Slider(
                            value: controller.pitch.value,
                            min: 0.5,
                            max: 2.0,
                            divisions: 15,
                            label: controller.pitch.value.toString(),
                            onChanged: (value) {
                              controller.setPitch(value);
                            }),
                      ),
                      FormItem(
                        label: "音量",
                        control: Slider(
                            value: controller.volume.value,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: controller.volume.value.toString(),
                            onChanged: (value) {
                              controller.setVolume(value);
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
