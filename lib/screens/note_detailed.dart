import 'package:flutter/material.dart';
import 'package:round3_banao_flutter/models/noteslist_model.dart';

class NoteScreen extends StatefulWidget {
  final NotesModel note;

  const NoteScreen({super.key, required this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  void _editNote() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AddNoteScreen(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //*********************************************** */
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            padding: const EdgeInsets.only(
                left: 18, right: 18, top: 18), // Apply desired padding
            child: AppBar(
              title: Text(widget.note.title),
            ),
          ),
        ),
        //*********************************************** */
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'noteCard_${widget.note.title}',
                  child: Text(
                    widget.note.title,
                    style: const TextStyle(
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
                Text(
                  widget.note.descr,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.black12,
                  thickness: 2.0,
                ),
                const SizedBox(height: 30),
                Text('Date of creating note is: ${widget.note.timestamp}',
                    style: const TextStyle(color: Colors.purple))
              ],
            ),
          ),
        ),
        //*********************************************** */
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _editNote,
          label: const Text('Edit this Note'),
          icon: const Icon(Icons.edit),
        ),

        //*********************************************** */
      ),
    );
  }
}
