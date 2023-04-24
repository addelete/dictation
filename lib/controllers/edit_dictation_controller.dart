import 'dart:developer';
import 'package:dictation/controllers/tts_controller.dart';
import 'package:dictation/models/dictation.dart';
import 'package:dictation/models/form_dictation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dictation/services/isar_service.dart';

class EditDictationController extends GetxController {
  /// 数据库服务
  IsarService isarService = Get.find();

  final TtsController ttsController = Get.find();

  final folderId = 0.obs;
  final dictationId = 0.obs;
  final formData = Rx<EditingDictationFormData>(EditingDictationFormData());
  bool needSave = false;
  Dictation? dictation;
  final TextEditingController batchInputController =
      TextEditingController(text: "");

  String get title => dictationId.value == 0 ? '新建听写' : '编辑听写';

  @override
  onInit() {
    super.onInit();
    initByRoute();
  }

  /// 通过路由参数初始化
  Future<void> initByRoute() async {
    if (Get.currentRoute == '/edit_dictation') {
      folderId.value = Get.arguments?["folderId"] ?? 0;
      dictationId.value = Get.arguments?["dictationId"] ?? 0;
      log("folderId：${folderId.value}");
      log("dictationId：${dictationId.value}");
      if (dictationId.value != 0) {
        dictation = await isarService.isar.dictations.get(dictationId.value);
      }
      final formDictation =
          await isarService.isar.formDictations.get(dictationId.value);
      if (formDictation != null &&
          (dictationId.value == 0 ||
              (dictation != null &&
                  dictation!.updatedAt != null &&
                  formDictation.updatedAt != null &&
                  dictation!.updatedAt!.isBefore(formDictation.updatedAt!)))) {
        formData.value.name.text = formDictation.name ?? "";
        formData.value.autoInterval.text =
            (formDictation.autoInterval ?? FormDictation.defaultAutoInterval)
                .toString();
        formData.value.autoRepeatCount.text = (formDictation.autoRepeatCount ??
                FormDictation.defaultAutoRepeatCount)
            .toString();
        for (var element in formDictation.words ?? []) {
          formData.value.words.add(WordItemFormData()
            ..word.text = element.word ?? ""
            ..speak.text = element.speak ?? ""
            ..description.text = element.description ?? "");
        }
      } else if (dictation != null) {
        formData.value.name.text = dictation!.name ?? "";
        formData.value.autoInterval.text =
            (dictation!.autoInterval ?? FormDictation.defaultAutoInterval)
                .toString();
        formData.value.autoRepeatCount.text =
            (dictation!.autoRepeatCount ?? FormDictation.defaultAutoRepeatCount)
                .toString();
        for (var element in dictation!.words ?? []) {
          formData.value.words.add(WordItemFormData()
            ..word.text = element.word ?? ""
            ..speak.text = element.speak ?? ""
            ..description.text = element.description ?? "");
        }
      }
      formData.refresh();
    }
  }

  /// 删除字词
  removeWordItem(int index) {
    formData.value.words.removeAt(index);
    formData.refresh();
    saveDraft();
  }

  /// 增加字词
  addWordItem() {
    formData.value.words.add(WordItemFormData());
    formData.refresh();
    saveDraft();
  }

  /// 保存草稿
  saveDraft() {
    isarService.isar.writeTxn(() async {
      await isarService.isar.formDictations.put(FormDictation()
        ..id = dictationId.value
        ..name = formData.value.name.text
        ..autoInterval = int.tryParse(formData.value.autoInterval.text)
        ..autoRepeatCount = int.tryParse(formData.value.autoRepeatCount.text)
        ..words = formData.value.words
            .map((e) => WordItem()
              ..word = e.word.text
              ..speak = e.speak.text
              ..description = e.description.text)
            .toList()
        ..updatedAt = DateTime.now());
    });
    needSave = true;
    log("保存草稿");
  }

  /// 重置
  Future<void> resetForm() async {
    formData.value.name.text = dictation?.name ?? "";
    formData.value.autoInterval.text =
        (dictation?.autoInterval ?? FormDictation.defaultAutoInterval)
            .toString();
    formData.value.autoRepeatCount.text =
        (dictation?.autoRepeatCount ?? FormDictation.defaultAutoRepeatCount)
            .toString();
    formData.value.words.clear();
    for (var element in dictation?.words ?? []) {
      formData.value.words.add(WordItemFormData()
        ..word.text = element.word ?? ""
        ..speak.text = element.speak ?? ""
        ..description.text = element.description ?? "");
    }
    formData.refresh();
    await isarService.isar.writeTxn(() async {
      await isarService.isar.formDictations.delete(dictationId.value);
    });
    needSave = false;
    log("重置");
  }

  /// 保存
  save() async {
    final resultDictation = Dictation()
      ..name = formData.value.name.text
      ..autoInterval = int.tryParse(formData.value.autoInterval.text) ??
          FormDictation.defaultAutoInterval
      ..autoRepeatCount = int.tryParse(formData.value.autoRepeatCount.text) ??
          FormDictation.defaultAutoRepeatCount
      ..words = formData.value.words
          .map((e) => WordItem()
            ..word = e.word.text
            ..speak = e.speak.text
            ..description = e.description.text)
          .toList()
      ..wordsCount = formData.value.words.length
      ..wordsPreview =
          formData.value.words.map((e) => e.word.text).join(",").toString()
      ..folderId = dictation?.folderId ?? folderId.value
      ..updatedAt = DateTime.now();
    if (dictation != null) {
      resultDictation.id = dictationId.value;
    }
    await isarService.isar.writeTxn(() async {
      await isarService.isar.dictations.put(resultDictation);
      await isarService.isar.formDictations.delete(dictationId.value);
    });
    needSave = false;
    log("保存");
  }

  batchInput() {
    batchInputController.text.trim().split('\n').forEach((line) {
      final arr = line.trim().split(' ');
      formData.value.words.add(WordItemFormData()
            ..word.text = arr[0]
            ..speak.text = arr.length > 1 ? arr[1] : ""
            ..description.text = "" // 描述 TODO
          );
    });
    formData.refresh();
  }

  playWord(int index) {
    String text = formData.value.words[index].speak.text.trim();
    if (text.isEmpty) {
      text = formData.value.words[index].word.text.trim();
    }
    if (text.isNotEmpty) {
      ttsController.speak(text);
    }
  }
}

class EditingDictationFormData {
  final TextEditingController name = TextEditingController();
  final TextEditingController autoInterval =
      TextEditingController(text: FormDictation.defaultAutoInterval.toString());
  final TextEditingController autoRepeatCount = TextEditingController(
      text: FormDictation.defaultAutoRepeatCount.toString());
  final List<WordItemFormData> words = [];
}

class WordItemFormData {
  final TextEditingController word = TextEditingController(); // 单词
  final TextEditingController speak = TextEditingController(); // 发音
  final TextEditingController description = TextEditingController(); // 描述
}
