import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:round3_banao_flutter/models/noteslist_model.dart';
import 'package:round3_banao_flutter/screens/add_note.dart';
import 'package:round3_banao_flutter/screens/imp_noteslist.dart';
import 'package:round3_banao_flutter/screens/note_detailed.dart';

import '../bloc_firebase/bloc_in_it.dart';
import '../bloc_firebase/events_here.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  late NotesBloc _notesBloc;
  //NOTE HOW TO IMPLEMENT BLOC PACKAGE :-
  //NOTE listen bloc ka instance bnate h then bas notebloc.add(event1) notebloc.add(event2) etcchalate jate h, yahi hota h bas bloc me
  //_notesbloc ko yaha initaialize nai kr paye because it needs context,so initstate me initialize liya isko

  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc>(context);
  }

  @override
  void dispose() {
    _notesBloc.close();
    super.dispose();
  }

  void _navigateToAddNoteScreen() {
    // this navigator me blocProvider ko pass kr diya, taki homePage and addnotepage dono me same hi instance of blocProvider rhe
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _notesBloc,
          child: const AddNoteScreen(),
        ),
      ),
    );
  }

  bool showingTrashedItems = false;
  //
  //For searchBar, these two made
  String searchQuery = '';
  bool isSearchButtonTapped = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          //kToolbarHeight is a constant that represents the default height of appbar.
          child: Container(
            padding: const EdgeInsets.only(
                left: 18, right: 18, top: 18), // Apply desired padding
            child: (!isSearchButtonTapped)
                ? AppBar(
                    title: Text(
                        showingTrashedItems ? 'Trashed Items' : 'My Notes List',
                        style: const TextStyle(color: Colors.amber)),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            isSearchButtonTapped = true;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.star),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ImportantPage(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: showingTrashedItems
                            ? const Icon(
                                Icons.toggle_off,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.toggle_on,
                              ),
                        onPressed: () {
                          setState(() {
                            showingTrashedItems = !showingTrashedItems;
                            _notesBloc
                                .add(FetchNotesEvent(showingTrashedItems));
                          });
                        },
                      ),
                    ],
                  )
                : AppBar(
                    title: TextField(
                      style: const TextStyle(fontSize: 15),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        labelStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            if (_searchController.text.isEmpty) {
                              setState(() {
                                isSearchButtonTapped = false;
                                searchQuery = '';
                              });
                            } else {
                              _searchController.clear();
                            }
                          },
                          icon: const Icon(Icons.clear))
                    ],
                    backgroundColor: Colors.white,
                    // foregroundColor: Colors.amber,
                  ),
          ),
        ),
        body: _body(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: showingTrashedItems ? null : _navigateToAddNoteScreen,
          label: showingTrashedItems
              ? const Text('Left Swipe the cards to recover')
              : const Text('Add Note'),
          icon: showingTrashedItems ? null : const Icon(Icons.add),
        ),
      ),
    );
  }

//**************************************************************************************** */
  //
  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('noteslist')
            .orderBy('timestamp')
            .where('isTrash', isEqualTo: showingTrashedItems.toString())
            //For using where() and orderBy() together, Firestore requires an index to efficiently execute queries that involve multiple fields or sorting.
            // To resolve the issue and create the required index, you can follow these steps:

            // Open the Firestore console in your web browser.
            // Navigate to the "Indexes" section.
            // Click on "Single Field Indexes" or "Composite Indexes", depending on your specific use case.
            // Click on "Create Index".
            // Specify the collection and field(s) you want to include in the index. In this case, you need to include the "isTrash" and "timestamp" fields.
            // Save the index.
            // Once the index is created, Firestore will be able to execute the query without errors.
            //AGAR IS LAFDE ME NAI PADNA H, TO ORDERBY AND WHERE KO ALAG ALAG QUERY ME LIKHO i.e.. orderBy yaha likh dena and where neeche line no 66 me
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching List : ${snapshot.error}'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                  'Either Turn On Internet or\nNo data satisfy your search criteria \n\nerror: ${snapshot.error}'),
            );
          } else {
            //
            final notesList = snapshot.data!.docs
                .map((doc) =>
                    NotesModel.fromJson(doc.data() as Map<String, dynamic>))
                // .where((note) => note.isTrash == 'false')
                .toList();

            // Filter the notes based on the search query
            final filteredNotesList = notesList.where((note) {
              final titleMatches =
                  note.title.toLowerCase().contains(searchQuery.toLowerCase());
              final descriptionMatches =
                  note.descr.toLowerCase().contains(searchQuery.toLowerCase());
              return titleMatches || descriptionMatches;
            }).toList();

            return ListView.builder(
              itemCount: filteredNotesList.length,
              itemBuilder: (context, index) {
                final note = filteredNotesList[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    //************************************************************************* */
                    // Delete the note from Firestore here
                    // FirebaseFirestore.instance
                    //     .collection('noteslist')
                    //     .doc(note.id)
                    //     .delete();
                    //************************************************************************* */
                    // FirebaseFirestore.instance
                    //     .collection('noteslist')
                    //     .doc(note.id)
                    //     .update(showingTrashedItems? {'isTrash': 'false'}: {'isTrash': 'true'})
                    //     .then((_) {
                    //   debugPrint(
                    //       'Note updated and marked as trash successfully');
                    // }).catchError((error) {
                    //   debugPrint('Failed to update note: $error');
                    // });
                    //************************************************************************* */
                    _notesBloc.add(
                      UpdateNoteTrashStatusEvent(note.id, !showingTrashedItems),
                    );
                  },
                  background: Container(
                    color: showingTrashedItems ? Colors.green : Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      showingTrashedItems ? Icons.add : Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  child: SizedBox(
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
                                  note.title,
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
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
