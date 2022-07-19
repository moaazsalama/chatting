import 'dart:io';

import 'file:///D:/MealApp/chatting/lib/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      File image, bool isLoagin, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential _result;
      if (isLoagin) {
        _result = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final _ref = FirebaseStorage.instance
            .ref()
            .child('user_photos')
            .child(_result.user.uid + '.jpg');
        await _ref.putFile(image);
        final url = await _ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_result.user.uid)
            .set({'username': username, 'password': password,'image_url':url});
      }
    } on FirebaseAuthException catch (e) {
      var str = "";
      if (e.code == 'weak-password') {
        str = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        str = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        str = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        str = 'Wrong password provided for that user.';
      } else
        str = "Check Your Connection";
      setState(() {
        _isLoading = false;
      });
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(
          str,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm, _isLoading),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
