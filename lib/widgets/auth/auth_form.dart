import 'dart:io';

import 'package:chatting/widgets/image_picke.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email,String password,String username,File image,bool isLoagin,BuildContext ctx ) submitbtn;

  final bool isLoading;
  AuthForm(this.submitbtn,this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _key = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = "";
  String _password = "";
  String _username = "";
  File _imagefile;
  void pickedfn(File pickedimage)
  {
    _imagefile=pickedimage;
  }
  void _submit() {
    final isValid = _key.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!_isLogin &&_imagefile == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "Please pick Image",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme
            .of(context)
            .errorColor,
      ));
      return;
    }
    if (isValid) {
      _key.currentState.save();
    widget.submitbtn(_email.trim(),_password.trim(),_username.trim(),_imagefile,_isLogin,context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(

          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                   if (!_isLogin)UserImagePicker(pickedfn),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    key: ValueKey('email'),
                    decoration: InputDecoration(labelText: "email"),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@'))
                        return "Please Enter a Vaild Email";
                      return null;
                    },
                    onSaved: (newValue) {
                      _email = newValue;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: true,
                      key: ValueKey('username'),
                      decoration: InputDecoration(labelText: "Username"),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4)
                          return "Please Enter At Least 4 Characters";
                        return null;
                      },
                      onSaved: (newValue) {
                        _username = newValue;
                      },
                      keyboardType: TextInputType.text,
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(labelText: "Password"),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7)
                        return "Please Enter at Least Characters";
                      return null;
                    },
                    onSaved: (newValue) {
                      _password = newValue;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: true,
                  ),
                  SizedBox(height: 12,),
                  if(!widget.isLoading) RaisedButton(
                    onPressed: _submit,
                    child: Text(_isLogin ? "Login" : "Sign Up"),
                  ),
                  if(widget.isLoading)
                    CircularProgressIndicator(),
                  if(!widget.isLoading)  FlatButton(
                    onPressed: () {
                      setState(() {
                        _isLogin= !_isLogin;
                      });
                    },
                    child: Text(_isLogin?"Create New Account":"I Already have an Account"),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ),

    );
  }
}
