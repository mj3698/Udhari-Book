import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:udharibook/Screens/dashboard.dart';
import 'package:udharibook/services/authservice.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return homePageState();
  }
}

class homePageState extends State<SplashScreen> {
  void initState() {
    super.initState();
    startTimer();
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      //For Transparent Status Bar
//      statusBarColor: Colors.transparent,
//    ));
  }
  @override

  startTimer() {
    var duration = Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => DashboardPage(userName: "Mehul",
          imgUrl: 'https://thispersondoesnotexist.com/image',)));
        //MaterialPageRoute(builder: (context) => AuthService().handleAuth()));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Center(
            child: Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 18)),
        Container(
          child: Image.asset('images/logo.jpg',
              height: SizeConfig.blockSizeVertical * 40,
              width: SizeConfig.blockSizeHorizontal * 90),
        ),
        Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10)),
        Text(
          'Welcome to Udhari Book',
          style: TextStyle(
              fontSize: 25.0, color: Color(0xFFA22A2B),),
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
          backgroundColor: Colors.white,
          strokeWidth: 5.0,
        )
      ],
    )));
  }
}
