import 'package:dictation/enums/action_target.dart';
import 'package:dictation/generated/assets.dart';
import 'package:dictation/widgets/search_box.dart';
import 'package:dictation/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dictation/controllers/search_controller.dart';

class SearchView extends GetView<SearchControllerSelf> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back), onPressed: Get.back),
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SearchBox(
              controller: controller.searchController,
              onSearch: (value) {
                controller.realSearch(value);
              },
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SimpleButton(
                      onPressed: () {
                        controller.searchType.value =
                            ListItemEntryType.dictation;
                      },
                      type: controller.searchType.value ==
                              ListItemEntryType.dictation
                          ? SimpleButtonType.primary
                          : null,
                      size: SimpleButtonSize.small,
                      child: const Text("听写文档")),
                  const SizedBox(width: 12),
                  SimpleButton(
                      onPressed: () {
                        controller.searchType.value = ListItemEntryType.folder;
                      },
                      type: controller.searchType.value ==
                              ListItemEntryType.folder
                          ? SimpleButtonType.primary
                          : null,
                      size: SimpleButtonSize.small,
                      child: const Text("文件夹")),
                ],
              ),
            ),
            if (controller.isSearching)
              const SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            if (controller.isResultEmpty)
              const SizedBox(
                height: 200,
                child: Center(
                  child: Opacity(opacity: 0.5, child: Text("没有搜索结果")),
                ),
              ),
            if (controller.listItemEntries.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: controller.listItemEntries.length,
                  itemBuilder: (context, index) {
                    return Obx(() => InkWell(
                          onTap: () {
                            if (controller.listItemEntries[index].type ==
                                ListItemEntryType.dictation) {
                              Get.toNamed("/play_dictation", arguments: {
                                "dictationId":
                                    controller.listItemEntries[index].id
                              });
                            } else {
                              Get.back(result: {
                                "folderId": controller.listItemEntries[index].id
                              });
                            }
                          },
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.only(left: 16),
                            child: Row(
                              children: [
                                if (controller.listItemEntries[index].type ==
                                    ListItemEntryType.dictation)
                                  SvgPicture.asset(
                                    Assets.svgDictation,
                                    width: 32,
                                    height: 32,
                                  ),
                                if (controller.listItemEntries[index].type ==
                                    ListItemEntryType.folder)
                                  SvgPicture.asset(
                                    Assets.svgFolderBlue,
                                    width: 32,
                                    height: 32,
                                  ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.listItemEntries[index].title,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Opacity(
                                        opacity: 0.5,
                                        child: Text(
                                          '${controller.listItemEntries[index].subTitle}包含"${controller.searchKey.value}"',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
