import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.all(30.0),


      child: Column(
        children: <Widget>[

          Container(
            margin: EdgeInsets.symmetric(vertical: 40.0),
            child: Text(
              "wayHome",
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Text(
            "A bodyguard application by",
            style: TextStyle(
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: Text("•", style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
                  title: Text("Camille Briand", style: TextStyle(fontSize: 25.0)),
                ),
                ListTile(
                  leading: Text("•", style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
                  title: Text("Jérémi Friggit", style: TextStyle(fontSize: 25.0)),
                ),
                ListTile(
                  leading: Text("•", style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
                  title: Text("Stéfania Kukovski", style: TextStyle(fontSize: 25.0)),
                ),
                ListTile(
                  leading: Text("•", style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
                  title: Text("Zoé Niddam", style: TextStyle(fontSize: 25.0)),
                ),
              ],
            )
          )
        ],
      )
    );
  }
}

