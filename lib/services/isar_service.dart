import 'package:dictation/models/folder.dart';
import 'package:dictation/models/form_dictation.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

import 'package:dictation/models/dictation.dart';
import 'package:path_provider/path_provider.dart';

class IsarService extends GetxService {
  late Isar isar;

  Future<IsarService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open(
            [FolderSchema, DictationSchema, FormDictationSchema],
            directory: dir.path);
    return this;
  }

}
