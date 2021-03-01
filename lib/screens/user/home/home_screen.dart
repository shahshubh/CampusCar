//import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:CampusCar/constants/constants.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/user/vehicle/vehicle_detail.dart';
import 'package:CampusCar/service/firebase_service.dart';
import 'package:CampusCar/widgets/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:CampusCar/constants/colors.dart';
//import 'package:CampusCar/widgets/loading_screen.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:CampusCar/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[200], blurRadius: 30, offset: Offset(0, 10))
];

class HomeScreen extends StatefulWidget {
  final Function currentScreenHandler;
  HomeScreen({@required this.currentScreenHandler});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseService firebaseService = new FirebaseService();
  final picker = ImagePicker();
  bool isLoading = false;

  Future getLicensePlate({String source}) async {
    var url = 'http://192.168.0.105:3000/upload';
    print("LOADING.....");
    // ImageSource imageSource =
    //     source == "camera" ? ImageSource.camera : ImageSource.gallery;
    // final pickedFile = await picker.getImage(source: imageSource);

    final pickedFile = await getImage(source: "gallery");
    setState(() {
      isLoading = true;
    });

    if (pickedFile == null) {
      return null;
    }

    var request = http.MultipartRequest("POST", Uri.parse(url));
    var pic = await http.MultipartFile.fromPath("image", pickedFile.path);
    request.files.add(pic);

    var response = await request.send();

    if (response.statusCode != 200) {
      return jsonDecode(
          '{"success": false,"error": "Something went wrong !! Please try again after sometime"}');
    } else {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(jsonDecode(responseString));
      print("=========== Getting Lic final done ==============");

      return jsonDecode(responseString);
    }
  }

  Future getImage({String source}) async {
    print("=========== Getting Image ==============");
    ImageSource imageSource =
        source == "camera" ? ImageSource.camera : ImageSource.gallery;
    final pickedFile = await picker.getImage(source: imageSource);

    return pickedFile;
  }

  // Future getLicensePlate({image}) async {
  //   print("=========== Getting License ==============");

  //   var res = await http.get(apiUrl);
  //   print(res.body);

  //   // send request to server with image
  //   var endpoint = apiUrl + 'upload/';
  //   print(endpoint);
  //   var request = http.MultipartRequest("POST", Uri.parse(endpoint));
  //   var pic = await http.MultipartFile.fromPath("image", image.path);
  //   request.files.add(pic);

  //   var response = await request.send();
  //   print("=========== Getting Lic done ==============");

  //   if (response.statusCode != 200) {
  //     return jsonDecode(
  //         '{"success": false,"error": "Something went wrong !! Please try again after sometime"}');
  //   } else {
  //     var responseData = await response.stream.toBytes();
  //     var responseString = String.fromCharCodes(responseData);
  //     print(jsonDecode(responseString));
  //     print("=========== Getting Lic final done ==============");

  //     return jsonDecode(responseString);
  //   }
  // }

  Future btnPressHandler({String source}) async {
    // final image = await getImage(source: source);
    // var response = await getLicensePlate(image: image);

    var response = await getLicensePlate(source: "gallery");
    if (response == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("No Image selected"),
      ));
      setState(() {
        isLoading = false;
      });
      return;
    }
    print("---------------------------");
    print(response["license_plate"]);
    print("---------------------------");
    // print(response["license_plate"]);

    String licensePlateNo = response["license_plate"];

    bool success = response["success"];
    bool isExpired = false;

    if (success) {
      // find vehicle in db
      Vehicle foundVehicle =
          await firebaseService.getVehicle(licensePlateNo: licensePlateNo);
      setState(() {
        isLoading = false;
      });
      if (foundVehicle != null) {
        // check expiry
        if (!isExpired) {
          // add logs
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VehicleDetail(
            isAllowed: isExpired ? false : true,
            isExpired: isExpired,
            success: success,
            ownerImageUrl:
                "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MXwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
            numberPlate: "MH04AJ8895",
            ownerName: "Shubh Shah",
            ownerPhone: "9900948989",
            expires: "21 Feb 2022",
            role: "Faculty",
            model: "WagonR",
            color: "#2444555",
          );
        }));
      }
      // No vehicle found
      else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VehicleDetail(
            isAllowed: false,
            success: false,
            errorMsg: "NO VEHICLE FOUND",
          );
        }));
      }
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return VehicleDetail(
          isAllowed: false,
          success: false,
          errorMsg: response["error"],
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      child: isLoading
          ? Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 95),
              child: LoadingScreen(),
            )
          : Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 95),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Campus Car",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CarterOne',
                      letterSpacing: 1.0,
                      color: primaryBlue,
                    ),
                  ),
                  Container(
                    child: Image.asset(
                      'assets/images/car-home-f.PNG',
                    ),
                  ),
                  Column(
                    children: [
                      RoundedButton(
                          press: () async {
                            // var response = await http.get(url);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_upload,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Upload",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            ],
                          )),
                      Text(
                        "- OR -",
                        style: TextStyle(fontSize: 18),
                      ),
                      RoundedButton(
                          press: () {
                            // getImage2();
                            btnPressHandler(source: "gallery");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Camera",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
