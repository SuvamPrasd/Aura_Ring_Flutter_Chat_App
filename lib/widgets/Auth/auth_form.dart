import 'package:flutter/material.dart';
import 'dart:io';

import '../picker/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
    BuildContext context,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail;
  var _userName;
  var _userPassword;
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    //close the keyboard after submitting the form
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName,
        _userPassword,
        _userImageFile,
        _isLogin,
        context,
      );

      //send to firebase auth
    }
  }

  @override
  Widget build(BuildContext context) {
    print('form rerun');
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Auraring',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily:
                              Theme.of(context).textTheme.title.fontFamily,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      if (!_isLogin) UserImagePicker(_pickedImage),
                      TextFormField(
                        key: ValueKey('email'),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please enter valid email address.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                          icon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                        ),
                        onSaved: (value) {
                          _userEmail = value;
                        },
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: ValueKey('username'),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value.isEmpty || value.length < 4) {
                              return 'Username must be atleast 5 characters long';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                              icon: Icon(
                                Icons.person,
                                color: Colors.white,
                              )),
                          onSaved: (value) {
                            _userName = value;
                          },
                        ),
                      TextFormField(
                        key: ValueKey('password'),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return 'Password must be atleast 7 characters long';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                            icon: Icon(
                              Icons.security,
                              color: Colors.white,
                            )),
                        onSaved: (value) {
                          _userPassword = value;
                        },
                      ),
                      SizedBox(height: 12),
                      if (widget.isLoading) CircularProgressIndicator(),
                      if (!widget.isLoading)
                        ButtonBar(
                          alignment: MainAxisAlignment.end,
                          buttonPadding: EdgeInsets.all(10),
                          children: <Widget>[
                            RaisedButton(
                              elevation: 5,
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, right: 20, left: 20),
                              onPressed: _trySubmit,
                              child: Text(_isLogin ? 'Sign in' : 'Sign up'),
                            ),
                            RaisedButton(
                              elevation: 5,
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, right: 20, left: 20),
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin ? 'Sign up' : 'Sign in'),
                              // textColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
