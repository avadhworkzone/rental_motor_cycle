import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/controller/bike_booking_controller.dart';
import 'package:rental_motor_cycle/controller/bike_controller.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/view/book_bike/booking_details_screen.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen>
    with SingleTickerProviderStateMixin {
  final BikeBookingController bikeBookingController =
      Get.find<BikeBookingController>();
  final BikeController bikeController = Get.find<BikeController>();
  final tabLabels = [StringUtils.pickUp, StringUtils.drop];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    initMethod();
    bikeController.fetchBikes();
    super.initState();
  }

  initMethod() async {
    await bikeBookingController.fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(StringUtils.todayBooking),
        bottom: TabBar(
          controller: _tabController,

          indicatorColor: isDarkTheme?ColorUtils.white:ColorUtils.primary,
          labelColor: isDarkTheme?ColorUtils.white:ColorUtils.primary,
          unselectedLabelColor: isDarkTheme?ColorUtils.white:Colors.black,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          // Selected tab bold
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          // Unselected tab normal
          tabs: tabLabels.map((label) => Tab(text: label)).toList(),
          onTap: (value) {
            setState(() {});
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        // onPressed: () => chooseAddCalendarBottomSheet(),
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        if (bikeBookingController.bookingList.isEmpty) {
          return const Center(child: Text(StringUtils.noBookedBikes));
        }

        final now = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());

        final checkInReservationList =
            bikeBookingController.bookingList.where((ele) {
              final checkin = ele.pickupDate;
              return now.isAtSameMomentAs(checkin);
            }).toList();

        final checkOutReservationList =
            bikeBookingController.bookingList.where((ele) {
              final checkout = ele.dropoffDate;
              return now.isAtSameMomentAs(checkout);
            }).toList();

        return TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            checkInReservationList.isEmpty
                ? Center(child: Text(StringUtils.noPickUpToday))
                : ReservationList(bookingList: checkInReservationList),
            checkOutReservationList.isEmpty
                ? Center(child: Text(StringUtils.noDropOffToday))
                : ReservationList(bookingList: checkOutReservationList),
          ],
        );
      }),
    );
  }
}

class ReservationList extends StatelessWidget {
  const ReservationList({super.key, required this.bookingList});

  final List<BookingModel> bookingList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(ColorUtils.grey99),
        showCheckboxColumn: false, // 👈 removes the checkbox

        columns: const [
          DataColumn(label: Text(StringUtils.userName)),
          DataColumn(label: Text(StringUtils.bike)),
          DataColumn(label: Text(StringUtils.pickUp)),
          DataColumn(label: Text(StringUtils.drop)),
          DataColumn(label: Text(StringUtils.amountPayable)),
        ],
        rows:
            bookingList.map((booking) {
              return DataRow(
                onSelectChanged: (value) {
                  Get.to(() => BookingDetailsScreen(booking: booking));
                },
                cells: [
                  DataCell(Text(booking.userFullName)),
                  DataCell(Text(booking.bikeName)),
                  DataCell(
                    Text(DateFormat('yyyy-MM-dd').format(booking.pickupDate)),
                  ),
                  DataCell(
                    Text(DateFormat('yyyy-MM-dd').format(booking.dropoffDate)),
                  ),
                  DataCell(Text('${booking.finalAmountPayable}')),
                ],
              );
            }).toList(),
      ),
    );
  }
}
