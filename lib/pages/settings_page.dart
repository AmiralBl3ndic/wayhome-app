import 'package:flutter/material.dart';


/// Holds the main view (body part of a Scaffold widget) for the settings page
class SettingsPage extends StatelessWidget {
  /// Default constructor for the SettingsPage widget
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Settings")),
    );
  }
}
