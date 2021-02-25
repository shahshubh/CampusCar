import 'package:flutter/material.dart';

class AdminSignup extends StatefulWidget {
  @override
  _AdminSignupState createState() => _AdminSignupState();
}

class _AdminSignupState extends State<AdminSignup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
        shadowColor: null,
        backgroundColor: Colors.white,
        elevation: 0,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Center(
          child: Text("Signup"),
        ),
      ),
    );
  }
}
