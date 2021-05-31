import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_users/models/User.dart';

class Controller {
  BuildContext _context;
  FirebaseAuth _auth;
  String _uid;
  CollectionReference _reference;

  Controller(this._context) {
    Firebase.initializeApp();
  }

  Size getScreenSize() {
    return MediaQuery.of(_context).size;
  }

  void initializeFirebaseAuth() {
    _auth = FirebaseAuth.instance;
  }

  void initializeFirebaseFirestore() {
    _reference = FirebaseFirestore.instance.collection('profiles');
  }

  Future createUser(String email, String password, String name) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      _uid = user.uid;
      return user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future signInUser(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      return user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future signOut() {
    try {
      return _auth.signOut();
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> saveUserData(String name, String email, String password) async {
    try {
      return await _reference
          .doc(_uid)
          .set(MyUser(name: name, email: email, date: DateTime.now()).toJson());
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future updateUser(String uid, String name, String email, DateTime date) {
    return _reference
        .doc(uid)
        .update(MyUser(name: name, email: email, date: date).toJson())
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  progressDialogue(BuildContext context) {
    //set up the AlertDialog
    AlertDialog alert=AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    showDialog(
      //prevent outside touch
      barrierDismissible: false,
      context:context,
      builder: (BuildContext context) {
        //prevent Back button press
        return WillPopScope(
            onWillPop: (){},
            child: alert);
      },
    );

  }
}
