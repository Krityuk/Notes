import 'package:equatable/equatable.dart'; // for object1 ==object2 compare directly

// ignore: must_be_immutable
class NotesModel extends Equatable {
  // ATTRIBUTES :-
  String id;
  String title;
  String descr;
  DateTime timestamp;
  String isImportant;
  String isTrash;

  // CONSTRUCTOR :- oops me jaisa constructor hota h vaisa hi constructor
  NotesModel({
    required this.id,
    required this.title,
    required this.descr,
    required this.timestamp,
    required this.isImportant,
    required this.isTrash,
  });

  // NOTE CLASSNAME.FROMJSON()  is just a func that takes map as input and returns a NotesModel obj
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

  // NOTE CLASSNAME.TOJSON()  is just a func that takes model as input and convets it into map/json
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

  @override // EQUATABLE PACKAGE IS FOR overriding the '==' and THE hashCode methods
  List<Object?> get props => // EASY COMPARISION OF OBJECTS
      [id, title, descr, timestamp, isImportant, isTrash];
}
