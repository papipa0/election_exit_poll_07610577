import 'package:election_exit_poll_07610577/page/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:election_exit_poll_07610577/page/calculate_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: GoogleFonts.prompt().fontFamily,
    primarySwatch: Colors.teal,
    textTheme: TextTheme(

      headline2: TextStyle(
        fontSize: 28.0,
        //fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        fontSize: 16.0,
        //fontWeight: FontWeight.bold,
      ),


      ),
      ),
      routes: {
        HomePage.routeName:(context) => const HomePage(),
        calculatepage.routeName : (context) => calculatepage(),
      },
      initialRoute: HomePage.routeName,
    );
  }
}