import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:native_contact_picker/native_contact_picker.dart';

class custDetails extends StatefulWidget {
  @override
  _custDetailsState createState() => _custDetailsState();
}

class _custDetailsState extends State<custDetails> {
  final NativeContactPicker _contactPicker = new NativeContactPicker();
  Contact _contact;
  var _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  void contactPicker() {
    if (_contact != null) {
      nameController =
          TextEditingController(text: _contact.fullName.toString());
      phoneController =
          TextEditingController(text: _contact.phoneNumber.toString());
    }
    setState(() {
      print('Contact updated successfully');
    });
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,
      FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(
        'Add User',
        style: TextStyle(fontFamily: 'Exo2'),
    ),
    backgroundColor: Color(0xFFA22A2B),
    ),
    body: Builder(
    builder: (context) =>
    SingleChildScrollView(
    child: Form(
    key: _formKey,
    child: Column(
    children: <Widget>[
    Padding(
    padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
    child: TextFormField(
    keyboardType: TextInputType.text,
    controller: nameController,
    textInputAction: TextInputAction.next,
    focusNode: _nameFocus,
    onFieldSubmitted: (term) {
    _fieldFocusChange(context, _nameFocus, _phoneFocus);
    },
    validator: (input) {
    if (input.isEmpty) return 'Please enter Name';
    },
    decoration: InputDecoration(
    prefixIcon: Icon(
    Icons.perm_identity,
    color: Color(0xFFA22A2B),
    size: 25.0,
    ),
    suffixIcon: IconButton(
    icon: Icon(Icons.perm_contact_calendar,
    ),
    onPressed: () async {
    Contact contact = await _contactPicker.selectContact();
    _contact = contact;
    contactPicker();
    },
    iconSize: 27,
    focusColor: Color(0xFFA22A2B),
    ),
    labelText: 'Full Name',
    labelStyle: TextStyle(
    fontFamily: 'Ex02',
    fontWeight: FontWeight.bold,
    color: Colors.grey
    ),
    hintText: 'Enter Name',
    hintStyle: TextStyle(fontFamily: 'Exo2'),
    focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFA22A2B),),
    )
    ),
    ),
    ),

    Padding(
    padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
    child: TextFormField(
    keyboardType: TextInputType.phone,
    controller: phoneController,
    textInputAction: TextInputAction.next,
    focusNode: _phoneFocus,
    onFieldSubmitted: (term) {
    _fieldFocusChange(context, _phoneFocus, _emailFocus);
    },
    validator: (var mobile) {
      if (mobile.isEmpty)
        return 'Please enter Number';
    },
    decoration: InputDecoration(
    prefixIcon: Icon(
    Icons.local_phone,
    color: Color(0xFFA22A2B),
    size: 25.0,
    ),
    labelText: 'Mobile Number',
    labelStyle: TextStyle(
    fontFamily: 'Ex02',
    fontWeight: FontWeight.bold,
    color: Colors.grey
    ),
    hintText: 'Enter Mobile Number',
    hintStyle: TextStyle(fontFamily: 'Exo2'),
    focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFA22A2B),),
    )
    ),
    ),
    ),

    Padding(
    padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
    child: TextFormField(
    keyboardType: TextInputType.emailAddress,
    controller: emailController,
    textInputAction: TextInputAction.next,
    focusNode: _emailFocus,
    onFieldSubmitted: (term) {
    _fieldFocusChange(context, _emailFocus, _addressFocus);
    },
    validator: (String email) {
    if (email.isNotEmpty && email.contains('@') == false)
    return 'Please enter correct Email Id';
    },
    decoration: InputDecoration(
    prefixIcon: Icon(
    Icons.email,
    color: Color(0xFFA22A2B),
    size: 25.0,
    ),
    labelText: 'Email Id',
    labelStyle: TextStyle(
    fontFamily: 'Ex02',
    fontWeight: FontWeight.bold,
    color: Colors.grey
    ),
    hintText: 'Enter Email Id',
    hintStyle: TextStyle(fontFamily: 'Exo2'),
    focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFA22A2B),),
    )
    ),
    ),
    ),

    Padding(
    padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0,bottom: 30.0),
    child: TextFormField(
    keyboardType: TextInputType.multiline,
    controller: addressController,
    textInputAction: TextInputAction.newline,
    focusNode: _addressFocus,
    onFieldSubmitted: (term) {
    _fieldFocusChange(context, _addressFocus, _addressFocus);
    },
    decoration: InputDecoration(
    prefixIcon: Icon(
    Icons.location_city,
    color: Color(0xFFA22A2B),
    size: 25.0,
    ),
    labelText: 'Address',
    labelStyle: TextStyle(
    fontFamily: 'Ex02',
    fontWeight: FontWeight.bold,
    color: Colors.grey
    ),
    hintText: 'Type city of location',
    hintStyle: TextStyle(fontFamily: 'Exo2'),
    focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFA22A2B),),
    )
    ),
    ),
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[

    //Save Button
    SizedBox(
    width: 130.0,
    height: 50.0,
    child: RaisedButton(
    color: Color(0xFFA22A2B),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18.0)),
    onPressed: () {
    setState(() {
    if (_formKey.currentState.validate()) {
    print('Save button pressed');
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
    ),
    ),
    //Cancel Button
    //New User Cancel btn is disabled and old user cancel btn enabled
    SizedBox(
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
    ))
    ],
    )
    ],
    ))
    )
    )
    );
  }
}
