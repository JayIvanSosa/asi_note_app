import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_node_firebase_notes_app/page/notes_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '/pages/note_page.dart';
import '/authentication/authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            )
          : Container(
              child: ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      _isSigningIn = true;
                    });
                    User? user =
                        await Authentication.signInWithGoogle(context: context);

                    setState(() {
                      _isSigningIn = false;
                    });

                    if (user != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => NotesPage(
                            user: user,
                            // screenIndex: 0,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      primary: Colors.white,
                      onPrimary: Colors.indigo,
                      minimumSize: Size(double.infinity, 50)),
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                  ),
                  label: Text(
                    'Login with Google',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  )),
            ),
    );
  }
}
