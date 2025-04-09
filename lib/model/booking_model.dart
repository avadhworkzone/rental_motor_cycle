import 'dart:convert';

import 'package:rental_motor_cycle/model/bike_model.dart';

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
  double rentPerDay;
  double discount;
  double tax;
  double prepayment;
  bool isConfirmed;
  DateTime createdAt;
  double durationInHours;
  double totalRent;
  double finalAmountPayable;
  List<BikeModel> bikes;
  // New fields
  String typeOfPayment;
  num mileage;
  double extraPerKm;
  double securityDeposit;
  double subtotal;
  double balance;

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
    required this.rentPerDay,
    this.discount = 0,
    this.tax = 0,
    this.prepayment = 0,
    this.isConfirmed = false,
    required this.createdAt,
    required this.durationInHours,
    required this.totalRent,
    required this.finalAmountPayable,
    required this.bikes,
    // New required fields
    required this.typeOfPayment,
    this.mileage = 0,
    this.extraPerKm = 0,
    this.securityDeposit = 0,
    this.subtotal = 0,
    this.balance = 0,
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
      rentPerDay: (map['rentPerDay'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      tax: (map['tax'] ?? 0).toDouble(),
      prepayment: (map['prepayment'] ?? 0).toDouble(),
      isConfirmed: map['isConfirmed'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      durationInHours: (map['durationInHours'] ?? 0).toDouble(),
      totalRent: (map['totalRent'] ?? 0).toDouble(),
      finalAmountPayable: (map['finalAmountPayable'] ?? 0).toDouble(),
      typeOfPayment: map['typeOfPayment'] ?? '',
      mileage: (map['mileage'] ?? 0).toDouble(),
      extraPerKm: (map['extraPerKm'] ?? 0).toDouble(),
      securityDeposit: (map['securityDeposit'] ?? 0).toDouble(),
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      balance: (map['balance'] ?? 0).toDouble(),
      bikes:
          map['bikes'] != null && map['bikes'] != "" && map['bikes'] != "null"
              ? (jsonDecode(map['bikes']) as List)
                  .cast<Map<String, dynamic>>()
                  .map((e) => BikeModel.fromMap(e))
                  .toList()
              : [],
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
      'rentPerDay': rentPerDay,
      'discount': discount,
      'tax': tax,
      'prepayment': prepayment,
      'isConfirmed': isConfirmed ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'durationInHours': durationInHours,
      'totalRent': totalRent,
      'finalAmountPayable': finalAmountPayable,
      'typeOfPayment': typeOfPayment,
      'mileage': mileage,
      'extraPerKm': extraPerKm,
      'securityDeposit': securityDeposit,
      'subtotal': subtotal,
      'balance': balance,
      'bikes': jsonEncode(bikes.map((e) => e.toMap()).toList()),
    };
  }
}
