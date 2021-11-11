import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_firebase_notes_app/authentication/authentication.dart';
import 'package:flutter_node_firebase_notes_app/widgets/app_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '/model/note.dart';
import '/page/edit_note_page.dart';
import '/page/note_detail_page.dart';
import '/widget/note_card_widget.dart';
import 'package:http/http.dart' as http;

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //late User _user;
  //late int _currentIndex;

//   @override
//   void initState() {
//     _user = widget._user;
//     //_currentIndex = widget._screenIndex;
//     //_pageController = PageController(initialPage: widget._screenIndex);
//     createUserInFireStore();
//     super.initState();
//   }

  List<Note> notes = [];
  bool isLoading = false;
  //comment

  @override
  void initState() {
    super.initState();
    notes = [];
    refreshNotes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    var res = await http.get(Uri.parse("http://10.0.2.2:3000/getNotes"));
    try {
      final Map<String, dynamic> notss = jsonDecode(res.body);
      notss.forEach((key, value) {
        try {
          if (widget._user.email == value["user"]) {
            this.notes.add(Note(
                  id: key,
                  title: value["title"],
                  isImportant: true,
                  number: 0,
                  description: value["description"],
                  createdTime: DateTime.now(),
                ));
          }
        } catch (e) {
          print(e);
        }
      });
    } catch (e) {
      print(e);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        endDrawer: CustomAppDawer(
          user: widget._user,
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Notes',
            style: TextStyle(fontSize: 24),
          ),
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : notes.isEmpty
                  ? Text(
                      'No Notes',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddEditNotePage(user: widget._user)));
          },
        ),
      );

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(
                    note: note, index: index, user: widget._user),
              ));
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );

  createUserInFireStore() async {
    DocumentSnapshot doc = await usersRef.doc(widget._user.uid).get();
    if (!doc.exists) {
      usersRef.doc(widget._user.uid).set({
        "id": widget._user.uid,
        "photoUrl": widget._user.photoURL,
        "email": widget._user.email,
        "displayName": widget._user.displayName,
      });
    }
  }
}
