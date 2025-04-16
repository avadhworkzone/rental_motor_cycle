import 'package:rental_motor_cycle/model/booking_model.dart';

abstract class ReportEvent {}

class LoadReportData extends ReportEvent {
  final List<BookingModel> bookings;
  final String selectedFilter;

  LoadReportData({required this.bookings, required this.selectedFilter});
}

class ChangeFilter extends ReportEvent {
  final String newFilter;

  ChangeFilter(this.newFilter);
}
