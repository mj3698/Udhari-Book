import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:udharibook/services/authservice.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

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

class _SignInState extends State<SignIn> {
  final _formKey = new GlobalKey<FormState>();
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  bool _phoneTextFieldEnabled = true;

  //For Info about FocusNode visit https://flutter.dev/docs/cookbook/forms/focus
  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        codeSent
            ? AuthService().signInWithOTP(smsCode, verificationId)
            : verifyPhone(phoneNo);
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "No Internet Connection!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 65.0,
                        fontFamily: 'KaushanScript',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA22A2B),),
                  ),
                ),

                //Mobile Number TextField
                Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 5,
                      left: SizeConfig.blockSizeVertical * 3,
                      right: SizeConfig.blockSizeVertical * 3,
                    ),
                    child: Stack(
                        alignment: Alignment.centerRight,
                        children: <Widget>[


                          TextFormField(
                            keyboardType: TextInputType.phone,
                            enabled: _phoneTextFieldEnabled,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.local_phone,
                                  color: Color(0xFFA22A2B),
                                ),
                                labelText: 'Mobile Number',
                                labelStyle: TextStyle(
                                    fontFamily: 'Exo2',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                                //hintText: 'Enter phone number',
                                // hintStyle: TextStyle(fontFamily: 'Exo2'),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color(0xFFA22A2B),))),
                            validator: (var mobile) {
                              if (mobile.isEmpty)
                                return 'Please enter Number';
                              else if (mobile.length != 10)
                                return 'Please enter correct Number';
                            },
                            onChanged: (val) {
                              setState(() {
                                this.phoneNo = "+91" + val;
                              });
                            },
                          ),
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed:(){
                                _phoneTextFieldEnabled = true;
                                codeSent = false;
                                setState(() {

                                });
                              }
                          )
                        ])
                ),

                //OTP TextField
                codeSent
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 3,
                          left: SizeConfig.blockSizeVertical * 3,
                          right: SizeConfig.blockSizeVertical * 3,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          focusNode: myFocusNode,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: Color(0xFFA22A2B),
                              ),
                              labelText: 'One Time Password',
                              labelStyle: TextStyle(
                                  fontFamily: 'Exo2',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color(0xFFA22A2B),))),
                          onChanged: (val) {
                            setState(() {
                              this.smsCode = val;
                            });
                          },
                        ))
                    : Container(),
                Padding(
                    padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 3,
                  left: SizeConfig.blockSizeVertical * 15,
                  right: SizeConfig.blockSizeVertical * 15,
                  bottom: SizeConfig.blockSizeVertical * 1,
                )),

                Row(
                    mainAxisAlignment: codeSent
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          width: codeSent ? 130.0 : 180.0,
                          height: 40.0,
                          child: RaisedButton(
                            color: Color(0xFFA22A2B),
                            child: Center(
                                child: Text(
                              codeSent ? 'VERIFY' : 'LOGIN',
                              style: TextStyle(
                                  fontFamily: 'Exo2',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 23.0,
                                  color: Colors.white),
                            )),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                checkConnection();
                                _phoneTextFieldEnabled = false;
                                myFocusNode.requestFocus();
                                setState(() {});
                              }
                            },
                          )),
                      Visibility(
                          visible: codeSent,
                          child: ArgonTimerButton(
                            initialTimer: 30,
                            // Optional
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.45,
                            minWidth: MediaQuery.of(context).size.width * 0.40,
                            color: Color(0xFFA22A2B),
                            borderRadius: 20.0,
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontFamily: 'Exo2'),
                            ),
                            loader: (timeLeft) {
                              return Text(
                                "Wait | $timeLeft",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontFamily: 'Exo2'),
                              );
                            },
                            onTap: (startTimer, btnState) {
                              if (btnState == ButtonState.Idle) {
                                verifyPhone(phoneNo);
                              }
                            },
                          )),
                    ])
              ])),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verfied = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verfied,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
