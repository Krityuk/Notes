import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:round3_banao_flutter/models/noteslist_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch notes list from Firebase based on isTrash flag
  //NOTE this func returns unTrashednoteslist when coming bool isTrash is false and it returns trashed notes list when isTrash is true
  static Future<List<NotesModel>> getNotesList(bool isTrash) async {
    try {
      final snapshot = await _firestore
          .collection('noteslist')
          .orderBy('timestamp')
          .where('isTrash', isEqualTo: isTrash.toString())
          .get();

      final notesList =
          snapshot.docs.map((doc) => NotesModel.fromJson(doc.data())).toList();

      return notesList;
    } catch (e) {
      throw Exception('Error fetching notes list: $e');
    }
  }

  // Update the 'isTrash' flag of a note in Firebase
  static Future<void> updateNoteTrashStatus(String noteId, bool isTrash) async {
    try {
      await _firestore.collection('noteslist').doc(noteId).update({
        'isTrash': isTrash.toString(),
      });
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }
}
