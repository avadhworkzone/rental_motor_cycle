import 'package:rental_motor_cycle/model/bike_model.dart';

abstract class BikeEvent {}

class FetchBikesEvent extends BikeEvent {}

class AddBikeEvent extends BikeEvent {
  final BikeModel bike;
  AddBikeEvent(this.bike);
}

class UpdateBikeEvent extends BikeEvent {
  final BikeModel bike;
  UpdateBikeEvent(this.bike);
}

class DeleteBikeEvent extends BikeEvent {
  final int id;
  DeleteBikeEvent(this.id);
}
