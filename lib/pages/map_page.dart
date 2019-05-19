import 'package:flutter/material.dart';


class MapPage extends StatelessWidget {

  final double latitude;
  final double longitude;

  final String lastKnownAddress;

  final double lastDistance;

  final String targetAdress;

  MapPage({Key key, @required this.latitude, @required this.longitude, @required this.lastKnownAddress, @required this.lastDistance, @required this.targetAdress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30.0),

      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 35.0),
            child: Center(
              child: Text("Your trip", style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold)),
            ),
          ),


          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            child: Text("Currently going to:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(targetAdress == "" ? "No destination set" : targetAdress, style: TextStyle(fontSize: 15.0),),
          ),


          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            child: Text("Last known address:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(lastKnownAddress, style: TextStyle(fontSize: 15.0),),
          ),


          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            child: Text("Distance to objective:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text("${lastDistance.toStringAsFixed(2)} meter${lastDistance <= 1 ? '' : 's'}", style: TextStyle(fontSize: 15.0),),
          ),


          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            child: Text("Last update at:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
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
