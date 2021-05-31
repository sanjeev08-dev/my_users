import 'package:flutter/material.dart';
import 'package:my_users/utils/Controller.dart';

class SplashScreen extends StatelessWidget {
  Controller _controller;

  @override
  Widget build(BuildContext context) {
    _controller = Controller(context);
    return Scaffold(
      body: Container(
        color: Colors.blue,
        alignment: Alignment.center,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: _controller.getScreenSize().width * 0.50,
                  height: _controller.getScreenSize().width * 0.50,
                  margin: EdgeInsets.only(top: 200),
                  child: Image.asset(
                    'assests/images/firebase.png',
                  ),
                ),
                Container(
                  child: Text(
                    'My Users',
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                    color: Colors.yellowAccent),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
