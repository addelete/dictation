import 'dart:convert';
import 'dart:io';
import 'package:dictation/enums/sort.dart';
import 'package:dio/dio.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:dictation/models/dictation.dart';
import 'package:dictation/models/folder.dart';
import 'package:dictation/models/list_item_entry.dart';
import 'package:dictation/models/folder_children.dart';
import 'package:dictation/services/isar_service.dart';
import 'package:dictation/enums/action_target.dart';

class HomeController extends GetxController {
  /// 数据库服务
  IsarService isarService = Get.find();

  final dio = Dio();

  /// 当前文件夹
  final currentFolder = Rx<Folder>(Folders.zero);

  /// 当前文件夹下的听写文档列表
  final foldersOfCurrentFolder = <Folder>[].obs;

  /// 当前文件夹下的听写文档列表
  final dictationsOfCurrentFolder = <Dictation>[].obs;

  /// 是否显示页面底部的浮动添加按钮
  final floatingActionButtonVisible = true.obs;

  /// 编辑文件夹名称的控制器
  final editingFolderNameController = TextEditingController();

  final importFromUrlController = TextEditingController();

  /// 弹出控制器指向的文件夹或听写文档
  final actionTarget = Rx<ListItemEntry?>(null);

  /// 当前（移动到）文件夹
  final moveToFolder = Rx<Folder>(Folders.zero);

  /// `移动到文件夹`的子级文件夹列表
  final foldersOfMoveToFolder = <Folder>[].obs;

  /// 选择模式
  final selectMode = false.obs;

  /// 已选的id Set
  final selectedIds = <String>{}.obs;

  /// 排序字段
  final sortField = Rx<SortField>(SortField.title);

  /// 排序方式
  final sortAsc = true.obs;

  /// `当前文件夹`是否是根目录
  bool get isZeroCurrentFolder => currentFolder.value.id == Folders.zero.id;

  /// `移动到文件夹`是否是根目录
  bool get isZeroMoveToFolder => moveToFolder.value.id == Folders.zero.id;

  /// `当前文件夹`下的子级文件夹和子级听写文档列表
  List<ListItemEntry> get listItemEntries {
    final result = <ListItemEntry>[];
    result.addAll(foldersOfCurrentFolder.map((e) => ListItemEntry(
        type: ListItemEntryType.folder,
        id: e.id!,
        title: e.name!,
        subTitle: null,
        updatedAt: e.updatedAt!.toString().substring(0, 19))));
    result.addAll(dictationsOfCurrentFolder.map((e) => ListItemEntry(
        type: ListItemEntryType.dictation,
        id: e.id!,
        title: e.name!,
        subTitle: e.wordsPreview,
        updatedAt: e.updatedAt!.toString().substring(0, 19))));
    result.sort((a, b) {
      switch (sortField.value) {
        case SortField.title:
          return a.title.compareTo(b.title) * (sortAsc.value ? 1 : -1);
        case SortField.updatedAt:
          return a.updatedAt.compareTo(b.updatedAt) * (sortAsc.value ? 1 : -1);
      }
    });
    return result;
  }

  ///  弹出控制器指向的文件夹
  Folder? get actionTargetFolder {
    if (actionTarget.value?.type != ListItemEntryType.folder) {
      return null;
    }
    return foldersOfCurrentFolder
        .firstWhere((element) => element.id == actionTarget.value!.id);
  }

  ///  弹出控制器指向的听写文档
  Dictation? get actionTargetDictation {
    if (actionTarget.value?.type != ListItemEntryType.dictation) {
      return null;
    }
    return dictationsOfCurrentFolder
        .firstWhere((element) => element.id == actionTarget.value!.id);
  }

  @override
  onInit() {
    super.onInit();
    whenCurrentFolderChanged();
    ever(currentFolder, (_) {
      whenCurrentFolderChanged();
    });
    ever(moveToFolder, (_) {
      whenMoveToFolderChanged();
    });
  }

  /// 当`当前文件夹`改变时，更新`当前文件夹`的下级文件夹和听写文档列表
  whenCurrentFolderChanged() {
    getChildrenFolders(currentFolder.value.id!).then((value) {
      foldersOfCurrentFolder.value = value;
    });
    getChildrenDictations(currentFolder.value.id!).then((value) {
      dictationsOfCurrentFolder.value = value;
    });
    floatingActionButtonVisible.value = true;
  }

  /// 当`移动到文件夹`改变时，更新`移动到文件夹`的下级文件夹列表
  whenMoveToFolderChanged() async {
    foldersOfMoveToFolder.value = [];
    if (!isZeroMoveToFolder) {
      if (moveToFolder.value.parentId == Folders.zero.id) {
        foldersOfMoveToFolder.value = [Folders.zero..name = '上一级'];
      } else {
        final parentFolder = (await isarService.isar.folders
            .filter()
            .idEqualTo(moveToFolder.value.parentId)
            .findFirst())!;
        foldersOfMoveToFolder.value = [parentFolder..name = '上一级'];
      }
    }
    getChildrenFolders(moveToFolder.value.id!).then((value) {
      foldersOfMoveToFolder.addAll(value.where((element) {
        if (selectMode.value) {
          return !selectedIds.contains("folder:${element.id}");
        } else {
          return element.id != actionTargetFolder?.id;
        }
      }));
    });
  }

  /// 重置当前（移动到）文件夹为当前文件夹
  resetMoveToFolder() {
    moveToFolder.value = currentFolder.value;
  }

  /// 根据文件夹id获取子级文件夹
  Future<List<Folder>> getChildrenFolders(int folderId) async {
    final result = await isarService.isar.folders
        .filter()
        .parentIdEqualTo(folderId)
        .findAll();
    result.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    return result;
  }

  /// 根据文件夹id获取子级听写文档
  Future<List<Dictation>> getChildrenDictations(int folderId) async {
    final result = await isarService.isar.dictations
        .filter()
        .folderIdEqualTo(folderId)
        .findAll();
    result.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    return result;
  }

  /// 点击文件夹或听写文档
  openListItemEntry(ListItemEntry listItemEntry) {
    if (listItemEntry.type == ListItemEntryType.folder) {
      return openFolderById(listItemEntry.id);
    }
    if (listItemEntry.type == ListItemEntryType.dictation) {
      Get.toNamed("/play_dictation",
          arguments: {"dictationId": listItemEntry.id});
    }
  }

  /// 进入文件夹
  openFolderById(int folderId) async {
    if (folderId == Folders.zero.id) {
      currentFolder.value = Folders.zero;
      return;
    }
    final folder = (await isarService.isar.folders.get(folderId))!;
    currentFolder.value = folder;
  }

  /// 返回上一级文件夹
  backFolder() async {
    if (isZeroCurrentFolder) {
      return;
    }
    if (currentFolder.value.parentId == Folders.zero.id) {
      currentFolder.value = Folders.zero;
    } else {
      currentFolder.value =
          (await isarService.isar.folders.get(currentFolder.value.parentId!))!;
    }
  }

  /// 设置`移动到文件夹`
  handleMoveToFolderChange(int folderId) async {
    if (folderId == Folders.zero.id) {
      moveToFolder.value = Folders.zero;
      return;
    }
    moveToFolder.value = (await isarService.isar.folders.get(folderId))!;
  }

  /// 创建文件夹
  Future<void> createFolder() async {
    final folder = Folder()
      ..name = editingFolderNameController.text
      ..parentId = currentFolder.value.id
      ..updatedAt = DateTime.now();
    await isarService.isar.writeTxn(() async {
      await isarService.isar.folders.put(folder);
    });
    foldersOfCurrentFolder.add(folder);
  }

  /// 重命名文件夹
  Future<void> renameFolder() async {
    final folder = actionTargetFolder!;
    folder.name = editingFolderNameController.text;
    folder.updatedAt = DateTime.now();
    await isarService.isar.writeTxn(() async {
      await isarService.isar.folders.put(folder);
    });
    final index =
        foldersOfCurrentFolder.indexWhere((element) => element.id == folder.id);
    foldersOfCurrentFolder[index] = folder;
    foldersOfCurrentFolder.refresh();
  }

  /// 删除文件夹, 包括子文件夹和子文件夹下的听写文档
  Future<void> deleteFolderById(int folderId) async {
    final folderChildren = await getFolderDeepChildrenById(folderId);
    final folderIds = folderChildren.folders.map((e) => e.id!).toList();
    final dictationIds = folderChildren.dictations.map((e) => e.id!).toList();
    await isarService.isar.writeTxn(() async {
      await isarService.isar.folders.deleteAll([folderId, ...folderIds]);
      await isarService.isar.dictations.deleteAll(dictationIds);
    });
    final index =
        foldersOfCurrentFolder.indexWhere((element) => element.id == folderId);
    foldersOfCurrentFolder.removeAt(index);
  }

  /// 删除文档
  Future<void> deleteDictationById(int id) async {
    final dictation =
        dictationsOfCurrentFolder.firstWhere((element) => element.id == id);
    await isarService.isar.writeTxn(() async {
      await isarService.isar.dictations.delete(dictation.id!);
    });
    dictationsOfCurrentFolder.remove(dictation);
  }

  /// 用户滑动列表事件
  /// 当用户向下滑动列表时，隐藏页面底部的浮动添加按钮
  /// 当用户向上滑动列表时，显示页面底部的浮动添加按钮
  bool onUserScrollNotification(UserScrollNotification notification) {
    final ScrollDirection direction = notification.direction;
    if (direction == ScrollDirection.reverse) {
      floatingActionButtonVisible.value = false;
    } else if (direction == ScrollDirection.forward) {
      floatingActionButtonVisible.value = true;
    }
    return true;
  }

  /// 确定移动文档或文件夹
  Future<bool> confirmMoveToFolder() async {
    final moveToFolderId = moveToFolder.value.id;
    final List<int> targetFolderIds = [];
    final List<int> targetDictationIds = [];
    if (selectMode.value) {
      for (final selectId in selectedIds) {
        final arr = selectId.split(":");
        if (arr[0] == "folder") {
          targetFolderIds.add(int.parse(arr[1]));
        }
        if (arr[0] == "dictation") {
          targetDictationIds.add(int.parse(arr[1]));
        }
      }
    } else {
      if (actionTarget.value?.type == ListItemEntryType.dictation) {
        targetDictationIds.add(actionTarget.value!.id);
      }
      if (actionTarget.value?.type == ListItemEntryType.folder) {
        targetFolderIds.add(actionTarget.value!.id);
      }
    }
    if (targetFolderIds.isEmpty && targetDictationIds.isEmpty) {
      return false;
    }
    if (targetFolderIds.isNotEmpty) {
      for (final folderId in targetFolderIds) {
        final folder = foldersOfCurrentFolder
            .firstWhere((element) => element.id == folderId);
        folder.parentId = moveToFolderId;
        await isarService.isar.writeTxn(() async {
          await isarService.isar.folders.put(folder);
        });
      }
    }
    if (targetDictationIds.isNotEmpty) {
      for (final dictationId in targetDictationIds) {
        final dictation = dictationsOfCurrentFolder
            .firstWhere((element) => element.id == dictationId);
        dictation.folderId = moveToFolderId;
        await isarService.isar.writeTxn(() async {
          await isarService.isar.dictations.put(dictation);
        });
      }
    }
    whenCurrentFolderChanged();
    return true;
  }

  /// 进入选择模式
  enterSelectMode() {
    selectMode.value = true;
  }

  /// 退出选择模式
  exitSelectMode() {
    selectMode.value = false;
    selectedIds.clear();
  }

  /// 选中或取消选中
  toggleSelectById(String selectId) {
    if (selectedIds.contains(selectId)) {
      selectedIds.remove(selectId);
    } else {
      selectedIds.add(selectId);
    }
  }

  /// 全选或取消全选
  toggleSelectAll() {
    if (selectedIds.length == listItemEntries.length) {
      selectedIds.clear();
    } else {
      selectedIds.addAll(listItemEntries.map((e) => "${e.type.name}:${e.id}"));
    }
  }

  /// 删除选中的文档或文件夹
  deleteSelected() async {
    for (final selectId in selectedIds) {
      final arr = selectId.split(":");
      if (arr[0] == "folder") {
        await deleteFolderById(int.parse(arr[1]));
      }
      if (arr[0] == "dictation") {
        await deleteDictationById(int.parse(arr[1]));
      }
    }
    selectedIds.clear();
  }

  /// 获取目标文件夹的所有子文件夹和文档
  Future<FolderChildren> getFolderDeepChildrenById(int folderId) async {
    final result = FolderChildren(
      folders: [],
      dictations: [],
    );
    final parentIds = [folderId];
    while (parentIds.isNotEmpty) {
      final parentId = parentIds.removeAt(0);
      final subFolders = await isarService.isar.folders
          .filter()
          .parentIdEqualTo(parentId)
          .findAll();

      final subDictations = await isarService.isar.dictations
          .filter()
          .folderIdEqualTo(parentId)
          .findAll();
      result.folders.addAll(subFolders);
      result.dictations.addAll(subDictations);
      parentIds.addAll(subFolders.map((e) => e.id!));
    }
    return result;
  }

  /// 导出并下载，返回下载文件的路径
  Future<String> exportAndDownload() async {
    final result = FolderChildren(folders: [], dictations: []);
    if (selectMode.value) {
      for (final selectId in selectedIds) {
        final arr = selectId.split(":");
        if (arr[0] == "dictation") {
          final dictation = dictationsOfCurrentFolder
              .firstWhere((element) => element.id == int.parse(arr[1]));
          result.dictations.add(dictation);
        }
        if (arr[0] == "folder") {
          result.folders.add(foldersOfCurrentFolder
              .firstWhere((element) => element.id == int.parse(arr[1])));
          final children = await getFolderDeepChildrenById(int.parse(arr[1]));
          result.folders.addAll(children.folders);
          result.dictations.addAll(children.dictations);
        }
      }
    } else {
      if (actionTarget.value?.type == ListItemEntryType.dictation) {
        final dictation = dictationsOfCurrentFolder
            .firstWhere((element) => element.id == actionTarget.value!.id);
        result.dictations.add(dictation);
      }
      if (actionTarget.value?.type == ListItemEntryType.folder) {
        final folder = foldersOfCurrentFolder
            .firstWhere((element) => element.id == actionTarget.value!.id);
        result.folders.add(folder);
        final children = await getFolderDeepChildrenById(folder.id!);
        result.folders.addAll(children.folders);
        result.dictations.addAll(children.dictations);
      }
    }
    if (result.folders.isEmpty && result.dictations.isEmpty) {
      return "";
    }
    final jsonMapData = result.toExportJson();
    final jsonStr = jsonEncode(jsonMapData);
    final u8List = utf8.encode(jsonStr);
    Uint8List bytes = Uint8List.fromList(u8List);
    final name =
        "听写导出${DateFormat('yyyyMMddhhmmss').format(DateTime.now())}.json";
    await DocumentFileSavePlus().saveFile(bytes, name, "application/json");
    return "下载/$name";
  }

  /// 从map数据导入
  Future<void> importFromJsonMapData(Map<String, dynamic> jsonMapData) async {
    final folderChildren = FolderChildren.fromImportJson(jsonMapData);
    //  对文件夹进行排序
    folderChildren.folders.sort((a, b) => a.id! - b.id!);
    // 在当前目录下创建一个导入文件夹
    final importFolder = Folder()
      ..name = "新导入文件夹"
      ..parentId = currentFolder.value.id
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
    // 刷新当前目录
    whenCurrentFolderChanged();
  }

  /// 从文件导入
  Future<bool> importFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return false;
    }

    File file = File(result.files.single.path!);
    final bytes = await file.readAsBytes();
    final jsonStr = utf8.decode(bytes);
    final jsonMapData = jsonDecode(jsonStr);
    await importFromJsonMapData(jsonMapData);
    return true;
  }

  /// 从网址导入
  Future<bool> importFromUrl() async {
    final url = importFromUrlController.text.trim();
    if (url.isEmpty) {
      return false;
    }
    if (!RegExp(r"^https://").hasMatch(url)) {
      throw "网址必须以https://开头";
    }
    final response =
        await dio.get(url, options: Options(responseType: ResponseType.json));
    final jsonMapData = response.data;
    await importFromJsonMapData(jsonMapData);
    return true;
  }

  /// 根据字段设置排序
  sortBy(SortField field) {
    if (sortField.value == field) {
      sortAsc.value = !sortAsc.value;
    } else {
      sortField.value = field;
      sortAsc.value = true;
    }
  }
}
