import 'package:CampusCar/models/vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  CollectionReference vehiclesRef =
      FirebaseFirestore.instance.collection('vehicles');

  Future<void> addVehicle() {
    Vehicle newVehicle = Vehicle(
      licensePlateNo: 'MH12DE1433',
      color: '#fff',
      expires: new DateTime.now().toString(),
      model: 'Ford',
      ownerMobileNo: '9988786734',
      ownerName: 'Shubh Shah',
      profileImage:
          "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MXwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
    );

    return vehiclesRef
        .doc(newVehicle.licensePlateNo)
        .set(newVehicle.toMap())
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
}
