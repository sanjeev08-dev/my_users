import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_users/screens/DashboardScreen.dart';
import 'package:my_users/screens/LoginScreen.dart';
import 'package:my_users/screens/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SplashScreen();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Future.delayed(Duration(seconds: 3), () {
              if (FirebaseAuth.instance.currentUser == null) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()));
              }
            });
          }
          return SplashScreen();
        },
      ),
    );
  }
}
