import 'package:CampusCar/constants/colors.dart';
import 'package:CampusCar/locator.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/service/vehicle_service.dart';
import 'package:CampusCar/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DialogContent extends StatefulWidget {
  final Vehicle vehicle;
  const DialogContent({@required this.vehicle});

  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  var vehicleService = locator<VehicleService>();

  String editedDate;
  @override
  void initState() {
    super.initState();
    editedDate = widget.vehicle.expires;
  }

  void selectDate(context) async {
    final DateTime newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(editedDate),
      firstDate: DateTime(2019, 1),
      lastDate: DateTime(2030, 7),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        editedDate = newDate.toString();
      });
    }
  }

  void editVehicleHandler() async {
    Vehicle newVehicle = widget.vehicle;
    newVehicle.expires = editedDate;

    await vehicleService.addVehicle(vehicle: newVehicle, isEdit: true);
    Utils.showFlashMsg(
        context: context,
        color: successColor,
        message:
            "Successfully updated the expiry date for vehicle ${widget.vehicle.licensePlateNo}.");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat("dd, MMMM yyyy hh:mm aa")
                  .format(DateTime.parse(editedDate)),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: InkWell(
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
                onTap: () {
                  selectDate(context);
                },
              ),
            ),
          ],
        ),
        InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: editVehicleHandler,
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            // margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: primaryBlue,
            ),
            child: Text("Edit Vehicle",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300)),
          ),
        ),
      ],
    );
  }
}
