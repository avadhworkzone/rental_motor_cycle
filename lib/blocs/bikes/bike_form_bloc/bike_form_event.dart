import 'dart:io';

import 'package:rental_motor_cycle/model/bike_model.dart';

abstract class BikeFormEvent {}

class InitializeForm extends BikeFormEvent {
  final BikeModel? bike;
  InitializeForm({this.bike});
}

class UpdateBrand extends BikeFormEvent {
  final String brand;
  UpdateBrand(this.brand);
}

class UpdateSeater extends BikeFormEvent {
  final String? seater;
  UpdateSeater(this.seater);
}

class InitializeBikeFormEvent extends BikeFormEvent {
  final BikeModel? bike;
  InitializeBikeFormEvent({this.bike});

  List<Object?> get props => [bike];
}

class BikeFormSubmitted extends BikeFormEvent {
  final BikeModel? existingBike;
  BikeFormSubmitted({this.existingBike});
}

class BikeFormValidateFields extends BikeFormEvent {}

class PickedImageUpdatedEvent extends BikeFormEvent {
  final File image;
  PickedImageUpdatedEvent(this.image);

  List<Object?> get props => [image];
}

class UpdateFuelIncluded extends BikeFormEvent {
  final String? fuelIncluded;
  UpdateFuelIncluded(this.fuelIncluded);
}

class UpdateImage extends BikeFormEvent {
  final File imageFile;
  UpdateImage(this.imageFile);
}
