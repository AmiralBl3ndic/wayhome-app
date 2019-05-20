import 'package:flutter/material.dart';

import '../components/contact_manager.dart';

import '../models/contact.dart';
import 'package:geocoder/geocoder.dart';

import '../components/location_input_form.dart';


/// Holds the main view (body part of a Scaffold widget) for the settings page
class SettingsPage extends StatelessWidget {

  /// Custom callback function on address change
  final Function(Coordinates) onAddressChange;

  /// Default constructor for the SettingsPage widget
  const SettingsPage({Key key, @required this.onAddressChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Destination",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.left,
          ),

          LocationInputForm(fieldContent: "", onSubmit: onAddressChange),

          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "Contact List",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.left,
            ),
          ),


          ContactManager(
            initialContacts: List.from([
              Contact(picture: null, name: "0612345678"),
              Contact(picture: null, name: "0687654321"),
            ]),
          ),
        ],
      )
    );
  }



}
