import 'package:flutter/material.dart';
import './home.dart';
import './aboutUs.dart';
import './search.dart';
 
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course App',
      theme: ThemeData.dark(),
      home: MyNavigation(),
    );
  }
}

class MyNavigation extends StatefulWidget {
  @override
  _MyNavigationState createState() => _MyNavigationState();
}

class _MyNavigationState extends State<MyNavigation> {

  int _currentIndex = 0;
  final List<Widget> _childern =
  [
    Home(),
    Search(),
    AboutUs(),
    

  ];
  void onTapped(int index)
  {
    setState(() {
      _currentIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : _childern[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: _currentIndex,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('AboutUs'),
          ),

        ] ,),
    );
  }
}