import 'package:flutter/material.dart';
import 'package:tomato_movie/screens/home_screen.dart';
import 'package:tomato_movie/screens/search_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _screenOptions = [
    HomeScreen(),
    SearchScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tomato Movie')),
      body: Container(
        child: _screenOptions[_selectedIndex]
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search'
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
