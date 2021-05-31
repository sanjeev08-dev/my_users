import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my_users/models/User.dart';
import 'package:my_users/screens/LoginScreen.dart';
import 'package:my_users/utils/Controller.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Controller _controller;
  List<MyUser> myUsers;
  final _nameController = TextEditingController();
  CollectionReference _collectionRef;

  @override
  void initState() {
    // TODO: implement initState
    myUsers = [];
  }

  @override
  Widget build(BuildContext context) {
    _controller = Controller(context);
    _controller.initializeFirebaseAuth();
    _controller.initializeFirebaseFirestore();

    return Scaffold(
      appBar: AppBar(
        title: Text('${FirebaseAuth.instance.currentUser.email}'),
        automaticallyImplyLeading: false,
        actions: [
          FlatButton(
              onPressed: () {
                signOutUser();
              },
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('profiles').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (ctx, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];

              return GestureDetector(
                onTap: () {
                  openUpdateBottomSheet(
                      ds['name'], ds['email'], ds['date'].toDate(), ds.id);
                },
                child: Card(
                  elevation: 6,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ds['name'],
                          style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ds['email'],
                          style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Account created : ' +
                              DateFormat.yMMMd().format(ds['date'].toDate()),
                          style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void signOutUser() async {
    _controller.progressDialogue(context);
    dynamic result = await _controller.signOut();
    if (result == null) {
      Fluttertoast.showToast(
          msg: "Logout Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      Navigator.pop(context);
    }
  }

  void openUpdateBottomSheet(
      String name, String email, DateTime date, String uid) {

    final node = FocusScope.of(context);
    _nameController.text = name;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Update Details',
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.blueAccent),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        hintStyle: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 16,
                            fontWeight: FontWeight.normal)),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => node.unfocus(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                          child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: Colors.blueAccent,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: FlatButton(
                              onPressed: () {
                                updateDataOnFirestore(email, date, uid);
                              },
                              color: Colors.blueAccent,
                              child: Text(
                                'Update',
                                style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  void updateDataOnFirestore(String email, DateTime date, String uid) async {
    _controller.progressDialogue(context);
    dynamic result =
        await _controller.updateUser(uid, _nameController.text, email, date);
    if (result == null) {
      Fluttertoast.showToast(
          msg: "User Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: "User update failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}
