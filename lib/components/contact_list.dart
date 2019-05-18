import 'dart:core';

import 'package:flutter/material.dart';

import './contact_item.dart';

import '../models/contact.dart';



class ContactList extends StatelessWidget {
  final List<Contact> contacts;
  final Function deletionHandler;

  ContactList({Key key, @required this.contacts, @required this.deletionHandler});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int elemId) {
          return ContactItem(
            contact: contacts[elemId],
            onDelete: deletionHandler,
          );
        },
      ),
    );
  }
}

