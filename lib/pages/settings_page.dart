import 'package:flutter/material.dart';

import '../components/contact_manager.dart';

import '../models/contact.dart';

/// Holds the main view (body part of a Scaffold widget) for the settings page
class SettingsPage extends StatelessWidget {
  /// Default constructor for the SettingsPage widget
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ContactManager(
          initialContacts: List.from([
            Contact(picture: null, name: "0662632169"),
            Contact(picture: null, name: "0660845814"),
          ]),
        ),
      ],
    );
  }
}
