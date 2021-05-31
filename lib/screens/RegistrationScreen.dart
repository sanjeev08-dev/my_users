import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_users/utils/Controller.dart';

class RegistrationScreen extends StatefulWidget {

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _nameController = TextEditingController();
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
          'Registration',
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
                      'Sign Up',
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
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Ubuntu',
                              color: Colors.purple)),
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.normal,
                          fontSize: 18),
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
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
                      onPressed: () {createUser(_nameController.text,_emailController.text,_passwordController.text);},
                      child: const Text('Sign Up'),
                    ),
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text(
                      "Already have an account. Login ?",
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

  void createUser(String name, String email, String password) async{
    _controller.progressDialogue(context);
    dynamic authResult = await _controller.createUser(email, password,name);
    if(authResult == null){
      Navigator.pop(context);
    }else{
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();

      Fluttertoast.showToast(
          msg: "Auth Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );

      await _controller.saveUserData(name, email, password);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}
