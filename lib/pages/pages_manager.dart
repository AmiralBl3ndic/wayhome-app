import 'package:flutter/material.dart';

import './home_page.dart';
import './settings_page.dart';


class PagesManager extends StatefulWidget {
  final String title;

  PagesManager({Key key, @required this.title}) : super(key: key);

  _PagesManagerState createState() => _PagesManagerState();
}

class _PagesManagerState extends State<PagesManager> {

  int _currentPageIndex = 1;  // Home page by default
  List<String> _pagesTitles = ["wayHome - Settings", "wayHome", "wayHome - Map"];

  List<Widget> _pages = [
    SettingsPage(),
    HomePage(),
    Container(child: Text("Map page"))
  ];

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
        BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text(_pagesTitles[0])),  // Settings page
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(_pagesTitles[1])),  // Home page (default)
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text(_pagesTitles[2]))  // Map page
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
