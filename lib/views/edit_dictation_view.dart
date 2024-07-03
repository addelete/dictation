import 'package:dictation/widgets/simple_button.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dictation/widgets/simple_card.dart';
import 'package:dictation/controllers/edit_dictation_controller.dart';
import 'package:dictation/widgets/show_confirm_dialog.dart';
import 'package:dictation/widgets/show_popup.dart';

class EditDictationView extends GetView<EditDictationController> {
  const EditDictationView({super.key});

  @override
  Widget build(context) {
    return Obx(() => WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back), onPressed: Get.back),
            titleSpacing: 0,
            title: Text(controller.title, style: const TextStyle(fontSize: 18)),
            // centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () async {
                  Get.toNamed("/tts_setting");
                },
              ),
              IconButton(
                icon: const Icon(Icons.history_outlined),
                onPressed: () {
                  showConfirmDialog(
                    title: "重置表单",
                    contentText: "确定重置表单？",
                    onConfirm: () {
                      controller.resetForm();
                      Get.back();
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.save_alt),
                onPressed: () async {
                  await controller.save();
                  Get.back();
                  Get.showSnackbar(const GetSnackBar(
                    message: "保存成功",
                    duration: Duration(seconds: 1),
                  ));
                },
              ),
            ],
          ),
          body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SimpleCard(
                      title: "基本信息",
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller.formData.value.name,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              controller.saveDraft();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '必填';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: '标题',
                            ),
                          ),
                          // TextField(
                          //   maxLines: null,
                          //   textInputAction: TextInputAction.done,
                          //   controller: controller.formData.value.autoInterval,
                          //   onChanged: (value) {
                          //     controller.saveDraft();
                          //   },
                          //   decoration: const InputDecoration(
                          //     border: InputBorder.none,
                          //     labelText: '自动播放停顿时长',
                          //     hintText: '自动听写时字词播放停顿秒数',
                          //     fillColor: Colors.grey,
                          //     suffixText: '秒',
                          //   ),
                          // ),
                          // TextField(
                          //   maxLines: null,
                          //   textInputAction: TextInputAction.done,
                          //   controller:
                          //       controller.formData.value.autoRepeatCount,
                          //   onChanged: (value) {
                          //     controller.saveDraft();
                          //   },
                          //   decoration: const InputDecoration(
                          //     border: InputBorder.none,
                          //     labelText: '自动播放重复次数',
                          //     hintText: '自动听写时字词播放重复次数',
                          //     fillColor: Colors.grey,
                          //     suffixText: '次',
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    for (var i = 0;
                        i < controller.formData.value.words.length;
                        i++)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SimpleCard(
                          // title: "第${i + 1}个字词",
                          titleWidget: Row(children: [

                            GestureDetector(
                              child:  Icon(Icons.play_circle, color: Theme.of(context).primaryColor,),
                              onTap: () {
                                print("play word");
                                controller.playWord(i);
                              },
                            ),
                            const SizedBox(width: 12),
                            Text("第${i + 1}个字词", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                          ],),
                          onClose: () {
                            controller.removeWordItem(i);
                          },
                          child: Column(
                            children: [
                              TextFormField(
                                controller:
                                    controller.formData.value.words[i].word,
                                onChanged: (value) {
                                  controller.saveDraft();
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '必填';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: '字词',
                                  hintText: '例：长',
                                ),
                              ),
                              TextField(
                                maxLines: null,
                                textInputAction: TextInputAction.done,
                                controller:
                                    controller.formData.value.words[i].speak,
                                onChanged: (value) {
                                  controller.saveDraft();
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: '播放内容',
                                  hintText: '为空则播放字词。例：长@zhang3',
                                ),
                              ),
                              TextField(
                                maxLines: 3,
                                textInputAction: TextInputAction.done,
                                controller:
                                    controller.formData.value.words[i].description,
                                onChanged: (value) {
                                  controller.saveDraft();
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: '描述',
                                  hintText: '例：\n拼音：zhǎng\n组词：长大、成长、助长、增长',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SimpleButton(
                                icon: const Icon(Icons.add),
                                type: SimpleButtonType.primary,
                                onPressed: () {
                                  controller.addWordItem();
                                },
                                child: const Text("增加字词卡片")),
                            const SizedBox(
                              width: 12,
                            ),
                            SimpleButton(
                                icon: const Icon(Icons.playlist_add),
                                type: SimpleButtonType.primary,
                                onPressed: () {
                                  showBatchInputPopup();
                                },
                                child: const Text("批量录入字词")),
                          ],
                        ))
                  ],
                ),
              ))),
        ),
        onWillPop: () async {
          if (controller.needSave) {
            await showConfirmDialog(
              contentText: '是否保存？',
              textConfirm: '保存',
              textCancel: '放弃',
              onConfirm: () async {
                await controller.save();
                Get.back();
                Get.showSnackbar(const GetSnackBar(
                  message: "保存成功",
                  duration: Duration(seconds: 1),
                ));
              },
            );
          }
          return Future.value(true);
        }));
  }

  void showBatchInputPopup() {
    controller.batchInputController.text = '';
    showPopup(
      title: "批量录入字词",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: controller.batchInputController,
          keyboardType: TextInputType.multiline,
          maxLines: 10,
          decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: InputBorder.none,
            hintText:
                '1.多个字词用换行隔开;\n2.字词与播放内容用空格隔开。\n3.播放内容可使用"字@拼音"纠正多音字读音。\n\n例：\n长 长大的长@zhang3\n行 银行@hang2的行@hang2',
          ),
        ),
      ),
      onOk: () {
        controller.batchInput();
        Get.back();
      },
    );
  }
}
