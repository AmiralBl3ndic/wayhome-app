import 'package:flutter/material.dart';



class MapPage extends StatelessWidget {

  const MapPage({Key key}) : super(key: key);

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
        CircularProgressIndicator(),
      ],
    );
  }
}
