import 'dart:convert';
import 'package:CampusCar/components/live_button.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/screens/user/vehicle/live_vehicle_screen.dart';
import 'package:CampusCar/screens/user/vehicle/vehicle_detail_screen.dart';
import 'package:CampusCar/service/vehicle_service.dart';
import 'package:CampusCar/widgets/loading_screen.dart';
import 'package:http/http.dart' as http;
import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:CampusCar/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:CampusCar/locator.dart';

class HomeScreen extends StatefulWidget {
  final Function currentScreenHandler;
  HomeScreen({@required this.currentScreenHandler});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var vehicleService = locator<VehicleService>();
  final picker = ImagePicker();
  bool isLoading = false;

  Future getLicensePlate({String source}) async {
    // var endpoint = 'http://localhost:3000/upload';
    var endpoint = 'http://10.0.2.2:3000/upload';

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
    // get license plate number from server
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
    bool success = response["success"];

    // if successful response is recieved
    if (success) {
      // find vehicle in db with the detected license plate no.
      String licensePlateNo = response["license_plate"];
      Vehicle foundVehicle =
          await vehicleService.getVehicle(licensePlateNo: licensePlateNo);
      // If the vehicle is registered/exists in db
      if (foundVehicle != null) {
        var isExpired =
            DateTime.parse(foundVehicle.expires).compareTo(DateTime.now()) > 0
                ? false
                : true;
        // If the access period of vehicle is not expired
        if (!isExpired) {
          // add logs
          await vehicleService.addLog(vehicle: foundVehicle);
        }

        setState(() {
          isLoading = false;
        });
        // finally show the vehicle detail screen
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VehicleDetail(
            isAllowed: !isExpired,
            isExpired: isExpired,
            success: success,
            vehicle: foundVehicle,
          );
        }));
      }

      // If the vehicle is NOT registered/exists in db
      else {
        setState(() {
          isLoading = false;
        });
        // Show Vehicle detail screen with appropriate error msg.
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VehicleDetail(
            isAllowed: false,
            success: false,
            errorMsg: "No vehicle found for License Plate = $licensePlateNo",
            vehicle: null,
          );
        }));
      }
    }
    // if successful response is NOT recieved
    else {
      setState(() {
        isLoading = false;
      });
      // Show error screen
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
                      'assets/images/car-home.png',
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

                      // temporary button for testing
                      // RoundedButton(
                      //     press: () {
                      //       vehicleService.addLiveVehicle();
                      //     },
                      //     child: Text(
                      //       "Add Live Vehicle",
                      //       style: TextStyle(color: Colors.white),
                      //     )),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
