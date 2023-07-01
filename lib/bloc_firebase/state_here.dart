import 'package:equatable/equatable.dart';

import '../models/noteslist_model.dart';

abstract class NotesState extends Equatable {
  const NotesState();
  @override
  List<Object> get props => [];
}

class NotesInitialState extends NotesState {}

class NotesLoadingState extends NotesState {}

class NotesLoadedState extends NotesState {
  final List<NotesModel> notesList;

  const NotesLoadedState({required this.notesList});

  @override
  List<Object> get props => [notesList];
}

class NotesErrorState extends NotesState {
  final String error;

  const NotesErrorState(this.error);
}
