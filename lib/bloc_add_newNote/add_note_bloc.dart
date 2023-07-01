import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:round3_banao_flutter/bloc_add_newNote/add_note_state.dart';


class AddNoteBloc extends Cubit<AddNoteState> {
  final bool isItImportant = false;

  AddNoteBloc() : super(AddNoteState(false));

  void toggleImportant() {
    emit(AddNoteState(!state.isItImportant));
  }

  void addNote(String title, String description, context) async {
    if (title.isNotEmpty && description.isNotEmpty) {
      await FirebaseFirestore.instance.collection('noteslist').add({
        'id': '',
        'title': title,
        'descr': description,
        'timestamp': FieldValue.serverTimestamp(),
        'isImportant': state.isItImportant.toString(),
        'isTrash': 'false',
      }).then((newDoc) {
        String newDocId = newDoc.id;
        newDoc.update({'id': newDocId});
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note Added'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.black,
          content: Text('🙄 Please fill the above values'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}