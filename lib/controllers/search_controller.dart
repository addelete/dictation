import 'package:dictation/enums/action_target.dart';
import 'package:dictation/models/dictation.dart';
import 'package:dictation/models/folder.dart';
import 'package:dictation/models/list_item_entry.dart';
import 'package:dictation/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

class SearchControllerSelf extends GetxController {
  /// 数据库服务
  final IsarService isarService = Get.find();

  /// 搜索框控制器
  final searchController = TextEditingController(text: '');

  final searchKey = ''.obs;

  /// 搜索类型
  final searchType = ListItemEntryType.dictation.obs;

  /// 搜索中的key
  final searchingKey = Rx<int?>(null);

  /// 当前文件夹下的听写文档列表
  final foldersMatched = <Folder>[].obs;

  /// 当前文件夹下的听写文档列表
  final dictationsMatched = <Dictation>[].obs;

  bool get isSearching {
    return searchingKey.value != null;
  }

  /// `当前文件夹`下的子级文件夹和子级听写文档列表
  List<ListItemEntry> get listItemEntries {
    if (searchType.value == ListItemEntryType.folder) {
      return foldersMatched
          .map((e) => ListItemEntry(
              type: ListItemEntryType.folder,
              id: e.id!,
              title: e.name!,
              subTitle: '标题',
              updatedAt: e.updatedAt!.toString().substring(0, 19)))
          .toList();
    } else {
      return dictationsMatched.map((e) {
        final reason = e.name!.contains(searchKey.value) ? '标题' : '字词列表';
        return ListItemEntry(
            type: ListItemEntryType.dictation,
            id: e.id!,
            title: e.name!,
            subTitle: reason,
            updatedAt: e.updatedAt!.toString().substring(0, 19));
      }).toList();
    }
  }

  bool get isResultEmpty {
    return !isSearching && searchKey.isNotEmpty && listItemEntries.isEmpty;
  }

  realSearch(String value) async {
    searchKey.value = value;
    foldersMatched.clear();
    dictationsMatched.clear();
    final now = DateTime.now().millisecondsSinceEpoch;
    searchingKey.value = now;
    if (value.isEmpty) {
      searchingKey.value = null;
      return;
    }

    var doneCount = 0;

    isarService.isar.folders
        .filter()
        .nameContains(value)
        .limit(100)
        .findAll()
        .then((folders) {
      if (now == searchingKey.value) {
        foldersMatched.addAll(folders);
        doneCount++;
        if (doneCount == 2) {
          searchingKey.value = null;
        }
      }
    });

    isarService.isar.dictations
        .filter()
        .group((q) => q.nameContains(value).or().wordsPreviewContains(value))
        .limit(100)
        .findAll()
        .then((dictations) {
      if (now == searchingKey.value) {
        dictationsMatched.addAll(dictations);
        doneCount++;
        if (doneCount == 2) {
          searchingKey.value = null;
        }
      }
    });
  }
}
