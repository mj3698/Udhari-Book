import 'package:flutter/material.dart';
import 'package:udharibook/Screens/SplashScreen.dart';
void main(){
  runApp(
      MaterialApp(
        title: 'Udhari Book',
        home:SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            backgroundColor: Color.fromRGBO(242, 242, 242, 1.0)
        ),
      )
  );
}

