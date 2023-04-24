import 'dart:math';

import 'package:dictation/models/dictation.dart';
import 'package:dictation/models/folder.dart';

class FolderChildren {
  final List<Folder> folders;
  final List<Dictation> dictations;
  final version = 1;

  FolderChildren({required this.folders, required this.dictations});

  factory FolderChildren.fromImportJson(
      Map<String, dynamic> json) {
    return FolderChildren(
      folders: (json['folders'] as List<dynamic>?)?.map((e) {
            final folder = Folder.fromJson(e as Map<String, dynamic>);
            folder.id = folder.id;
            folder.parentId = folder.parentId;
            return folder;
          }).toList() ??
          [],
      dictations: (json['dictations'] as List<dynamic>?)?.map((e) {
            final dictation = Dictation.fromJson(e as Map<String, dynamic>);
            dictation.id = dictation.id;
            dictation.folderId = dictation.folderId;
            return dictation;
          }).toList() ??
          [],
    );
  }

  Map<String, dynamic> toExportJson() {
    return {
      "version": version,
      'folders': folders
          .map((e) => (e.clone()
                ..id = e.id!
                ..parentId = e.parentId!
                ..updatedAt = null)
              .toJson())
          .toList(),
      'dictations': dictations
          .map((e) => (e.clone()
                ..id = e.id!
                ..folderId = e.folderId!
                ..updatedAt = null)
              .toJson())
          .toList(),
    };
  }
}
