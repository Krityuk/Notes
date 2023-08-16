// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:round3_banao_flutter/main.dart';
import 'package:round3_banao_flutter/models/noteslist_model.dart';

class EditNoteScreen extends StatefulWidget {
  final NotesModel note;

  const EditNoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late bool isItImportant;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _descriptionController.text = widget.note.descr;
    isItImportant = widget.note.isImportant == 'true' ? true : false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  funcSaveChanges(title, description) async {
    // Save the changes and update the note in the database or storage
    await FirebaseFirestore.instance
        .collection('noteslist')
        .doc(widget.note.id)
        .update({
      'title': title,
      'descr': description,
      'isImportant': isItImportant.toString()
    }).then((_) {
      debugPrint('Note updated and marked as trash successfully');
    }).catchError((error) {
      debugPrint('Failed to update note: $error');
    });
    myShowToast(message: 'Note Saved');
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  funcDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          content: const Text(
              'Are you sure you want to delete this note?\nYou wont be able to recover it back!'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _performDelete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _performDelete() {
    FirebaseFirestore.instance
        .collection('noteslist')
        .doc(widget.note.id)
        .delete();
    myShowToast(message: 'Item Deleted', textColor: Colors.black);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            padding: const EdgeInsets.only(
                left: 18, right: 18, top: 18), // Apply desired padding
            child: AppBar(
              title: const Text('Edit Note'),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(fontSize: 24),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.black12,
                  thickness: 2.0,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.black12,
                  thickness: 2.0,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        // context.read<AddNoteBloc>().toggleImportant();
                        setState(() {
                          isItImportant = !isItImportant;
                        });
                      },
                      child: Text(
                        isItImportant
                            ? 'Marked as Important'
                            : 'Mark it as Important',
                        style: TextStyle(
                          color: isItImportant
                              ? Colors.green
                              : Colors.orangeAccent,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (isItImportant)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        funcDelete();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text('Date of creating note is: ${widget.note.timestamp}',
                    style: const TextStyle(color: Colors.purple))
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final String title = _titleController.text;
            final String description = _descriptionController.text;
            await funcSaveChanges(title, description);
          },
          label: const Text(' Save '),
          icon: const Icon(Icons.save),
        ),
      ),
    );
  }
}
