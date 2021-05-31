import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyUser {
  String name;
  String email;
  DateTime date;

  MyUser({@required this.name, @required this.email, @required this.date});

  MyUser.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'date': date,
  };
}
