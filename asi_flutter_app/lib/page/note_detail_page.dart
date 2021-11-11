import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/page/notes_page.dart';
import 'package:intl/intl.dart';
import '/model/note.dart';
import '/page/edit_note_page.dart';
import 'package:http/http.dart' as http;

class NoteDetailPage extends StatefulWidget {
  NoteDetailPage(
      {Key? key, required this.note, required this.index, required this.user})
      : super(key: key);

  final Note note;
  final int index;
  final User user;

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        backgroundColor: Colors.grey[900],
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      widget.note.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(widget.note.createdTime),
                      style: TextStyle(color: Colors.white38),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.note.description,
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              AddEditNotePage(note: widget.note, user: widget.user),
        ));
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await deleteNote();
        },
      );
  Future deleteNote() async {
    var res = http.delete(Uri.parse("http://10.0.2.2:3000/remove"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'note_id': widget.note.id,
        }));

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NotesPage(user: widget.user)));
  }
}
