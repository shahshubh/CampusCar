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
}
