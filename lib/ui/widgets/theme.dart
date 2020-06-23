import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

AppTheme customDark() {
  return AppTheme(
    id: "dark",
    description: "Custom Color Dark",
    data: ThemeData(
        textTheme: TextTheme().apply(
          bodyColor: Colors.white70,
          displayColor: Colors.white,
        ),
        brightness: Brightness.dark,
        canvasColor: Color.fromRGBO(37, 52, 65, 1),
        accentColor: Color.fromRGBO(37, 52, 65, 1),
        primaryColor: Color.fromRGBO(37, 52, 65, 1),
        scaffoldBackgroundColor: Color.fromRGBO(37, 52, 65, 1),
        buttonColor: Colors.amber,
        dialogBackgroundColor: Colors.yellow,
        bottomAppBarColor: Color.fromRGBO(37, 52, 65, 1),
        textSelectionColor: Colors.white,
        unselectedWidgetColor: Colors.grey),
  );
}

AppTheme customLight() {
  return AppTheme(
    id: "light",
    description: "Custom Color for Light",
    data: ThemeData(
        brightness: Brightness.light,
        canvasColor: Color.fromRGBO(241, 243, 246, 1),
        textTheme: TextTheme().apply(
          bodyColor: Colors.black54,
          displayColor: Colors.grey,
        ),
        primaryColor: Colors.grey[50],
        scaffoldBackgroundColor: Colors.grey[50],
        backgroundColor: Colors.grey[100],
        bottomAppBarColor: Color.fromRGBO(37, 52, 65, 1),
        unselectedWidgetColor: Colors.grey),
  );
}