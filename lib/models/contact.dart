import 'package:flutter/material.dart';

class Contact {


  final String name;

  final Image picture;

  int id;

  static int _contactCount = 0;

  Contact({this.name, this.picture}) {
    id = ++_contactCount;
  }


}