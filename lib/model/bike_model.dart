import 'package:rental_motor_cycle/utils/string_utils.dart';

class BikeModel {
  int? id;
  String name;
  String model;
  String numberPlate;
  double rentPerDay;
  String location;
  String fuelType;
  double mileage;
  int engineCC;
  String description;
  // bool isAvailable;
  String imageUrl;
  int userId; // Owner of the bike
  DateTime createdAt;

  BikeModel({
    this.id,
    required this.name,
    required this.model,
    required this.numberPlate,
    required this.rentPerDay,
    required this.location,
    required this.fuelType,
    required this.mileage,
    required this.engineCC,
    required this.description,
    // this.isAvailable = true,
    this.imageUrl = "",
    required this.userId,
    required this.createdAt,
  });

  // Convert a BikeModel to a Map
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
      // 'isAvailable': isAvailable,
      'imageUrl': imageUrl,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert a Map to a BikeModel
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
      // isAvailable: map['isAvailable'] ?? true,
      imageUrl: map['imageUrl'] ?? '',
      userId: map['userId'],
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
