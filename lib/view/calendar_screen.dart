import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/reservation_detail_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/bike_booking_controller.dart';
import '../model/reservation_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final BikeBookingController bikeBookingController = Get.find();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final Map<DateTime, List<BookingModel>> _eventsMap = {};
  late Worker _reservationListener; // To store the listener reference

  @override
  void initState() {
    super.initState();
    _loadEvents();

    // Listen for reservation list changes
    _reservationListener = ever(bikeBookingController.bookingList, (_) {
      if (mounted) {
        _loadEvents();
      }
    });
  }

  @override
  void dispose() {
    _reservationListener.dispose();
    super.dispose();
  }

  DateTime _parseDate(String dateString) {
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    } catch (e) {
      try {
        DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(dateString);
        return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      } catch (e) {
        log("Date parsing error: $e");
        return DateTime.now();
      }
    }
  }

  void _loadEvents() {
    if (!mounted) return; // Prevent updating UI after dispose
    setState(() {
      _eventsMap.clear();
      for (var res in bikeBookingController.bookingList) {
        DateTime parsedDate = res.pickupDate;
        if (_eventsMap.containsKey(parsedDate)) {
          _eventsMap[parsedDate]!.add(res);
        } else {
          _eventsMap[parsedDate] = [res];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.calendar,
        context: context,
        isLeading: false,
        isCenterTitle: false,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      // appBar: AppBar(title: Text("Calendar")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (mounted) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            availableGestures: AvailableGestures.horizontalSwipe,
            headerVisible: false,
            calendarFormat: CalendarFormat.week,
            eventLoader: (day) {
              DateTime normalizedDay = DateTime(day.year, day.month, day.day);
              return _eventsMap[normalizedDay] ?? [];
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child:
                _eventsMap[DateTime(
                              _selectedDay.year,
                              _selectedDay.month,
                              _selectedDay.day,
                            )] ==
                            null ||
                        _eventsMap[DateTime(
                              _selectedDay.year,
                              _selectedDay.month,
                              _selectedDay.day,
                            )]!
                            .isEmpty
                    ? Center(
                      child: Text('No reservation available for the day'),
                    )
                    : ListView.builder(
                      itemCount:
                          _eventsMap[DateTime(
                                _selectedDay.year,
                                _selectedDay.month,
                                _selectedDay.day,
                              )]
                              ?.length ??
                          0,
                      itemBuilder: (context, index) {
                        final reservation =
                            _eventsMap[DateTime(
                              _selectedDay.year,
                              _selectedDay.month,
                              _selectedDay.day,
                            )]![index];
                        return _buildReservationCard(reservation);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(BookingModel booking) {
    return InkWell(
      onTap: () {
        Get.to(() => ReservationDetailScreen(booking: booking));
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.userFullName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildInfoRow(Icons.phone, "Phone: ${booking.userPhone}"),
              _buildInfoRow(Icons.email, "Email: ${booking.userEmail}"),
              SizedBox(height: 8),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _buildGuestCount(Icons.person, "Adults", booking.adult),
              //     _buildGuestCount(
              //       Icons.child_care,
              //       "Children",
              //       booking.child,
              //     ),
              //     _buildGuestCount(Icons.pets, "Pets", booking.pet),
              //   ],
              // ),
              Divider(thickness: 1, height: 16),
              // _buildPriceRow("Grand Total", reservation.grandTotal, isBold: true),
              // _buildPriceRow("Prepayment", reservation.prepayment),
              _buildPriceRow(
                "Pending Amount",
                booking.finalAmountPayable,
                isBold: true,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildGuestCount(IconData icon, String label, int count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        SizedBox(width: 4),
        Text("$label: $count", style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
