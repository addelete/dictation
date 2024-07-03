import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dictation/models/dictation.dart';
import 'package:dictation/models/folder.dart';
import 'package:dictation/models/folder_children.dart';
import 'package:dictation/services/isar_service.dart';



class DefaultDataService extends GetxService {
  /// 数据库服务
  IsarService isarService = Get.find();

  Future<DefaultDataService> init() async {
    final box = GetStorage();
    box.write("defaultData:created", false); //TODO debug
    final created = box.read<bool>("defaultData:created");
    if(created == null || !created) {
      final jsonStr = await rootBundle.loadString("assets/json/defaultData.json");

      final jsonMapData = jsonDecode(jsonStr);
      final folderChildren = FolderChildren.fromImportJson(jsonMapData);

      final currentFolder = Folders.zero;
      final importFolder = Folder()
        ..name = "默认数据"
        ..parentId = currentFolder.id
        ..updatedAt = DateTime.now();
      await isarService.isar.writeTxn(() async {
        await isarService.isar.folders.put(importFolder);
      });
      final mapFolderId = <int, int>{};
      // 创建文件夹
      for (final folder in folderChildren.folders) {
        final parentId = mapFolderId[folder.parentId!] ?? importFolder.id;
        final oldId = folder.id;
        final newFolder = folder.clone()
          ..id = null
          ..parentId = parentId
          ..updatedAt = DateTime.now();
        await isarService.isar.writeTxn(() async {
          await isarService.isar.folders.put(newFolder);
        });
        mapFolderId[oldId!] = newFolder.id!;
      }
      // 创建文档
      for (final dictation in folderChildren.dictations) {
        final folderId = mapFolderId[dictation.folderId!] ?? importFolder.id;
        final newDictation = dictation.clone()
          ..id = null
          ..folderId = folderId
          ..updatedAt = DateTime.now();
        await isarService.isar.writeTxn(() async {
          await isarService.isar.dictations.put(newDictation);
        });
      }
      box.write("defaultData:created", true);
    }
    return this;
  }

}
