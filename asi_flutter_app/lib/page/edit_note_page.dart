import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/page/notes_page.dart';
import '/model/note.dart';
import '/widget/note_form_widget.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AddEditNotePage extends StatefulWidget {
  //   const NotesPage({Key? key, required User user})
  //   : _user = user,
  //     super(key: key);

  final User user;
  final Note? note;

  const AddEditNotePage({Key? key, this.note, required this.user})
      : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  var uuid = Uuid();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        backgroundColor: Colors.grey[900],
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            isImportant: isImportant,
            number: number,
            title: title,
            description: description,
            onChangedImportant: (isImportant) =>
                setState(() => this.isImportant = isImportant),
            onChangedNumber: (number) => setState(() => this.number = number),
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
      ;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => NotesPage(user: widget.user)));
    }
  }

  Future updateNote() async {
    var user = widget.user.email;
    var res = http.put(Uri.parse("http://10.0.2.2:3000/update"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'note_id': widget.note!.id,
          'title': title,
          'description': description,
          'user': user
        }));

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NotesPage(user: widget.user)));
  }

  Future addNote() async {
    var user = widget.user.email;
    var res = await http.post(Uri.parse("http://10.0.2.2:3000/save"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'note_id': uuid.v4(),
          'title': title,
          'description': description,
          'user': user
        }));

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                NotesPage(user: widget.user))).then((_) => setState(() {}));
  }
}
