import 'package:isar/isar.dart';

part 'dictation.g.dart';

@collection
class Dictation {
  Id? id; // id

  @Index()
  String? name; // 名称

  int? autoInterval; // 自动下一项时每项时长，单位秒
  int? autoRepeatCount; // 自动下一项时每项重复次数
  List<WordItem>? words; // 单词列表
  int? wordsCount; // 字词数量

  @Index()
  String? wordsPreview; // 字词预览，字词以逗号分隔

  @Index()
  int? folderId; // 所属文件夹id

  @Index()
  DateTime? updatedAt; // 更新时间

  Dictation(
      {this.id,
      this.name,
      this.autoInterval,
      this.autoRepeatCount,
      this.words,
      this.wordsCount,
      this.wordsPreview,
      this.folderId,
      this.updatedAt});

  @override
  String toString() {
    return 'Dictation{id: $id, name: $name, autoInterval: $autoInterval, autoRepeatCount: $autoRepeatCount, words: $words, wordsCount: $wordsCount, wordsPreview: $wordsPreview, folderId: $folderId, updatedAt: $updatedAt}';
  }

  Dictation clone() {
    return Dictation(
      id: id,
      name: name,
      autoInterval: autoInterval,
      autoRepeatCount: autoRepeatCount,
      words: words?.map((e) => e.clone()).toList(),
      wordsCount: wordsCount,
      wordsPreview: wordsPreview,
      folderId: folderId,
      updatedAt: updatedAt,
    );
  }

  factory Dictation.fromJson(Map<String, dynamic> json) {
    final words = (json['words'] as List<dynamic>?)
        ?.map((e) => WordItem.fromJson(e as Map<String, dynamic>))
        .toList();
    final wordsPreview = words?.map((e) => e.word).join(",");
    return Dictation(
      id: json['id'] as Id,
      name: json['name'] as String,
      autoInterval: json['autoInterval'] as int,
      autoRepeatCount: json['autoRepeatCount'] as int,
      words: words,
      wordsCount: words?.length ?? 0,
      wordsPreview: wordsPreview,
      folderId: json['folderId'] as int,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'name': name ?? "",
      'autoInterval': autoInterval ?? 0,
      'autoRepeatCount': autoRepeatCount ?? 0,
      'words': words?.map((e) => e.toJson()).toList(),
      'folderId': folderId ?? 0,
    };
  }
}

@embedded
class WordItem {
  String? word; // 单词
  String? speak; // 发音
  String? description; // 描述

  WordItem({this.word, this.speak, this.description});

  WordItem clone() {
    return WordItem(
      word: word,
      speak: speak,
      description: description,
    );
  }

  factory WordItem.fromJson(Map<String, dynamic> json) {
    return WordItem(
      word: json['word'] as String,
      speak: json['speak'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word ?? "",
      'speak': speak ?? "",
      'description': description ?? "",
    };
  }
}
