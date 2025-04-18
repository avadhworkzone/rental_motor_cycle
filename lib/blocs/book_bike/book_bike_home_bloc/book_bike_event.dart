import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';

abstract class BookBikeEvent {}

class FetchBikeEvents extends BookBikeEvent {}

class AddBookingEvent extends BookBikeEvent {
  final BookingModel booking;
  AddBookingEvent(this.booking);
}

class UpdateBookingEvent extends BookBikeEvent {
  final BookingModel booking;
  UpdateBookingEvent(this.booking);
}

class DeleteBookingEvent extends BookBikeEvent {
  final int bookingId; // or use BookingModel if needed
  DeleteBookingEvent(this.bookingId);
}

class FetchBookingsEvent extends BookBikeEvent {}

class InitializeBookingForm extends BookBikeEvent {
  final BikeModel bike;
  final BookingModel? booking;

  InitializeBookingForm({required this.bike, this.booking});
}
