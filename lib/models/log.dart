class Log {
  Map<String, dynamic> vehicle;
  String time;
  // bool isEnteringCampus;
  int direction;

  Log({
    this.vehicle,
    this.time,
    // this.isEnteringCampus,
    this.direction,
  });

  Map<String, dynamic> toMap() {
    return {
      'vehicle': vehicle,
      'time': time,
      // 'isEnteringCampus': isEnteringCampus,
      'direction': direction,
    };
  }

  factory Log.fromMap(Map<dynamic, dynamic> data) {
    return Log(
      vehicle: data["vehicle"],
      time: data["time"],
      // isEnteringCampus: data["isEnteringCampus"],
      direction: data["direction"],
    );
  }
}
