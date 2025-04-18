import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_bloc.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_event.dart';
import 'package:rental_motor_cycle/blocs/book_bike/book_bike_home_bloc/book_bike_bloc.dart';
import 'package:rental_motor_cycle/blocs/book_bike/book_bike_home_bloc/book_bike_state.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/iamge_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/view/book_bike/booking_details_screen.dart';
import 'package:rental_motor_cycle/view/my_bike/dialogs/my_bike_dialogs.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../blocs/book_bike/book_bike_home_bloc/book_bike_event.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen>
    with SingleTickerProviderStateMixin {
  // final BikeBookingController bikeBookingController =
  //     Get.find<BikeBookingController>();
  // final BikeController bikeController = Get.find<BikeController>();
  final tabLabels = [StringUtils.pickUp, StringUtils.drop];
  late TabController _tabController;

  @override
  void initState() {
    // Set the status bar to match AppBar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ColorUtils.primary,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _tabController = TabController(length: 2, vsync: this);
    initMethod();
    // bikeController.fetchBikes();
    super.initState();
  }

  initMethod() async {
    context.read<BikeBloc>().add(FetchBikesEvent());
    context.read<BookBikeBloc>().add(FetchBookingsEvent());
    // await bikeBookingController.fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: BlocBuilder<BookBikeBloc, BookBikeState>(
        builder: (context, state) {
          if (state is BookBikeLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is BookBikeLoaded) {
            // final bikes = state.bikes;
            final bookings = state.bookings;
            final now = DateTime.now();
            final checkInReservationList =
                bookings.where((b) => isSameDay(b.pickupDate, now)).toList();
            final checkOutReservationList =
                bookings.where((b) => isSameDay(b.dropoffDate, now)).toList();

            // if (bookings.isEmpty) {
            //   return Center(
            //     child: CustomText(
            //       StringUtils.noBookedBikes,
            //       fontSize: 15.sp,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   );
            // }
            return Scaffold(
              backgroundColor:
                  bookings.isEmpty ? ColorUtils.white : ColorUtils.greyF0,
              floatingActionButton: SafeArea(
                child: FloatingActionButton(
                  onPressed: () => showAddBikeBottomSheet(context),
                  child: Icon(Icons.add),
                ),
              ),
              appBar: AppBar(
                toolbarHeight: 100.h,
                backgroundColor: ColorUtils.primary,
                title: CustomText(
                  StringUtils.todayBooking,
                  fontSize: 22.sp,
                  color: ColorUtils.white,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    color: ColorUtils.primary,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: ColorUtils.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelColor: ColorUtils.primary,
                        unselectedLabelColor: Colors.black87,
                        // indicatorColor:
                        //     // isDarkTheme ? ColorUtils.white :
                        //     ColorUtils.primary,
                        // labelColor:
                        //     // isDarkTheme ? ColorUtils.white :
                        //     ColorUtils.primary,
                        // unselectedLabelColor:
                        //     // isDarkTheme ? ColorUtils.white :
                        //     Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontUtils.cerebriSans,
                          fontSize: 14.sp,
                        ),
                        dividerColor: Colors.transparent,
                        tabs:
                            tabLabels.map((label) => Tab(text: label)).toList(),
                        onTap: (_) => setState(() {}),
                      ),
                    ),
                  ),
                ),
              ),

              body: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  checkInReservationList.isEmpty
                      ? const Center(
                        child: CustomText(
                          StringUtils.noPickUpToday,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                      : BookingList(bookingList: checkInReservationList),
                  checkOutReservationList.isEmpty
                      ? const Center(
                        child: CustomText(
                          StringUtils.noDropOffToday,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                      : BookingList(bookingList: checkOutReservationList),
                ],
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

class BookingList extends StatelessWidget {
  const BookingList({super.key, required this.bookingList});

  final List<BookingModel> bookingList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                ColorUtils.primary.withOpacity(0.25),
              ),
              dividerThickness: 0,
              columnSpacing: 24,
              horizontalMargin: 12,
              dataTextStyle: TextStyle(fontSize: 14.sp),
              headingTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
              showCheckboxColumn: false,
              columns: const [
                DataColumn(
                  label: CustomText(
                    StringUtils.userName,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.primary,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    StringUtils.bike,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.primary,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    StringUtils.pickUp,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.primary,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    StringUtils.drop,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.primary,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    StringUtils.amountPayable,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.primary,
                  ),
                ),
              ],
              rows:
                  bookingList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final booking = entry.value;
                    final isEvenRow = index % 2 == 0;

                    return DataRow(
                      onSelectChanged: (_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    BookingDetailsScreen(booking: booking),
                          ),
                        );
                      },
                      color: WidgetStateProperty.all(
                        isEvenRow ? Colors.white : Colors.grey[100]!,
                      ),
                      cells: [
                        DataCell(CustomText(booking.userFullName)),
                        DataCell(CustomText(booking.bikeName)),
                        DataCell(
                          CustomText(
                            DateFormat('yyyy-MM-dd').format(booking.pickupDate),
                          ),
                        ),
                        DataCell(
                          CustomText(
                            DateFormat(
                              'yyyy-MM-dd',
                            ).format(booking.dropoffDate),
                          ),
                        ),
                        DataCell(
                          CustomText(
                            '₹${booking.finalAmountPayable.toStringAsFixed(2)}',
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
