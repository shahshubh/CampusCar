class Vehicle {
  String ownerName;
  String ownerMobileNo;
  String licensePlateNo;
  String role;
  String model;
  String color;
  String expires;
  String profileImage;

  Vehicle({
    this.ownerName,
    this.ownerMobileNo,
    this.licensePlateNo,
    this.role,
    this.model,
    this.color,
    this.expires,
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'ownerName': ownerName,
      'ownerMobileNo': ownerMobileNo,
      'licensePlateNo': licensePlateNo,
      'role': role,
      'model': model,
      'color': color,
      'expires': expires,
      'profileImage': profileImage,
    };
  }

  factory Vehicle.fromMap(Map<dynamic, dynamic> data) {
    return Vehicle(
      ownerName: data["ownerName"],
      ownerMobileNo: data["ownerMobileNo"],
      licensePlateNo: data["licensePlateNo"],
      role: data["role"],
      model: data["model"],
      color: data["color"],
      expires: data["expires"],
      profileImage: data["profileImage"],
    );
  }
}