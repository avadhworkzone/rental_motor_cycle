import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';

abstract class BookBikeState {}

class BookBikeInitial extends BookBikeState {}

class BookBikeLoading extends BookBikeState {}

class BookBikeLoaded extends BookBikeState {
  final List<BikeModel> bikes;
  final List<BookingModel> bookings;

  BookBikeLoaded({required this.bikes, required this.bookings});
}

// class BookBikeLoaded extends BookBikeState {
//   final List<BikeModel> bikes;
//   BookBikeLoaded(this.bikes);
// }

class BookBikeError extends BookBikeState {
  final String message;
  BookBikeError(this.message);
}

// class BookingsLoaded extends BookBikeState {
//   final List<BookingModel> bookings;
//   BookingsLoaded(this.bookings);
// }

class BookingSuccess extends BookBikeState {
  final String message;
  BookingSuccess(this.message);
}

class BookingError extends BookBikeState {
  final String message;
  BookingError(this.message);
}
