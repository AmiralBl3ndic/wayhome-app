import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import './home_page.dart';
import './settings_page.dart';
import './map_page.dart';

import '../utils/address.dart';


class PagesManager extends StatefulWidget {
  final String title;

  PagesManager({Key key, @required this.title}) : super(key: key);

  _PagesManagerState createState() => _PagesManagerState();
}

class _PagesManagerState extends State<PagesManager> {

  // Geolocalization properties
  Position _position;
  LocationOptions _locOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  Geolocator _locator = Geolocator();

  // Page navigation properties
  int _currentPageIndex = 1;  // Home page by default
  List<String> _pagesTitles = ["wayHome - Settings", "wayHome", "wayHome - Map"];
  List<Widget> _pages = [
    SettingsPage(),
    HomePage(),
    MapPage(position: null,),
  ];


  @override
  void initState() {
    super.initState();

    _position = null;  // Safety first

    _locator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then(_updatePosition);

    _locator.getPositionStream(_locOptions).listen(_updatePosition);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text(_pagesTitles[_currentPageIndex]),
         ),

          body: _pages[_currentPageIndex],

          bottomNavigationBar: _buildNavigationBar(),
       ),
    );
  }



  /// Builds the BottomNavigationBar widget (into a function for better code readability)
  BottomNavigationBar _buildNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Platform.isAndroid ? Icon(Icons.settings) : Icon(CupertinoIcons.settings), title: Text(_pagesTitles[0])),  // Settings page
        BottomNavigationBarItem(icon: Platform.isAndroid ? Icon(Icons.home) : Icon(CupertinoIcons.home), title: Text(_pagesTitles[1])),  // Home page (default)
        BottomNavigationBarItem(icon: Platform.isAndroid ? Icon(Icons.map) : Icon(CupertinoIcons.location), title: Text(_pagesTitles[2]))  // Map page
      ],

      currentIndex: _currentPageIndex,

      onTap: (int tappedIndex) {  // When an element of the navbar is tapped, update the state of the page manager to change the view 
        setState(() {
          _currentPageIndex = tappedIndex;
        });
      },
    );
  }


  /// Updates the last known position
  void _updatePosition(Position p) {
    // Actually updates the position
    setState(() {
      _position = p;
      _pages[2] = MapPage(position: _position,);

      debugPrint("Location updated");
    });

    // Debug print the address of the current position
    _locator.placemarkFromCoordinates(p.latitude, p.longitude, localeIdentifier: "fr_FR").then((List<Placemark> placemarks) {
      setState(() {
        Placemark pm = placemarks[0];

        debugPrint("Address: ${formatAddress(pm)}");
      });
    });
  }
}
