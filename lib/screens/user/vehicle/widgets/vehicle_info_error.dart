import 'package:CampusCar/components/progress_widget.dart';
import 'package:CampusCar/constants/colors.dart';
import 'package:flutter/material.dart';

class VehicleInfoError extends StatelessWidget {
  final String errorMsg;
  final bool isLoading;
  final Function findVehicleHandler;
  final String timestamp;
  VehicleInfoError({
    this.errorMsg,
    this.findVehicleHandler,
    this.isLoading = false,
    this.timestamp,
  });

  final TextEditingController textEditingController =
      new TextEditingController();

  void searchBtnHandler(context) {
    print(textEditingController.text);
    if (textEditingController.text != "" &&
        textEditingController.text != null) {
      findVehicleHandler(
        licensePlate: textEditingController.text,
        timestamp: timestamp,
      );
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Input field cannot be empty !!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              errorMsg,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          SizedBox(
            height: 45,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: TextField(
                    controller: textEditingController,
                    cursorColor: primaryBlue,
                    decoration: InputDecoration(
                      hintText: "Enter License Plate No. ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                            width: 1,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(
                          width: 1,
                          color: primaryBlue,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    color: primaryBlue,
                    onPressed: () {
                      if (!isLoading) {
                        searchBtnHandler(context);
                      }
                    },
                    child: isLoading
                        ? circularprogress()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Search",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.search,
                                color: Colors.white,
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
