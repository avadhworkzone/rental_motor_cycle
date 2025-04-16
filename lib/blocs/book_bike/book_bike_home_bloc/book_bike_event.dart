import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';

abstract class BookBikeEvent {}

class FetchBikesEvent extends BookBikeEvent {}

class InitializeBookingForm extends BookBikeEvent {
  final BikeModel bike;
  final BookingModel? booking;

  InitializeBookingForm({required this.bike, this.booking});
}
