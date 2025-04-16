import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  List<BookingModel> _allBookings = [];

  ReportBloc() : super(ReportInitial()) {
    on<LoadReportData>(_onLoadData);
    on<ChangeFilter>(_onChangeFilter);
  }

  Future<void> _onLoadData(
    LoadReportData event,
    Emitter<ReportState> emit,
  ) async {
    _allBookings = event.bookings;
    emit(
      ReportLoaded(
        selectedFilter: event.selectedFilter,
        groupedTransactions: _groupTransactions(
          event.bookings,
          event.selectedFilter,
        ),
      ),
    );
  }

  Future<void> _onChangeFilter(
    ChangeFilter event,
    Emitter<ReportState> emit,
  ) async {
    emit(
      ReportLoaded(
        selectedFilter: event.newFilter,
        groupedTransactions: _groupTransactions(_allBookings, event.newFilter),
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupTransactions(
    List<BookingModel> bookingList,
    String selectedFilter,
  ) {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in bookingList) {
      final checkoutDate = item.dropoffDate;
      String groupKey = "";

      if (selectedFilter == "Daily") {
        groupKey = DateFormat("dd MMM yyyy").format(checkoutDate);
      } else if (selectedFilter == "Monthly") {
        groupKey = DateFormat("MMMM yyyy").format(checkoutDate);
      } else if (selectedFilter == "Yearly") {
        groupKey = DateFormat("yyyy").format(checkoutDate);
      }

      if (!grouped.containsKey(groupKey)) {
        grouped[groupKey] = [];
      }

      grouped[groupKey]!.add({
        "date": DateFormat("dd MMM yyyy").format(checkoutDate),
        "amount": (item.balance as num).toDouble(),
        "guest": item.userFullName ?? "Unknown",
      });
    }

    return grouped;
  }
}
