import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/chat_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuraRing',
      theme: ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Colors.indigo,
        accentColor: Colors.lightBlueAccent,
        accentColorBrightness: Brightness.dark,
        textTheme: TextTheme().copyWith(
          title: TextStyle(fontFamily: 'Poppins-light'),
        ),
        hintColor: Colors.black,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.black,
          splashColor: Colors.black26,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }

          if (userSnapshot.hasData) {
            return ChatScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}
