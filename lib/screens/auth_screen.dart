import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:math' as math;
import '../widgets/Auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //firebase auth instance
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  //get the form details inside the function
  void _submitAuthForm(String email, String username, String password,
      File image, bool isLogin, BuildContext context) async {
    //authresult is for future authentication result
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');

        await ref.putFile(image).onComplete;

        final imageURL = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'image_url': imageURL,
        });
      }
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (err) {
      var message = 'An error Occured, please check your credentials !';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(message),
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(
        //   // borderRadius: BorderRadius.only(topLeft: Radius.circular(0)),
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment
        //         .bottomCenter, // 10% of the width, so there are ten blinds.

        //     colors: [
        //       const Color.fromRGBO(15, 111, 255, 1),
        //       const Color.fromRGBO(255, 255, 255, 1),
        //     ],
        //   ),
        // ),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/girls.png'),
          fit: BoxFit.cover,
        )),

        child: AuthForm(
          _submitAuthForm,
          _isLoading,
        ),
      ),
    );
  }
}
