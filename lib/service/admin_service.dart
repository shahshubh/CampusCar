import 'package:CampusCar/models/log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  CollectionReference vehiclesRef =
      FirebaseFirestore.instance.collection('vehicles');
  CollectionReference logsRef = FirebaseFirestore.instance.collection('logs');
  CollectionReference scansRef = FirebaseFirestore.instance.collection('scans');

  Future<int> getTotalVehiclesCount() async {
    var snapshot = await vehiclesRef.get();
    return snapshot.docs.length;
  }

  Future<int> getTotalVehicleLogs() async {
    var snapshot = await logsRef.get();
    return snapshot.docs.length;
  }

  Future<int> getTotalExpiredVehicles() async {
    var snapshot = await vehiclesRef
        .where('expires', isLessThan: DateTime.now().toString())
        .get();
    return snapshot.docs.length;
  }

  Future<int> getTotalScans() async {
    int count = 0;
    await scansRef.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        count = count + doc.data()['count'];
      }
    });
    return count;
  }

  Stream dailyScansStream() {
    return scansRef.orderBy("timestamp", descending: false).snapshots();
  }

  Stream vehiclesStream() {
    return vehiclesRef.snapshots();
  }

  Future<List<Log>> getLogsOfVehicle({String licensePlate}) async {
    // await addLog(vehicle: testVehicle);
    List<Log> allLogs = [];
    QuerySnapshot querySnapshot = await logsRef
        .where('vehicle.licensePlateNo', isEqualTo: licensePlate)
        .orderBy('time', descending: true)
        .get();

    querySnapshot.docs.forEach((element) {
      allLogs.add(Log.fromMap(element.data()));
    });

    print(allLogs[0].toMap());

    return allLogs;
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
}
