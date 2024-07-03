import 'package:dictation/enums/sort.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dictation/controllers/home_controller.dart';
import 'package:dictation/generated/assets.dart';
import 'package:dictation/enums/action_target.dart';
import 'package:dictation/widgets/show_popup.dart';
import 'package:dictation/widgets/image_icon_button.dart';
import 'package:dictation/widgets/show_confirm_dialog.dart';
import 'package:dictation/widgets/label_icon_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(context) {
    return Obx(() => Scaffold(
        appBar: controller.selectMode.value
            ? AppBar(
                title: const Text("选择", style: TextStyle(fontSize: 18)),
                titleSpacing: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.exitSelectMode();
                  },
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        controller.toggleSelectAll();
                      },
                      child: Text(controller.selectedIds.length ==
                              controller.listItemEntries.length
                          ? "全不选"
                          : "全选")),
                ],
              )
            : AppBar(
                title: Text("${controller.currentFolder.value.name}",
                    style: const TextStyle(fontSize: 18)),
                titleSpacing: controller.isZeroCurrentFolder ? 16 : 0,
                leading: controller.isZeroCurrentFolder
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: controller.backFolder),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: () {
                      launchUrlString(
                          "https://pan.baidu.com/s/1SwI8m4HTybW457Q9QdKA2Q?pwd=tepg",
                          mode: LaunchMode.externalApplication);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      final result = await Get.toNamed("/search");
                      if (result != null) {
                        controller.openFolderById(result['folderId']);
                      }
                    },
                  ),
                  IconButton(
                      icon: const Icon(Icons.checklist_rtl_outlined),
                      onPressed: () {
                        controller.enterSelectMode();
                      }),
                ],
              ),
        body: SafeArea(
          child: Column(
            children: [
              if (!controller.selectMode.value)
                Row(
                  children: [
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        showSortPopup();
                      },
                      child: SizedBox(
                        height: 32,
                        child: Opacity(
                          opacity: 0.5,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                controller.sortAsc.value
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                size: 12,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                "按${controller.sortField.value == SortField.title ? '名称' : '更新时间'}排序",
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              Expanded(
                child: NotificationListener<UserScrollNotification>(
                  onNotification: controller.onUserScrollNotification,
                  child: ListView.builder(
                      itemCount: controller.listItemEntries.length,
                      itemBuilder: (context, index) {
                        return Obx(() => InkWell(
                              onTap: () {
                                if (controller.selectMode.value) {
                                  controller.toggleSelectById(
                                      "${controller.listItemEntries[index].type.name}:${controller.listItemEntries[index].id}");
                                } else {
                                  controller.openListItemEntry(
                                      controller.listItemEntries[index]);
                                }
                              },
                              onLongPress: () {
                                if (!controller.selectMode.value) {
                                  controller.actionTarget.value =
                                      controller.listItemEntries[index];
                                  showMoreActionsPopup();
                                }
                              },
                              child: Container(
                                height: 65,
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                  children: [
                                    if (controller
                                            .listItemEntries[index].type ==
                                        ListItemEntryType.dictation)
                                      SvgPicture.asset(
                                        Assets.svgDictation,
                                        width: 32,
                                        height: 32,
                                      ),
                                    if (controller
                                            .listItemEntries[index].type ==
                                        ListItemEntryType.folder)
                                      SvgPicture.asset(
                                        Assets.svgFolderBlue,
                                        width: 32,
                                        height: 32,
                                      ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller
                                                .listItemEntries[index].title,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          if (controller.listItemEntries[index]
                                                  .subTitle !=
                                              null)
                                            Opacity(
                                              opacity: 0.5,
                                              child: Text(

                                                controller
                                                    .listItemEntries[index]
                                                    .subTitle!,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ),
                                          Opacity(
                                            opacity: 0.5,
                                            child: Text(
                                              controller.listItemEntries[index]
                                                  .updatedAt,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    controller.selectMode.value
                                        ? Checkbox(
                                            value: controller.selectedIds.contains(
                                                "${controller.listItemEntries[index].type.name}:${controller.listItemEntries[index].id}"),
                                            onChanged: (bool? _) {
                                              controller.toggleSelectById(
                                                  "${controller.listItemEntries[index].type.name}:${controller.listItemEntries[index].id}");
                                            },
                                          )
                                        : IconButton(
                                            icon: const Icon(Icons.more_vert),
                                            onPressed: () {
                                              controller.actionTarget.value =
                                                  controller
                                                      .listItemEntries[index];
                                              showMoreActionsPopup();
                                            },
                                          ),
                                  ],
                                ),
                              ),
                            ));
                      }),
                ),
              ),
              if (controller.selectMode.value)
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0x66888888), width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      LabelIconButton(
                          disabled: controller.selectedIds.isEmpty,
                          onPressed: () {
                            showConfirmDialog(
                                title: "删除选中",
                                contentText: "确定要删除选中项吗？",
                                onConfirm: () async {
                                  await controller.deleteSelected();
                                  Get.back();
                                  controller.exitSelectMode();
                                });
                          },
                          icon: Icons.delete_outline,
                          label: "删除"),
                      const SizedBox(width: 16),
                      LabelIconButton(
                          disabled: controller.selectedIds.isEmpty,
                          onPressed: () {
                            showMovePopup();
                          },
                          icon: Icons.drive_file_move_rtl_outlined,
                          label: "移动"),
                      const SizedBox(width: 16),
                      LabelIconButton(
                          disabled: controller.selectedIds.isEmpty,
                          onPressed: () async {
                            final path = await controller.exportAndDownload();
                            if (path.isNotEmpty) {
                              Get.showSnackbar(GetSnackBar(
                                message: "保存至：$path",
                                duration: const Duration(seconds: 5),
                              ));
                            }
                          },
                          icon: Icons.download_outlined,
                          label: "导出"),
                      const SizedBox(width: 16),
                    ],
                  ),
                )
            ],
          ),
        ),
        floatingActionButton: controller.floatingActionButtonVisible.value &&
                controller.selectMode.value == false
            ? FloatingActionButton(
                onPressed: () => showAddSthPopup(),
                // onPressed: () => showEditingFolderPopup(context),
                child: const Icon(Icons.add),
              )
            : null));
  }

  /// 显示加点什么的弹窗
  void showAddSthPopup() {
    showPopup(
      title: "新建或导入",
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            ImageIconButton(
                iconPath: Assets.svgFolderBlue,
                title: "新建文件夹",
                onPressed: () {
                  Get.back();
                  showEditingFolderPopup();
                }),
            const SizedBox(width: 20),
            ImageIconButton(
                iconPath: Assets.svgDictation,
                title: "新建听写",
                onPressed: () async {
                  Get.back();
                  await Get.toNamed("/edit_dictation", arguments: {
                    "folderId": controller.currentFolder.value.id
                  });
                  controller.whenCurrentFolderChanged();
                }),
            const SizedBox(width: 20),
            ImageIconButton(
                iconPath: Assets.pngImportFile,
                title: "从文件导入",
                onPressed: () async {
                  Get.back();
                  try {
                    await controller.importFromFile();
                    Get.showSnackbar(const GetSnackBar(
                      message: "导入成功",
                      duration: Duration(seconds: 2),
                    ));
                  } catch(err) {
                    Get.showSnackbar(const GetSnackBar(
                      message: "导入失败",
                      duration: Duration(seconds: 2),
                    ));
                  }
                }),
            const SizedBox(width: 20),
            ImageIconButton(
                iconPath: Assets.pngImportLink,
                title: "从网址导入",
                onPressed: () {
                  Get.back();
                  showImportFromUrlPopup();
                }),
          ],
        ),
      ),
    );
  }

  void showImportFromUrlPopup() {
    controller.importFromUrlController.text = "";
    showPopup(
      title: "从网址导入",
      onOk: () async {
        Get.back();
        try {
          final success = await controller.importFromUrl();
          if(success) {
            Get.showSnackbar(const GetSnackBar(
              message: "导入成功",
              duration: Duration(seconds: 2),
            ));
          }
        } catch(err) {
          Get.showSnackbar(const GetSnackBar(
            message: "导入失败",
            duration: Duration(seconds: 2),
          ));
        }

      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        child: TextField(
          controller: controller.importFromUrlController,
          decoration: const InputDecoration(
            labelText: '网址',
          ),
        ),
      ),
    );
  }

  /// 显示编辑文件夹的弹窗
  void showEditingFolderPopup({bool isCreate = true}) {
    if(isCreate) {
      controller.editingFolderNameController.text = "";
    }
    showPopup(
      title: isCreate ? "新建文件夹" : "重命名文件夹",
      onOk: () {
        if (controller.editingFolderNameController.text.isEmpty) return;
        if (isCreate) {
          controller.createFolder();
        } else {
          controller.renameFolder();
        }
        controller.editingFolderNameController.clear();
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SvgPicture.asset(
              Assets.svgFolderBlue,
              width: 48,
              height: 48,
            ),
            const SizedBox(height: 20),
            Container(
              width: 180,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Color.fromRGBO(160, 160, 160, 0.1),
              ),
              child: TextField(
                  controller: controller.editingFolderNameController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: '文件夹名称',
                    filled: true,
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12),
                    fillColor: Colors.transparent,
                    floatingLabelBehavior:
                        FloatingLabelBehavior.never, // 不显示悬浮文字
                  )),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示更多操作的弹窗
  void showMoreActionsPopup() {
    final isFolder =
        controller.actionTarget.value!.type == ListItemEntryType.folder;
    showPopup(
      title: isFolder ? "文件夹操作" : "听写文档操作",
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            isFolder
                ? ImageIconButton(
                    iconPath: Assets.pngRename,
                    title: "重命名",
                    onPressed: () {
                      Get.back();
                      controller.editingFolderNameController.text =
                          controller.actionTargetFolder!.name!;
                      showEditingFolderPopup(isCreate: false);
                    })
                : ImageIconButton(
                    iconPath: Assets.pngEdit,
                    title: "修改",
                    onPressed: () async {
                      Get.back();
                      await Get.toNamed("/edit_dictation", arguments: {
                        "dictationId": controller.actionTarget.value!.id,
                        "folderId": controller.actionTargetDictation!.folderId
                      });
                      controller.whenCurrentFolderChanged();
                    }),
            const SizedBox(width: 20),
            ImageIconButton(
                iconPath: Assets.pngDelete,
                title: "删除",
                onPressed: () {
                  Get.back();
                  if (isFolder) {
                    showConfirmDialog(
                        title: "删除文件夹",
                        contentText:
                            "确定要删除文件夹《${controller.actionTargetFolder!.name!}》吗？",
                        onConfirm: () async {
                          await controller.deleteFolderById(
                              controller.actionTarget.value!.id);
                          Get.back();
                        });
                  } else {
                    showConfirmDialog(
                        title: "删除听写文档",
                        contentText:
                            "确定要删除听写文档《${controller.actionTargetDictation!.name!}》吗？",
                        onConfirm: () async {
                          await controller.deleteDictationById(
                              controller.actionTarget.value!.id);
                          Get.back();
                        });
                  }
                }),
            const SizedBox(width: 20),
            ImageIconButton(
                iconPath: Assets.pngMoveToFolder,
                title: "移动",
                onPressed: () {
                  Get.back();
                  showMovePopup();
                }),
            const SizedBox(width: 20),
            ImageIconButton(
                iconPath: Assets.pngDownload,
                title: "导出",
                onPressed: () async {
                  Get.back();
                  final path = await controller.exportAndDownload();
                  if (path.isNotEmpty) {
                    Get.showSnackbar(GetSnackBar(
                      message: "导出成功，保存在：$path",
                      duration: const Duration(seconds: 5),
                    ));
                  }
                }),
          ],
        ),
      ),
    );
  }

  /// 显示移动文件夹或听写文档的弹窗
  void showMovePopup() {
    controller.resetMoveToFolder();
    showPopup(
      titleWidget: Obx(() => Text("移动到：${controller.moveToFolder.value.name}")),
      onOk: () async {
        final success = await controller.confirmMoveToFolder();
        Get.back();
        if (success) {
          Get.showSnackbar(const GetSnackBar(
            message: "移动成功",
            duration: Duration(seconds: 1),
          ));
          if (controller.selectMode.value) {
            controller.exitSelectMode();
          }
        }
      },
      child: SizedBox(
        height: 300,
        child: Obx(() {
          return ListView.builder(
              itemCount: controller.foldersOfMoveToFolder.length,
              itemBuilder: (context, index) => Obx(() => InkWell(
                    onTap: () {
                      controller.handleMoveToFolderChange(
                          controller.foldersOfMoveToFolder[index].id!);
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            controller.foldersOfMoveToFolder[index].id ==
                                    controller.moveToFolder.value.parentId
                                ? Assets.svgFolderYellow
                                : Assets.svgFolderBlue,
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 16),
                          Text(controller.foldersOfMoveToFolder[index].name!),
                        ],
                      ),
                    ),
                  )));
        }),
      ),
    );
  }

  /// 显示排序弹窗
  showSortPopup() {
    final primaryColor = Get.theme.primaryColor;
    showPopup(
      title: "排序",
      child: Obx(() {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                controller.sortBy(SortField.title);
                Get.back();
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    controller.sortField.value == SortField.title
                        ? Icon(
                            controller.sortAsc.value
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: controller.sortField.value == SortField.title
                                ? primaryColor
                                : null,
                            size: 18,
                          )
                        : const SizedBox(width: 18),
                    const SizedBox(width: 6),
                    Text(
                      "按名称排序",
                      style: TextStyle(
                          color: controller.sortField.value == SortField.title
                              ? primaryColor
                              : null),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.sortBy(SortField.updatedAt);
                Get.back();
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    controller.sortField.value == SortField.updatedAt
                        ? Icon(
                            controller.sortAsc.value
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: controller.sortField.value ==
                                    SortField.updatedAt
                                ? primaryColor
                                : null,
                            size: 18,
                          )
                        : const SizedBox(width: 18),
                    const SizedBox(width: 6),
                    Text(
                      "按更新时间排序",
                      style: TextStyle(
                          color:
                              controller.sortField.value == SortField.updatedAt
                                  ? primaryColor
                                  : null),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
