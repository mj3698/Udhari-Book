import 'package:flutter/material.dart';

class CustSupport extends StatefulWidget {
  @override
  _CustSupportState createState() => _CustSupportState();
}

class _CustSupportState extends State<CustSupport > {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Support'),
        backgroundColor: Color(0xFFA22A2B),
      ),
    );
  }
}
