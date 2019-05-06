import 'dart:io' show Platform;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

import './home_page.dart';
import './settings_page.dart';
import './map_page.dart';


class PagesManager extends StatefulWidget {
  final String title;

  PagesManager({Key key, @required this.title}) : super(key: key);

  _PagesManagerState createState() => _PagesManagerState();
}

class _PagesManagerState extends State<PagesManager> with WidgetsBindingObserver {

  static int _motionTriggerTreshold = 30;  // Minimum 30 meters motion to trigger event

  final LocationOptions _locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: _motionTriggerTreshold);
  StreamSubscription<Position> _positionStream;
  Position _lastPosition;
  double _lastDistance;

  double _initialDistance;

  int _wrongDirectionCounter = -1;
  static int _wrongDirectionAlertMod = 6;

  
  Coordinates _targetCoordinates;

  // Page navigation properties
  int _currentPageIndex = 1;  // Home page by default
  List<String> _pagesTitles = ["wayHome - Settings", "wayHome", "wayHome - Map"];
  List<Widget> _pages;


  @override
  void initState() {
    super.initState();

    // Force device to use application in Portrait orientation only
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    WidgetsBinding.instance.addObserver(this);

    _pages = [
      SettingsPage(onAddressChange: _onTargetChange,),
      HomePage(),
      MapPage(latitude: null, longitude: null,),
    ];


    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position p) {
      _targetCoordinates = Coordinates(p.latitude, p.longitude);
      _lastDistance = 0;
      _updatePosition(p);
    });

    // Suscribe to geolocation updates
    _positionStream = Geolocator().getPositionStream(_locationOptions).listen(_updatePosition);


    // TODO: add a setTimeout function to periodically check if user is still moving
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _positionStream.cancel();
    super.dispose();
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



  void _updatePosition(Position position) {
    Geolocator().distanceBetween(position.latitude, position.longitude, _targetCoordinates.latitude, _targetCoordinates.longitude)
      .then((double newDistance) {
        // We check if the user is 
        if (newDistance > _lastDistance) {  // TODO: determine an error margin (to avoid sending notifications straight away if user changes direction a bit)
          _wrongDirectionCounter++;  // Increment the wrong direction counter

          // If we reached a treshold of wrong direction (`_wrongDirectionAlertMod` times in a row), then send an alert
          if (_wrongDirectionCounter % _wrongDirectionAlertMod == 0) {
            // TODO: send push notification
            debugPrint("Wrong direction $_wrongDirectionCounter time${_wrongDirectionCounter <= 1 ? "" : "s"} in a row");
          }
        } else {
          _wrongDirectionCounter = -1;  // Reinit the counter
        }
      });

    // Update the last known position
    setState(() {  // TODO: check if setState is really needed here (avoid rebuilding entire pages when not necessary)
      _lastPosition = position;
      debugPrint("Updated position: (lat=${position.latitude}, long=${position.longitude})");

      _pages[2] = MapPage(latitude: position.latitude, longitude: position.longitude,);  // Maybe not necessary
    });
  }


  /// Update the targetted address if it exists
  void _onTargetChange(Coordinates newTarget) {
    // Compute distance to target before setting the new target
    Geolocator().distanceBetween(_lastPosition.latitude, _lastPosition.longitude, newTarget.latitude, newTarget.longitude)
      .then((double distance) {
        setState(() {
          _initialDistance = distance;
          _lastDistance = distance;
          _targetCoordinates = newTarget;
        });

        debugPrint("Updated target location : (lat=${newTarget.latitude}, long=${newTarget.longitude}, distance=$distance)");
      });
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
}
