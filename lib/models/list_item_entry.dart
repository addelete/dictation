import 'package:dictation/enums/action_target.dart';

class ListItemEntry {
  final ListItemEntryType type;
  final int id;
  final String title;
  final String? subTitle;
  final String updatedAt;

  const ListItemEntry({required this.type, required this.id, required this.title, this.subTitle, required this.updatedAt});
}
