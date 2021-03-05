import 'dart:convert';
import 'package:CampusCar/components/live_button.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/user/vehicle/live_vehicle.dart';
import 'package:CampusCar/screens/user/vehicle/vehicle_detail.dart';
import 'package:CampusCar/service/firebase_service.dart';
import 'package:CampusCar/widgets/loading_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:CampusCar/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    // const endpoint = apiUrl + 'upload/';
    var endpoint = 'http://192.168.0.103:3000/upload';
    final pickedFile = await getImage(source: source);
    setState(() {
      isLoading = true;
    });

    if (pickedFile == null) {
      return null;
    }

    var request = http.MultipartRequest("POST", Uri.parse(endpoint));
    var pic = await http.MultipartFile.fromPath("image", pickedFile.path);
    request.files.add(pic);
    var response;
    try {
      response = await request.send();
    } catch (error) {
      return jsonDecode(
          '{"success": false,"error": "Something went wrong !! Please try again after sometime"}');
    }

    // var response = await request.send().catchError(
    //       (onError) => print(
    //           "Something went wrong !! Please try again after sometime ==>> $onError"),
    //     );

    if (response.statusCode != 200) {
      return jsonDecode(
          '{"success": false,"error": "Something went wrong !! Please try again after sometime"}');
    } else {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(jsonDecode(responseString));

      return jsonDecode(responseString);
    }
  }

  Future getImage({String source}) async {
    ImageSource imageSource =
        source == "camera" ? ImageSource.camera : ImageSource.gallery;
    final pickedFile = await picker.getImage(source: imageSource);

    return pickedFile;
  }

  Future btnPressHandler({String source}) async {
    var response = await getLicensePlate(source: source);
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

    bool success = response["success"];

    if (success) {
      // find vehicle in db
      String licensePlateNo = response["license_plate"];
      Vehicle foundVehicle =
          await firebaseService.getVehicle(licensePlateNo: licensePlateNo);

      if (foundVehicle != null) {
        var isExpired =
            DateTime.parse(foundVehicle.expires).compareTo(DateTime.now()) > 0
                ? false
                : true;

        // check expiry
        if (!isExpired) {
          // add logs
        }
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VehicleDetail(
            isAllowed: isExpired ? false : true,
            isExpired: isExpired,
            success: success,
            vehicle: foundVehicle,
          );
        }));
      }
      // No vehicle found
      else {
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VehicleDetail(
            isAllowed: false,
            success: false,
            errorMsg: "No vehicle found for License Plate = $licensePlateNo",
            vehicle: null,
          );
        }));
      }
    } else {
      setState(() {
        isLoading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return VehicleDetail(
          isAllowed: false,
          success: false,
          errorMsg: response["error"],
          vehicle: null,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      rightIcon: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LiveVehicle()),
          );
        },
        child: liveButton(),
      ),
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
                            btnPressHandler(source: "gallery");
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
                            btnPressHandler(source: "camera");
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
