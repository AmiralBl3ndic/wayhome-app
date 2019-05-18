import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

import './contact_list.dart';
import './contact_form.dart';

import '../models/contact.dart';

class ContactManager extends StatefulWidget {
  final List<Contact> initialContacts;

  ContactManager({Key key, this.initialContacts}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContactManagerState(); 
}

class _ContactManagerState extends State<ContactManager> {

  /// List of contacts
  List<Contact> _contactList;

  @override
  void initState() {
    super.initState();

    if (widget.initialContacts != null && widget.initialContacts.isNotEmpty) {
      _contactList = List.from(widget.initialContacts);
    } else {
      _contactList = List();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          ContactForm(onSubmit: _addContact,),

          ContactList(contacts: _contactList, deletionHandler: _confirmDelete),
          RaisedButton(child: Text("SMS"),
          onPressed: (){
            this._sendSMS("Je suis arrivé !", this._contactList);
          },)
        ],
      )
    );
  }


   /// Delete a contact from the local contact list and updates the widget
  void _deleteContact(int contactId) {
    setState(() {
      int sizeBefore = _contactList.length;
      _contactList = List.from(_contactList)..removeWhere((Contact c) => c.id == contactId);

      if (_contactList.length == sizeBefore - 1) {
        debugPrint("Deleted contact with id #$contactId");
      } else {
        debugPrint("[ERROR] Could not find contact with id #$contactId");
      }

    });
  }


  void _thanosSnap() {
    setState(() {
      Random rd = Random.secure();
      _contactList = List.from(_contactList)..removeWhere((Contact c) => rd.nextBool());

      debugPrint("Thanos snapped");
    });
  }

  /// Add a contact to the local contact list and updates the widget
  void _addContact(Contact contact) {
    setState(() {
      int sizeBefore = _contactList.length;
      _contactList.insert(0, contact);

      if(_contactList.length == sizeBefore + 1) {
        debugPrint("Added contact with id #${contact.id}");
      } else {
        debugPrint("[ERROR] Could not add contact");
      }
    });  
  }

  ///Print a confirmation message dialog 
  Future<void> _confirmDelete(int contactId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm decision'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this contact ?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();

                _deleteContact(contactId);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _sendSMS(String message, List<Contact> contacts) async {
    List<String> recipients = new List<String>();

    for (Contact c in contacts) {
      recipients.add(c.name);
    }

  String _result = await FlutterSms
          .sendSMS(message: message, recipients: recipients)
          .catchError((onError) {
        print(onError);
      });
    //print(_result);
  }

}

