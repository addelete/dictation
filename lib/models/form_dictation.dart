import 'package:isar/isar.dart';

import '../models/dictation.dart';

part 'form_dictation.g.dart';

@collection
class FormDictation {
  Id? id; // id
  String? name;
  int? autoInterval;
  int? autoRepeatCount;
  List<WordItem>? words;
  DateTime? updatedAt;

  static int defaultAutoInterval = 10;
  static int defaultAutoRepeatCount = 1;

  @override
  String toString() {
    return 'FormDictation{id: $id, name: $name, autoInterval: $autoInterval, autoRepeatCount: $autoRepeatCount, words: $words, updatedAt: $updatedAt}';
  }
}
