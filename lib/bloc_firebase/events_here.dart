import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class FetchNotesEvent extends NotesEvent {
  final bool showingTrashedItems;

  const FetchNotesEvent(this.showingTrashedItems);
}

class UpdateNoteTrashStatusEvent extends NotesEvent {
  final String id;
  final bool isTrash;

  const UpdateNoteTrashStatusEvent(this.id, this.isTrash);
}
