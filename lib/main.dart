import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:round3_banao_flutter/bloc_add_newNote/add_note_bloc.dart';
import 'package:round3_banao_flutter/bloc_firebase/bloc_in_it.dart';
import 'package:round3_banao_flutter/bloc_firebase/events_here.dart';
import 'package:round3_banao_flutter/firebase_options.dart';
import 'package:round3_banao_flutter/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Disable Firestore's persistent storage
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);
  //this line means ki cache of mobile wont be used. i.e.. Firestore has a local cache that stores a copy of the data on the user's device for offline access and faster retrieval. By default, Firestore uses this persistent storage to cache data and keep it synchronized with the remote server.

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                NotesBloc()..add(const FetchNotesEvent(false))),
        BlocProvider(create: (context) => AddNoteBloc())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Times',
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black, foregroundColor: Colors.amber),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.black,
            foregroundColor: Colors.amber,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}

void myShowToast({required message, Color? textColor}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
    backgroundColor: Colors.pink,
    textColor: textColor ?? Colors.white,
    fontSize: 16.0,
  );
}
