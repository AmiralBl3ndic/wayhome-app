import 'package:flutter/material.dart';

import '../components/location_input_form.dart';


/// Holds the main view (body part of a Scaffold widget) for the settings page
class SettingsPage extends StatelessWidget {

  /// Custom callback function on address change
  final Function onAddressChange;

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

          LocationInputForm(fieldContent: "8 rue Jean Macé, 75011 Paris", onSubmit: (String address) {
            print("Address: $address");
          }),


        ],
      )
    );
  }



}
