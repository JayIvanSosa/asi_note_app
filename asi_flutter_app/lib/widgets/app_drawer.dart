import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_firebase_notes_app/authentication/authentication.dart';
import 'package:flutter_node_firebase_notes_app/page/login_page.dart';

class CustomAppDawer extends StatelessWidget {
  const CustomAppDawer({Key? key, required User user}) : _user = user;

  final User _user;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          LoginScreenAuth(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            color: Color(0xFF001e36),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SafeArea(
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 36),
                    child: Column(
                      children: [
                        ClipOval(
                            child: Material(
                                color: Colors.blue,
                                child: _user.photoURL != null
                                    ? Image.network(
                                        _user.photoURL!,
                                        fit: BoxFit.fitHeight,
                                      )
                                    : Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 36, vertical: 26),
                                        child: Text(_user.email.toString()[0],
                                            style: TextStyle(
                                                fontSize: 32,
                                                color: Colors.white)),
                                      ))),
                        SizedBox(height: 8),
                        _user.displayName != null
                            ? Text(
                                _user.displayName!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              )
                            : Text(
                                _user.email.toString().split("@")[0],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                        SizedBox(height: 4),
                        Text(
                          _user.email!,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )),
              ),
              Divider(color: Colors.grey),
              Container(
                child: Material(
                  child: InkWell(
                    child: Container(
                      child: ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Log out",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                          await Authentication.signOut(context: context);
                          Navigator.of(context)
                              .pushReplacement(_routeToSignInScreen());
                        },
                      ),
                    ),
                  ),
                  color: Colors.transparent,
                ),
              ),
            ])));
  }
}
