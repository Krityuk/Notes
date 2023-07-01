// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:round3_banao_flutter/bloc_add_newNote/add_note_bloc.dart';
import 'package:round3_banao_flutter/bloc_add_newNote/add_note_state.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddNoteBloc>(
      create: (context) => AddNoteBloc(),
      child: Builder(
        builder: (context) {
          return SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, top: 18), // Apply desired padding
                  child: AppBar(
                    title: const Text(
                      'Add Note',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    BlocBuilder<AddNoteBloc, AddNoteState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {
                                context.read<AddNoteBloc>().toggleImportant();
                              },
                              child: Text(
                                state.isItImportant
                                    ? 'Marked as Important'
                                    : 'Mark it as Important',
                                style: TextStyle(
                                  color: state.isItImportant
                                      ? Colors.green
                                      : Colors.orangeAccent,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (state.isItImportant)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  final String title = _titleController.text;
                  final String description = _descriptionController.text;
                  context
                      .read<AddNoteBloc>()
                      .addNote(title, description, context);
                },
                label: const Text(' Save '),
                icon: const Icon(Icons.save),
              ),
            ),
          );
        },
      ),
    );
  }
}
