// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:CampusCar/constants/colors.dart';

// class AdminLogin extends StatefulWidget {
//   State createState() => LoginPageState();
// }

// class LoginPageState extends State<AdminLogin> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: new Scaffold(
//       backgroundColor: Colors.white,
//       body: new Column(
//         children: <Widget>[
//           new SizedBox(
//             height: 100,
//           ),
//           new Image(
//             image: new AssetImage('assets/ccLogo.jpg'),
//             fit: BoxFit.cover,
//             alignment: Alignment.center,
//           ),
//           new SizedBox(
//             height: 50,
//           ),
//           new Container(
//             padding: const EdgeInsets.all(40.0),
//             child: new Form(
//                 child: new Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 new TextFormField(
//                   decoration: new InputDecoration(hintText: "Enter Email"),
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 new TextFormField(
//                   decoration: new InputDecoration(hintText: "Enter Password"),
//                   keyboardType: TextInputType.text,
//                   obscureText: true,
//                 ),
//                 new Padding(
//                   padding: const EdgeInsets.only(top: 60.0),
//                 ),
//                 new MaterialButton(
//                   height: 50.0,
//                   minWidth: 150.0,
//                   color: Colors.blue,
//                   textColor: Colors.white,
//                   child: new Icon(FontAwesomeIcons.signInAlt),
//                   onPressed: () {
//                     print("object");
//                   },
//                 ),
//                 // new RaisedButton(
//                 //   onPressed: null,
//                 //   color: Colors.blue,
//                 //   textColor: Colors.white,
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: new Text(
//                 //     "Login",
//                 //   ),
//                 // )
//               ],
//             )),
//           ),
//         ],
//       ),
//     ));
//   }
// }

import 'package:CampusCar/screens/admin/admin_main_screen.dart';
import 'package:CampusCar/screens/admin/signup/admin_signup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CampusCar/constants/colors.dart' as Constants;
import 'package:lottie/lottie.dart';

class AdminLogin extends StatefulWidget {
  State createState() => LoginPageState();
}

class LoginPageState extends State<AdminLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipper2(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xffC8DFF1), Color(0xffAAC4E9)])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper3(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xffAAC4E9), Constants.blue5])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper1(),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      // Icon(
                      //   Icons.fastfood,
                      //   color: Colors.white,
                      //   size: 60,
                      // ),

                      SizedBox(
                        height: 20,
                      ),
                      Text("Campus Car",
                          style: TextStyle(
                              fontFamily: 'CarterOne',
                              fontSize: 40,
                              color: Colors.white)),

                      // Text(
                      //   "Taste Me",
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 30),
                      // ),
                    ],
                  ),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Constants.primaryBlue,
                    Constants.secondaryBlue,
                  ])),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                onChanged: (String value) {},
                cursorColor: Constants.blue3,
                decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.email,
                        color: Constants.primaryBlue,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                onChanged: (String value) {},
                cursorColor: Constants.blue5,
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.lock,
                        color: Constants.primaryBlue,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Constants.primaryBlue),
                child: FlatButton(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => AdminMainScreen()),
                        (route) => false);
                  },
                ),
              )),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Forgot Password ?",
                style: TextStyle(
                    color: Constants.primaryBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AdminSignup()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an Account ?",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
