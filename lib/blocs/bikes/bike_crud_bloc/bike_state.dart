import 'package:rental_motor_cycle/model/bike_model.dart';

abstract class BikeState {}

class BikeInitial extends BikeState {}

class BikeLoading extends BikeState {}

class BikeLoaded extends BikeState {
  final List<BikeModel> bikes;
  BikeLoaded(this.bikes);
}

class BikeError extends BikeState {
  final String message;
  BikeError(this.message);
}
