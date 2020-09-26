import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:udharibook/Screens/CustomerDetails.dart';
import 'package:udharibook/Screens/UserProfile.dart';
import 'package:udharibook/services/authservice.dart';
import 'Customer_Support.dart';

class DashboardPage extends StatefulWidget {
  final String userName;
  String imgUrl =
      'https://firebasestorage.googleapis.com/v0/b/udhari-book.appspot.com/o/DefaultImage.png?alt=media&token=06bddd3e-7f11-476b-a982-dfb21096f9c7';

  DashboardPage({Key key, this.userName, this.imgUrl}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
//    FirebaseAuth _auth = FirebaseAuth.instance;
//    DatabaseReference DBRef = FirebaseDatabase.instance.reference().child('Users');
//    _auth.currentUser().then((curUser){
//      DBRef.child(curUser.uid).once().then((DataSnapshot user){
    //userName = user.value['Name'];
    setState(() {
      print('The name of Username is:' + widget.imgUrl);
    });
    //  });
    //});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.userName,
            style: TextStyle(fontFamily: 'Exo2'),
          ),
          backgroundColor: Color(0xFFA22A2B),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  print("Search Clicked");
                }),
            IconButton(
                icon: Icon(Icons.sort),
                onPressed: () {
                  print("Sort Clicked");
                }),
          ],
        ),


        //Drawer Header i.e. Upper part with Image and Name
        drawer: SafeArea(
          child: Drawer(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(13.0),
                  height: 180.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('images/Drawer.png'),
                    fit: BoxFit.cover,
                  )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 60.0,
                          child: ClipOval(
                            child: SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: Image.network(
                                  widget.imgUrl,
                                  fit: BoxFit.cover,
                                )),
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 3.0),
                      ),
                      Center(
                        child: Text(
                          widget.userName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontFamily: 'Exo2'),
                        ),
                      )
                    ],
                  ),
                ),
                CustomMenu(
                    Icons.person,
                    'Profile',
                    () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                        isCancelBtnVisible: true,
                                      )))
                        }),
                CustomMenu(Icons.assessment, 'Reports', () => {}),
                CustomMenu(Icons.settings, 'Settings', () => {}),
                CustomMenu(
                    Icons.perm_phone_msg,
                    'Customer Support',
                    () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => CustSupport()))
                        }),
                CustomMenu(
                    Icons.lock, 'Log Out', () => {AuthService().signOut()}),
              ],
            ),
          ),
        ),


        floatingActionButton:
            FloatingActionButton.extended(
              icon: Icon(Icons.person_add),
                label: Text('New User',
                  style: TextStyle(fontFamily: 'Exo2',
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0)),
                backgroundColor: Color.fromRGBO(162, 42, 43, 1),
                foregroundColor: Color.fromRGBO(230, 220, 199, 1),
                elevation: 10.0,
                splashColor: Colors.redAccent,
                onPressed: () {
                  Navigator.push(
                  context,
                  new MaterialPageRoute(
                  builder: (context) => custDetails()));
            }));

  }
}

class CustomMenu extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomMenu(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        child: Container(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey.shade400))),
            child: InkWell(
                splashColor: Colors.redAccent,
                onTap: onTap,
                child: Container(
                  height: 60.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(icon),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                text,
                                style: TextStyle(
                                    fontSize: 17.0, fontFamily: 'Exo2'),
                              )),
                        ],
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ))));
  }
}
