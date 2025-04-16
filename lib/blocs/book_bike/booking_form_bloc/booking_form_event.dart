import 'package:flutter/cupertino.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';

abstract class BookingFormEvent {}

class InitializeBookingForm extends BookingFormEvent {
  final BikeModel bike;
  final BookingModel? booking;
  InitializeBookingForm({required this.bike, this.booking});
}

class UpdateFromDate extends BookingFormEvent {
  final DateTime dateTime;
  UpdateFromDate(this.dateTime);
}

class FromDateChanged extends BookingFormEvent {
  final DateTime fromDate;
  FromDateChanged(this.fromDate);
}

class ToDateChanged extends BookingFormEvent {
  final DateTime toDate;
  ToDateChanged(this.toDate);
}

class BookingFormValidateFields extends BookingFormEvent {}

class CalculateBookingSummary extends BookingFormEvent {}

class PickDateTimeEvent extends BookingFormEvent {
  final bool isFrom;
  final DateTime? initialDate;
  final BuildContext context;

  PickDateTimeEvent({
    required this.isFrom,
    this.initialDate,
    required this.context,
  });
}

class BookingFormSubmitted extends BookingFormEvent {
  final BookingModel? existingBooking;
  BookingFormSubmitted({this.existingBooking});
}

class UpdateToDate extends BookingFormEvent {
  final DateTime dateTime;
  UpdateToDate(this.dateTime);
}

// class UpdateFieldValue extends BookingFormEvent {
//   final String field;
//   final String value;
//   UpdateFieldValue({required this.field, required this.value});
// }
//
// class CalculateSummary extends BookingFormEvent {}
//
// class ValidateForm extends BookingFormEvent {}

/// bike bloc

// abstract class BikeFormEvent {}
//
// class UpdateBrand extends BikeFormEvent {
//   final String brand;
//   UpdateBrand(this.brand);
// }
//
// class UpdateSeater extends BikeFormEvent {
//   final String? seater;
//   UpdateSeater(this.seater);
// }
//
// class InitializeBikeFormEvent extends BikeFormEvent {
//   final BikeModel? bike;
//   InitializeBikeFormEvent({this.bike});
//
//   List<Object?> get props => [bike];
// }
//
// class BikeFormSubmitted extends BikeFormEvent {
//   final BikeModel? existingBike;
//   BikeFormSubmitted({this.existingBike});
// }
//
// class BikeFormValidateFields extends BikeFormEvent {}
//
// class PickedImageUpdatedEvent extends BikeFormEvent {
//   final File image;
//   PickedImageUpdatedEvent(this.image);
//
//   List<Object?> get props => [image];
// }
//
// class UpdateFuelIncluded extends BikeFormEvent {
//   final String? fuelIncluded;
//   UpdateFuelIncluded(this.fuelIncluded);
// }
//
// class UpdateImage extends BikeFormEvent {
//   final File imageFile;
//   UpdateImage(this.imageFile);
// }
