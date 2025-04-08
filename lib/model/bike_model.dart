import 'package:rental_motor_cycle/utils/string_utils.dart';

class BikeModel {
  int? id;
  String? name;
  String? model;
  String? numberPlate;
  double? rentPerDay;
  String? location;
  String? fuelType;
  num? mileage;
  num? engineCC;
  String? description;
  String? imageUrl;
  int? userId;
  DateTime? createdAt;

  // NEW FIELDS
  double? deposit;
  double? extraPerKm;
  double? kmLimit;
  int? makeYear;
  int? tripsDone;
  String? transmission;
  int? seater;
  String? fuelIncluded;

  BikeModel({
    this.id,
    this.name,
    this.model,
    this.numberPlate,
    this.rentPerDay,
    this.location,
    this.fuelType,
    this.mileage,
    this.engineCC,
    this.description,
    this.imageUrl = "",
    this.userId,
    this.createdAt,

    // NEW FIELDS
    this.deposit,
    this.extraPerKm,
    this.kmLimit,
    this.makeYear,
    this.tripsDone,
    this.transmission,
    this.seater,
    this.fuelIncluded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'numberPlate': numberPlate,
      'rentPerDay': rentPerDay,
      'location': location,
      'fuelType': fuelType,
      'mileage': mileage,
      'engineCC': engineCC,
      'description': description,
      'imageUrl': imageUrl,
      'userId': userId,
      'createdAt': createdAt?.toIso8601String(),

      // NEW FIELDS
      'deposit': deposit,
      'extraPerKm': extraPerKm,
      'kmLimit': kmLimit,
      'makeYear': makeYear,
      'tripsDone': tripsDone,
      'transmission': transmission,
      'seater': seater,
      'fuelIncluded': fuelIncluded,
    };
  }

  factory BikeModel.fromMap(Map<String, dynamic> map) {
    logs("Loading Bike: ${map['name']}, Image URL: ${map['imageUrl']}");
    return BikeModel(
      id: map['id'],
      name: map['name'],
      model: map['model'],
      numberPlate: map['numberPlate'],
      rentPerDay: (map['rentPerDay'] ?? 0).toDouble(),
      location: map['location'],
      fuelType: map['fuelType'],
      mileage: (map['mileage'] ?? 0).toDouble(),
      engineCC: map['engineCC'] ?? 0,
      description: map['description'],
      imageUrl: map['imageUrl'] ?? '',
      userId: map['userId'],
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),

      // NEW FIELDS
      deposit: (map['deposit'] ?? 0).toDouble(),
      extraPerKm: (map['extraPerKm'] ?? 0).toDouble(),
      kmLimit: (map['kmLimit'] ?? 0).toDouble(),
      makeYear: map['makeYear'] ?? 0,
      tripsDone: map['tripsDone'] ?? 0,
      transmission: map['transmission'] ?? '',
      seater: map['seater'] ?? 1,
      fuelIncluded: map['fuelIncluded'] ?? '',
    );
  }
}
