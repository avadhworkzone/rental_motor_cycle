import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/controller/bike_booking_controller.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/book_bike/book_bike_screen.dart';
import 'package:rental_motor_cycle/view/book_bike/booking_details_screen.dart';

class ReservationCardView extends StatelessWidget {
  final bool canEditDelete; // ✅ NEW

  const ReservationCardView({
    super.key,
    required this.booking,
    this.canEditDelete = true, // ✅ default true

    this.isFromToday = false,
  });

  final BookingModel booking;
  final bool isFromToday;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => BookingDetailsScreen(booking: booking));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Header with Name and Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking.userFullName,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  canEditDelete == false
                      ? SizedBox()
                      : Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: ColorUtils.primary),
                            onPressed: () {},
                            // onPressed:
                            //     () => showBikeBookingDialog(booking: booking),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: ColorUtils.red),
                            onPressed: () async {
                              await _deleteReservation(booking.id!);
                              await Get.find<BikeBookingController>()
                                  .fetchBookings();
                            },
                          ),
                        ],
                      ),
                ],
              ),
              SizedBox(height: 6),

              /// 🔹 Check-in / Check-out and Contact Info
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          Icons.calendar_today,
                          "${StringUtils.pickUp}: ${booking.pickupDate}",
                        ),
                        _buildInfoRow(
                          Icons.calendar_today_outlined,
                          "${StringUtils.drop}: ${booking.dropoffDate}",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(Icons.phone, booking.userPhone),
                        _buildInfoRow(Icons.email, booking.userEmail),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              /// 🔹 Divider & Pricing
              if (!isFromToday) ...[
                Divider(thickness: 1, height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPriceRow(
                        StringUtils.bike,
                        0,
                        strValue: booking.bikes
                            .map((e) => e.brandName)
                            .toList()
                            .join(','),
                      ),
                      _buildPriceRow(
                        StringUtils.rentPerDay,
                        booking.rentPerDay,
                      ),
                      _buildPriceRow(StringUtils.subtotal, booking.totalRent),
                      _buildPriceRow(StringUtils.tax, booking.tax),
                      _buildPriceRow(StringUtils.discount, booking.discount),
                      _buildPriceRow(
                        StringUtils.grandTotal,
                        booking.finalAmountPayable,
                        isBold: true,
                      ),
                      _buildPriceRow(
                        StringUtils.prepayment,
                        booking.prepayment,
                      ),
                      // _buildPriceRow(StringUtils.balance, booking.balance,
                      //     isBold: true, color: ColorUtils.red),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: ColorUtils.grey99),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double value, {
    bool isBold = false,
    Color color = ColorUtils.black,
    String? strValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            strValue ?? "\$${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteReservation(int reservationId) async {
    Get.defaultDialog(
      title: StringUtils.deleteReservationTitle,
      middleText: StringUtils.deleteReservationMessage,
      textConfirm: StringUtils.yes,
      textCancel: StringUtils.no,
      confirmTextColor: ColorUtils.white,
      onConfirm: () async {
        await Get.find<BikeBookingController>().deleteBooking(reservationId);
        Get.back();
        await Get.find<BikeBookingController>().fetchBookings();
      },
    );
  }
}
