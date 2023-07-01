import 'package:equatable/equatable.dart'; // for object1 ==object2 compare directly

// ignore: must_be_immutable
class NotesModel extends Equatable {
  String id;
  String title;
  String descr;
  DateTime timestamp;
  String isImportant;
  String isTrash;

  NotesModel({
    required this.id,
    required this.title,
    required this.descr,
    required this.timestamp,
    required this.isImportant,
    required this.isTrash,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json["id"],
      title: json["title"],
      descr: json["descr"],
      timestamp: DateTime.now(),
      isImportant: json["isImportant"] ?? false,
      isTrash: json["isTrash"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "descr": descr,
      "timestamp": timestamp,
      "isImportant": isImportant,
      "isTrash": isTrash,
    };
  }

  @override
  List<Object?> get props =>
      [id, title, descr, timestamp, isImportant, isTrash];
}
