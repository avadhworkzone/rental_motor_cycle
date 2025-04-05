class BookingModel {
  int? id;
  int? userId;
  int bikeId;
  String bikeName;
  String bikeModel;
  String userFullName;
  String userPhone;
  String userEmail;
  DateTime pickupDate;
  DateTime dropoffDate;
  String pickupTime;
  String dropoffTime;
  String pickupLocation;
  String dropoffLocation;
  double rentPerDay;
  double discount;
  double tax;
  double prepayment;
  bool isConfirmed;
  DateTime createdAt;
  double durationInHours;
  double totalRent;
  double finalAmountPayable;

  BookingModel({
    this.id,
    this.userId,
    required this.bikeId,
    required this.bikeName,
    required this.bikeModel,
    required this.userFullName,
    required this.userPhone,
    required this.userEmail,
    required this.pickupDate,
    required this.dropoffDate,
    required this.pickupTime,
    required this.dropoffTime,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.rentPerDay,
    this.discount = 0,
    this.tax = 0,
    this.prepayment = 0,
    this.isConfirmed = false,
    required this.createdAt,
    required this.durationInHours,
    required this.totalRent,
    required this.finalAmountPayable,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      userId: map['userId'],
      bikeId: map['bikeId'],
      bikeName: map['bikeName'],
      bikeModel: map['bikeModel'],
      userFullName: map['userFullName'],
      userPhone: map['userPhone'],
      userEmail: map['userEmail'],
      pickupDate: DateTime.parse(map['pickupDate']),
      dropoffDate: DateTime.parse(map['dropoffDate']),
      pickupTime: map['pickupTime'],
      dropoffTime: map['dropoffTime'],
      pickupLocation: map['pickupLocation'],
      dropoffLocation: map['dropoffLocation'],
      rentPerDay: (map['rentPerDay'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      tax: (map['tax'] ?? 0).toDouble(),
      prepayment: (map['prepayment'] ?? 0).toDouble(),
      isConfirmed: map['isConfirmed'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      durationInHours: (map['durationInHours'] ?? 0).toDouble(),
      totalRent: (map['totalRent'] ?? 0).toDouble(),
      finalAmountPayable: (map['finalAmountPayable'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bikeId': bikeId,
      'bikeName': bikeName,
      'bikeModel': bikeModel,
      'userFullName': userFullName,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'pickupDate': pickupDate.toIso8601String(),
      'dropoffDate': dropoffDate.toIso8601String(),
      'pickupTime': pickupTime,
      'dropoffTime': dropoffTime,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'rentPerDay': rentPerDay,
      'discount': discount,
      'tax': tax,
      'prepayment': prepayment,
      'isConfirmed': isConfirmed ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'durationInHours': durationInHours,
      'totalRent': totalRent,
      'finalAmountPayable': finalAmountPayable,
    };
  }
}
