class UserModel {
  int? id;
  String? userId;
  String mobileNumber;
  String fullname;
  String emailId;
  String? password;
  String? role;

  UserModel({
    this.id,
    this.userId,
    required this.mobileNumber,
    required this.fullname,
    required this.emailId,
    required this.password,
    required this.role,
  });

  // Convert a UserModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mobileNumber': mobileNumber,
      'userId': userId,
      'fullname': fullname,
      'emailId': emailId,
      'password': password,
      'role': role,
    };
  }

  // Convert a Map to a UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      userId: map['userId'],
      mobileNumber: map['mobileNumber'],
      fullname: map['fullname'],
      emailId: map['emailId'],
      password: map['password'],
      role: map['role'],
    );
  }
}
