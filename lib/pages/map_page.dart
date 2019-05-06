import 'package:flutter/material.dart';


class MapPage extends StatelessWidget {

  final double latitude;
  final double longitude;

  MapPage({Key key, @required this.latitude, @required this.longitude}) : super(key: key);

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
    return Column(
      children: <Widget>[
        (latitude == null || longitude == null) ? CircularProgressIndicator() : Text("Latitude: $latitude, Longitude: $longitude"),
      ],
    );
  }
}
