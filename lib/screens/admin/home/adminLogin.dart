import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CampusCar/constants/colors.dart';

class AdminLogin extends StatefulWidget {
  State createState() => LoginPageState();
}

class LoginPageState extends State<AdminLogin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: new Scaffold(
      backgroundColor: Colors.white,
      body: new Column(
        children: <Widget>[
          new SizedBox(
            height: 100,
          ),
          new Image(
            image: new AssetImage('assets/ccLogo.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          new SizedBox(
            height: 50,
          ),
          new Container(
            padding: const EdgeInsets.all(40.0),
            child: new Form(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new TextFormField(
                  decoration: new InputDecoration(hintText: "Enter Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
                new TextFormField(
                  decoration: new InputDecoration(hintText: "Enter Password"),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                ),
                new MaterialButton(
                  height: 50.0,
                  minWidth: 150.0,
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Icon(FontAwesomeIcons.signInAlt),
                  onPressed: () {
                    print("object");
                  },
                ),
                // new RaisedButton(
                //   onPressed: null,
                //   color: Colors.blue,
                //   textColor: Colors.white,
                //   padding: const EdgeInsets.all(8.0),
                //   child: new Text(
                //     "Login",
                //   ),
                // )
              ],
            )),
          ),
        ],
      ),
    ));
  }
}
