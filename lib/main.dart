import 'package:flutter/material.dart';
import 'package:tomato_movie/screens/detail_screen.dart';
import 'package:tomato_movie/screens/favourite_screen.dart';
import 'package:tomato_movie/screens/main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env"); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/detail': (context) => DetailScreen(),
        '/favourite': (context) => FavouriteScreen(),
      },
    );
  }
}

