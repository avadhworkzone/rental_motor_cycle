import 'package:rental_motor_cycle/model/bike_model.dart';

abstract class BookBikeState {}

class BookBikeInitial extends BookBikeState {}

class BookBikeLoading extends BookBikeState {}

class BookBikeLoaded extends BookBikeState {
  final List<BikeModel> bikes;
  BookBikeLoaded(this.bikes);
}

class BookBikeError extends BookBikeState {
  final String message;
  BookBikeError(this.message);
}
