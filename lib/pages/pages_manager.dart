import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:location/location.dart';

import './home_page.dart';
import './settings_page.dart';
import './map_page.dart';


class PagesManager extends StatefulWidget {
  final String title;

  PagesManager({Key key, @required this.title}) : super(key: key);

  _PagesManagerState createState() => _PagesManagerState();
}

class _PagesManagerState extends State<PagesManager> {

  Location _locationProvider = Location();
  LocationData _lastLocation;
  String _targetAddress = "";

  // Page navigation properties
  int _currentPageIndex = 1;  // Home page by default
  List<String> _pagesTitles = ["wayHome - Settings", "wayHome", "wayHome - Map"];
  List<Widget> _pages;


  @override
  void initState() {
    super.initState();

    _pages = [
      SettingsPage(onAddressChange: _onAddressChange,),
      HomePage(),
      MapPage(),
    ];

    _checkAndAskLocationPermissions();
    _checkLocationServiceEnabled();

    _locationProvider.onLocationChanged().listen((LocationData currentLocation) {
      print("Latitude: ${currentLocation.latitude}");
      print("Longitude: ${currentLocation.longitude}");
    });
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


  /// Update the targetted address if it exists
  void _onAddressChange(String newAddress) {
    if (newAddress.isNotEmpty) {
      // TODO: perform verification of validity for address
      setState(() {
        _targetAddress = newAddress;
      });
    }
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


  /// Check the location permissions and resquests them if not already granted
  void _checkAndAskLocationPermissions() async {
    bool hasPermission = await _locationProvider.hasPermission();

    while (!hasPermission) {
      hasPermission = await _locationProvider.requestPermission();
    }
  }


  /// Check the location service and request the user to turn it on if needed
  void _checkLocationServiceEnabled() async {
    bool isEnabled = await _locationProvider.serviceEnabled();

    while (Platform.isAndroid && !isEnabled) {
      isEnabled = await _locationProvider.requestService();
    }
  }
}
