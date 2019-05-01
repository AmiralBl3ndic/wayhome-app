import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';


class MapPage extends StatelessWidget {
  final Position position;

  const MapPage({Key key, @required this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),

      child: Column(
        children: <Widget>[
          Center(
            child: _buildLocationIndicator(),
          ),
        ],
      ),
    );
  }


  Column _buildLocationIndicator() {
    if (position == null) {
      return Column(
        children: <Widget>[
          CircularProgressIndicator(),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Text("(latitude: ${position.latitude} ; longitude: ${position.longitude}"),
      ],
    );
  }
}
