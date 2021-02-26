import 'dart:convert';
import 'dart:io';
import 'package:CampusCar/screens/user/vehicle/vehicle_detail.dart';
import 'package:http/http.dart' as http;
import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/widgets/loading_screen.dart';
import 'package:CampusCar/widgets/my_drawer.dart';
import 'package:CampusCar/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  File _image;
  final picker = ImagePicker();
  var url = 'http://192.168.0.104:3000/upload';

  Future getImage() async {
    print("LOADING.....");
    // final pickedFile = await picker.getImage(source: ImageSource.camera);
    bool success = true;
    bool vehicleFound = true;
    bool isExpired = false;

    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return VehicleDetail(
    //     isAllowed: true,
    //     success: true,
    //     ownerImageUrl:
    //         "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MXwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
    //     numberPlate: "MH04AJ8895",
    //     ownerName: "Shubh Shah",
    //     ownerPhone: "9900948989",
    //     expires: "21 Feb 2022",
    //     role: "Faculty",
    //     model: "WagonR",
    //     color: "#2444555",
    //     errorMsg: "NO user",
    //   );
    // }));

    if (success) {
      if (vehicleFound) {
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
          errorMsg: "ERROR",
        );
      }));
    }

    // var request = http.MultipartRequest("POST", Uri.parse(url));
    // var pic = await http.MultipartFile.fromPath("image", pickedFile.path);
    // request.files.add(pic);

    // var response = await request.send();
    // var responseData = await response.stream.toBytes();
    // var responseString = String.fromCharCodes(responseData);

    // print(responseString);
  }

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      child: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height - 95),
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
                      var response = await http.get(url);
                      print("==========================");
                      print(response.body);
                      print("==========================");
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      ],
                    )),
                Text(
                  "- OR -",
                  style: TextStyle(fontSize: 18),
                ),
                RoundedButton(
                    press: () {
                      getImage();
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
