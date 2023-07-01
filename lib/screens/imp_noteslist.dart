import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:round3_banao_flutter/screens/note_detailed.dart';

import '../models/noteslist_model.dart';

class ImportantPage extends StatelessWidget {
  const ImportantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Important Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('noteslist')
            .orderBy('timestamp')
            .where('isImportant', isEqualTo: true.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching List : ${snapshot.error}'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No important notes found'),
            );
          } else {
            final notesList = snapshot.data!.docs
                .map((doc) =>
                    NotesModel.fromJson(doc.data() as Map<String, dynamic>))
                //yaha notesModel me fromJsonkr diye isliye note.title likh pa rhe warna note['title'] likhte obviously
                // .where((note) => note.isImportant == 'false')
                .toList();

            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  final note = notesList[index];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 120,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteScreen(note: note),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'noteCard_${note.title}',
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.lightBlue,
                                  Colors.blueGrey
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${note.title}      (imp)',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  note.descr,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
