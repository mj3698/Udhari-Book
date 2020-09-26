import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udharibook/Screens/dashboard.dart';

class UserProfile extends StatefulWidget {
  bool isCancelBtnVisible; //flag for cancel  button
  UserProfile({Key key,this.isCancelBtnVisible}) : super(key : key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  var profileImage =
      'https://firebasestorage.googleapis.com/v0/b/udhari-book.appspot.com/o/DefaultImage.png?alt=media&token=06bddd3e-7f11-476b-a982-dfb21096f9c7';
  File _image;
  String fileName;
  static var userId;

  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference DBRef =
      FirebaseDatabase.instance.reference().child('Users');

  void initState() {
    super.initState();
    _auth.currentUser().then((curUser) {
      phoneController = TextEditingController(text: curUser.phoneNumber);
      userId = curUser.uid;
      DBRef.child(curUser.uid).once().then((DataSnapshot user) {
        if (user != null) {
          profileImage = user.value['ProfileImage'];
          nameController = TextEditingController(text: user.value['Name']);
          emailController = TextEditingController(text: user.value['Email']);
          addressController =
              TextEditingController(text: user.value['Address']);
          setState(() {

          });
        }
      });
      setState(() {
        //Provide the initial value of the user in the text field
        print('Current user id:' + userId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      _image = image;
      fileName = phoneController.text;
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('Images/$fileName');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot imgSnapshot = await uploadTask.onComplete;
      if (imgSnapshot.error == null) {
        profileImage = await imgSnapshot.ref.getDownloadURL();
      }
      setState(() {
        print('Image uploaded successfully');
      });
    }

    Future uploadPic(BuildContext context) async {
      print('The user name is: ' + nameController.text);
      DBRef.child(userId).set({
        'User Id': userId,
        'Name': nameController.text,
        'Mobile': fileName,
        'Email': emailController.text,
        'Address':
            addressController.text != null ? addressController.text : null,
        'ProfileImage': profileImage,
      });
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => DashboardPage(
                userName: nameController.text,
                imgUrl: profileImage,
              )));

    }

    _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Color(0xFFA22A2B),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Profile Image widget
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: SizedBox(
                            height: 120.0,
                            width: 120.0,
                            child: _image != null
                                ? Image.file(_image, fit: BoxFit.fill)
                                : Image.network(
                                    profileImage,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    //Camera Icon Widget
                    Padding(
                      padding: EdgeInsets.only(),
                      child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () {
                            getImage();
                          }),
                    )
                  ],
                ),

                //Name TextField
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                  child: TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    focusNode: _nameFocus,
                    onFieldSubmitted: (term){
                      _fieldFocusChange(context, _nameFocus, _emailFocus);
                    },
                    validator: (input) {
                      if (input.isEmpty) return 'Please enter Name';
                    },
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        labelText: 'Full Name',
                        labelStyle:
                            TextStyle(fontFamily: 'Exo2', color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                color: Color(0xFFA22A2B),))),
                  ),
                ),

                //Mobile Text Field
                Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child: SizedBox(
                      height: 40.0,
                      child: TextField(
                        controller: phoneController,
                        enabled: false,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                            labelText: 'Mobile Number',
                            labelStyle: TextStyle(
                                fontFamily: 'Exo2', color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Color(0xFFA22A2B),))),
                      ),
                    )),

                //Email Text Field
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    validator: (input) {
                      if (input.isNotEmpty && input.contains('@') == false)
                        return 'Please enter correct Email Id';
                      else if (input.isEmpty) return 'Please enter Email Id';
                    },
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _emailFocus,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _emailFocus, _addressFocus);
                    },
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        labelText: 'Email Id',
                        labelStyle:
                            TextStyle(fontFamily: 'Exo2', color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                color: Color(0xFFA22A2B),))),
                  ),
                ),


                //Address Text Field
                Padding(
                  padding: EdgeInsets.only(
                      top: 15.0, left: 10.0, right: 10.0, bottom: 30.0),
                  child: TextFormField(
                    maxLines: 3,
                    maxLengthEnforced: true,
                    controller: addressController,
                    focusNode: _addressFocus,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                        labelText: 'Address (Optional)',
                        labelStyle:
                            TextStyle(fontFamily: 'Exo2', color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                color: Color(0xFFA22A2B),))),
                  ),
                ),
                Row(
                  mainAxisAlignment: widget.isCancelBtnVisible ? MainAxisAlignment.spaceEvenly: MainAxisAlignment.center,
                  children: <Widget>[
                    //Save Button
                    SizedBox(
                        width: widget.isCancelBtnVisible ? 130.0 : 230.0,
                        height: 50.0,
                        child: RaisedButton(
                          color: Color(0xFFA22A2B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          onPressed: () {
                            setState(() {
                              if (_formKey.currentState.validate()) {
                                uploadPic(context);
                              } //else
                            });
                          },
                          elevation: 4.0,
                          splashColor: Colors.blueGrey,
                          child: Text(
                            'Save',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontFamily: 'Exo2'),
                          ),
                        )),

                    //Cancel Button
                    //New User Cancel btn is disabled and old user cancel btn enabled
                    Visibility(
                      visible: widget.isCancelBtnVisible,
                        child: SizedBox(
                            width: 130.0,
                            height: 50.0,
                            child: RaisedButton(
                              color: Color(0xFFA22A2B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              elevation: 4.0,
                              splashColor: Colors.blueGrey,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontFamily: 'Exo2'),
                              ),
                            )))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
