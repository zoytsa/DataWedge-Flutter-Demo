import 'package:datawedgeflutter/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DCT',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          textTheme: TextTheme(
            headline6: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'DCT'),
      debugShowCheckedModeBanner: false,
    );
  }
}
