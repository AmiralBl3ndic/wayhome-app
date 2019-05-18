import 'package:flutter/material.dart';

import '../models/contact.dart';

class ContactItem extends StatelessWidget {

  /// Contact data to display
  final Contact contact;

  /// Action to perform when the tile detects a long press
  final Function onDelete;

  ContactItem({Key key, Widget leading, @required this.contact, String subtitle, @required this.onDelete});

  @override
  Widget build(BuildContext context) {
    

    return Card(
      child: ListTile(
        leading: contact.picture,
        title: Text(contact.name),
        onLongPress: () {
          onDelete(contact.id);
        }),
    );
  }
}
