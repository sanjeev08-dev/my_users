import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_users/screens/RegistrationScreen.dart';
import 'package:my_users/utils/Controller.dart';

import 'DashboardScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Controller _controller;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    _controller = Controller(context);
    _controller.initializeFirebaseAuth();
    _controller.initializeFirebaseFirestore();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
              fontFamily: 'Ubuntu', fontWeight: FontWeight.w700, fontSize: 24),
        ),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.amberAccent,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Colors.blueAccent,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(3.0, 3.0),
                              blurRadius: 8.0,
                              color: Color.fromARGB(125, 0, 0, 255),
                            ),
                          ]),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Ubuntu',
                              color: Colors.purple)),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.normal,
                          fontSize: 18),
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Ubuntu',
                              color: Colors.purple)),
                      obscureText: true,
                      obscuringCharacter: '*',
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.normal,
                          fontSize: 18),
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => node.unfocus(),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold),
                          primary: Colors.amberAccent),
                      onPressed: () {
                        loginUser();
                      },
                      child: const Text('Login'),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen()),
                          );
                        },
                        child: Text(
                          "Don't have an account. Registered Now ?",
                          style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ))
                  ],
                ),
                alignment: Alignment.center,
              ),
              //Image(image: AssetImage('assests/images/firebase.png'))
            ],
          )),
    );
  }

  void loginUser() async {
    _controller.progressDialogue(context);
    dynamic result = await _controller.signInUser(
        _emailController.text, _passwordController.text);
    if (result != null) {
      Fluttertoast.showToast(
          msg: "Login success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    } else {
      Navigator.pop(context);
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }
}
