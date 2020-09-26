import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:udharibook/Screens/SignInPage.dart';
import 'package:udharibook/Screens/SplashScreen.dart';
import 'package:udharibook/Screens/UserProfile.dart';
import 'package:udharibook/Screens/dashboard.dart';


class AuthService {
  String _userName;
  var _imgUrl;
  bool flag = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DBRef = FirebaseDatabase.instance.reference().child('Users');

  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder<bool>(
              future: readData(),
              builder:
                  (BuildContext context, AsyncSnapshot<bool> readDataSnapshot) {
                //readDataSnapshot.data will be your true/false from readData()
                if (readDataSnapshot.hasData) {
                  if (readDataSnapshot.data == true)
                    //return Navigator.push(context, MaterialPageRoute(builder:(context)=> DashboardPage(data:-_userName)),);
                  return DashboardPage(userName:_userName, imgUrl: _imgUrl,);
                  else
                    return UserProfile(isCancelBtnVisible: false,);
                } else {
                  return SplashScreen(); // or something else while waiting for the future to complete.
                }
              });
        } else {
          return SignIn();
        }
      },
    );
  }

  Future<bool> readData() async {
    bool flag = false;
    final FirebaseUser user = await _auth.currentUser();
    await DBRef.child(user.uid).once().then((DataSnapshot data) {
      if (data.value != null) {
        flag = true;
        _userName = data.value['Name'];
        _imgUrl = data.value['ProfileImage'];
        //print('The User Name is: '+_userName);
      } else {
        print('User not found');
        flag = false;
      }
    });
    return flag;
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }
}

