import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:round3_banao_flutter/bloc_firebase/events_here.dart';
import 'package:round3_banao_flutter/services/firebase_service.dart';
import 'package:round3_banao_flutter/bloc_firebase/state_here.dart';

// Define the BLoC class
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitialState()) {
    on<FetchNotesEvent>((event, emit) async {
      try {
        final notesList =
            await FirebaseService.getNotesList(event.showingTrashedItems);
        NotesLoadedState(notesList: notesList);
      } catch (error) {
        NotesErrorState(error.toString());
      }
    });
    on<UpdateNoteTrashStatusEvent>((event, emit) async {
      try {
        await FirebaseService.updateNoteTrashStatus(event.id, event.isTrash);
      } catch (error) {
        debugPrint('Error updating note trash status: $error');
      }
    });
  }
}
