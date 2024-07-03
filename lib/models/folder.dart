import 'package:isar/isar.dart';

part 'folder.g.dart';

@collection
class Folder {
  Id? id;

  @Index()
  String? name; // 名称

  @Index()
  int? parentId; // 父级id

  @Index()
  DateTime? updatedAt; // 更新时间

  Folder({this.id, this.name, this.parentId, this.updatedAt});

  @override
  String toString() {
    return 'Folder{id: $id, name: $name, parentId: $parentId, updatedAt: $updatedAt}';
  }

  Folder clone() {
    return Folder(
      id: id,
      name: name,
      parentId: parentId,
      updatedAt: updatedAt,
    );
  }

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'] as Id,
      name: json['name'] as String,
      parentId: json['parentId'] as int,
      updatedAt:  DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'name': name ?? "",
      'parentId': parentId ?? 0,
    };
  }
}

class Folders {
  static get zero => Folder()
    ..id = 0
    ..name = "根文件夹";
}
