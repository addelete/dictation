import 'package:dictation/models/folder.dart';
import 'package:dictation/models/form_dictation.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

import 'package:dictation/models/dictation.dart';

class IsarService extends GetxService {
  late Isar isar;

  Future<IsarService> init() async {
    isar =
        await Isar.open([FolderSchema, DictationSchema, FormDictationSchema]);
    return this;
  }
}
