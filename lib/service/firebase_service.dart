import 'package:CampusCar/enum/direction.dart';
import 'package:CampusCar/models/log.dart';
import 'package:CampusCar/models/vehicle.dart';
import 'package:CampusCar/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  CollectionReference vehiclesRef =
      FirebaseFirestore.instance.collection('vehicles');
  CollectionReference logsRef = FirebaseFirestore.instance.collection('logs');
  CollectionReference liveVehiclesRef =
      FirebaseFirestore.instance.collection("livevehicles");

  Vehicle testVehicle = Vehicle(
    licensePlateNo: 'MH12DE1433',
    color: '#000000',
    expires: new DateTime.now().toString(),
    model: 'Ford',
    ownerMobileNo: '9988786734',
    ownerName: 'Shubh Shah',
    profileImage:
        "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MXwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
    role: "Faculty",
  );
  Future<void> addVehicle() {
    return vehiclesRef
        .doc(testVehicle.licensePlateNo)
        .set(testVehicle.toMap())
        .then((value) => print("Vehicle Added"))
        .catchError((error) => print("Failed =>   $error"));
  }

  Future<Vehicle> getVehicle({String licensePlateNo}) async {
    var data = await vehiclesRef.doc(licensePlateNo).get();
    if (data.data() != null) {
      Vehicle vehicle = Vehicle.fromMap(data.data());
      print(vehicle.licensePlateNo);
      return vehicle;
    } else {
      return null;
    }
  }

  Future<void> addLog() {
    var currTime = DateTime.now().toString();
    Log log = Log(
      vehicle: testVehicle.toMap(),
      direction: Utils.directionToNum(Direction.Entering),
      time: currTime,
    );

    return logsRef
        .doc(currTime)
        .set(log.toMap())
        .then((value) => print("Log Added"))
        .catchError((error) => print("Failed =>   $error"));
  }

  Future<Log> getLog() async {
    var data = await logsRef.doc("2021-03-02 16:20:16.157259").get();
    if (data.data() != null) {
      Log log = Log.fromMap(data.data());
      // Vehicle logVehicle = Vehicle.fromMap(log.vehicle);
      return log;
    } else {
      return null;
    }
  }

  Future<void> addLiveVehicle() {
    var timestamp = DateTime.now().toString();
    return FirebaseFirestore.instance
        .collection("livevehicles")
        .doc(timestamp)
        .set({
      "isAllowed": true,
      "isExpired": false,
      "success": true,
      "errorMsg": "No Error",
      "vehicle": testVehicle.toMap(),
      "timestamp": timestamp,
    });
  }

  Future<void> deleteTopmostLiveVehicle() {
    return liveVehiclesRef
        .orderBy("timestamp", descending: false)
        .limit(1)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
