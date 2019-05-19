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
import '../components/contact_manager.dart';


class PagesManager extends StatefulWidget {
  final String title;

  PagesManager({Key key, @required this.title}) : super(key: key);

  _PagesManagerState createState() => _PagesManagerState();
}

class _PagesManagerState extends State<PagesManager> with WidgetsBindingObserver {

  /// Minimum distance the user has to move before a position update is triggered by the `_positionStream`
  static int _motionTriggerTreshold = 2;  // Minimum 20 meters motion to trigger event
  /// Options for the stream that updates the user's geolocation (`_positionStream`)
  final LocationOptions _locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: _motionTriggerTreshold);
  /// Stream that update the user's geolocation
  StreamSubscription<Position> _positionStream;
  /// Last known position (shorthand to avoid too much asynchronous programming)
  Position _lastPosition;
  /// Last known distance to target (shorthand to avoid too much asynchronous programming)
  double _lastDistance;

  // Wrong direction properties
  /// Counts the number of times in a row that the user went the wrong direction
  int _wrongDirectionCounter = -1;
  /// Number of times a user has to go the wrong direction before sending a notification
  static int _wrongDirectionAlertMod = 6;
  
  // Target properties
  /// Coordinates of the target
  Coordinates _targetCoordinates;
  /// Radius around the target (in meters) that can be considered as the target
  int _geofenceRadius = 20;
  /// Initial distance to the target
  double _initialDistance;

  // Motion checker properties
  /// Timer to check if user moved during the set lapse of time
  Timer _motionChecker;
  /// Time before considering the user did not move and we should do something
  Duration _userDidNotMoveThreshold = Duration(minutes: 5);

  // Page navigation properties
  /// Index of the currently displayed page
  int _currentPageIndex = 1;  // Home page by default
  /// Title for the pages to display
  List<String> _pagesTitles = ["Settings", "wayHome", "Trip"];
  /// List of pages (widgets) to be displayed
  List<Widget> _pages;


  // Settings go here



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

      // Suscribe to geolocation updates
      _positionStream = Geolocator().getPositionStream(_locationOptions).listen(_updatePosition);
    });



    _motionChecker = Timer.periodic(Duration(seconds: 20), (Timer timer) {
      debugPrint("[Timer] Did a loop");
      if (_lastPosition.timestamp.add(_userDidNotMoveThreshold).isBefore(DateTime.now())) {
        if (_isAtTarget()) {
          //TODO-Camille: Vérifier si la contactList est vide ou non, et appeler l'un ou l'autre des MessageDialog en fonction
          _targetReachedDialog();
          _targetReachedDialogSMS();
        } else {
          // TODO: ask the user if everything's okay
          // ? TODO: check number of times user has been asked
          // TODO: determine threshold for number of times
          // TODO: send SMS with geolocation (and address)

          debugPrint("[ALERT] User hasn't moved for a while...");
        }
      }
    }); 
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    
    _positionStream.cancel();  // Do not keep track of position when widget is destroyed
    _motionChecker.cancel();  // Do not keep track of time since user moved for the last time

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


  /// Update the position of the user
  /// 
  /// This method also checks if the new position is closer to the target than the position just before so that we know the user is going in the right direction
  void _updatePosition(Position position) {
    Geolocator().distanceBetween(position.latitude, position.longitude, _targetCoordinates.latitude, _targetCoordinates.longitude)
      .then((double newDistance) {
        // We check if the user is going in the right direction
        if (newDistance > _lastDistance - 5) {  // TODO: determine an error margin (to avoid sending notifications straight away if user changes direction a bit)
          _wrongDirectionCounter++;  // Increment the wrong direction counter

          // If we reached a treshold of wrong direction (`_wrongDirectionAlertMod` times in a row), then send an alert
          if (_wrongDirectionCounter % _wrongDirectionAlertMod == 0) {
            _wrongDirectionDialog();
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


  /// Check if user is at the set target
  /// 
  /// This method uses the `_geofenceRadius` to check whether or not the user is within the given radius of his target
  bool _isAtTarget() {
    return _lastDistance <= _geofenceRadius;
  }


  /// Builds the BottomNavigationBar widget (into a function for better code readability)
  BottomNavigationBar _buildNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Platform.isAndroid ? Icon(Icons.settings) : Icon(CupertinoIcons.settings), title: Text(_pagesTitles[0])),  // Settings page
        BottomNavigationBarItem(icon: Platform.isAndroid ? Icon(Icons.home) : Icon(CupertinoIcons.home), title: Text(_pagesTitles[1])),  // Home page (default)
        BottomNavigationBarItem(icon: Platform.isAndroid ? Icon(Icons.location_on) : Icon(CupertinoIcons.location), title: Text(_pagesTitles[2]))  // Map page
      ],

      currentIndex: _currentPageIndex,

      onTap: (int tappedIndex) {  // When an element of the navbar is tapped, update the state of the page manager to change the view 
        setState(() {
          _currentPageIndex = tappedIndex;
        });
      },
    );
  }

  ///Print an alert message dialog when user is located next is home
  Future<void> _targetReachedDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have been located in the area of your home.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ///Print an alert message dialog when user is located next is home and send an SMS to its contact list
  Future<void> _targetReachedDialogSMS() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have been located in the area of your home.'),
                Text('Do you want to send an SMS to your contact list ?'),
              ],
            ),
          ),
         actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                //TODO-Camille: Appeler ici fonction qui envoie un SMS (dans contact_manager.dart)
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

   ///Print an alert message when the user is going the wrong way
  Future<void> _wrongDirectionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You are going in the WRONG direction.'),
                Text('Are you sure you want to continue this way ?'),
                Text('(Warning: it will close the app if you push YES)'),
              ],
            ),
          ),
         actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
