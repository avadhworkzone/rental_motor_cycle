/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/book_bike/booking_details_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/bike_booking_controller.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // final ScrollController _scrollController = ScrollController();
  late final ScrollController _scrollController;

  late Worker _reservationListener;

  final List<DateTime> _allDates = [];
  final Map<DateTime, List<BookingModel>> _eventsMap = {};
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final index = _allDates.indexWhere((date) => isSameDay(date, today));

    // Calculate the initial offset BEFORE the first build
    final initialOffset = index != -1 ? (index * 118.w).toDouble() : 0.0;

    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    // _scrollController.addListener(_onScroll);
    // _loadInitialDates();
    _selectedDay = today;
    _loadEvents();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _jumpToToday();
    // });

    // Listen to booking changes
    _reservationListener = ever(Get.find<BikeBookingController>().bookingList, (
      _,
    ) {
      if (mounted) _loadEvents();
    });

    // Initial load
    _loadEvents();
  }

  @override
  void dispose() {
    _reservationListener.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialDates() {
    final today = DateTime.now();
    for (int i = -3; i <= 2; i++) {
      _allDates.add(DateTime(today.year, today.month + i, 1));
    }
    _generateAllDays();
  }

  void _generateAllDays() {
    List<DateTime> expandedDates = [];
    for (var monthStart in _allDates) {
      final daysInMonth = DateUtils.getDaysInMonth(
        monthStart.year,
        monthStart.month,
      );
      for (int i = 0; i < daysInMonth; i++) {
        expandedDates.add(DateTime(monthStart.year, monthStart.month, i + 1));
      }
    }
    _allDates.clear();
    _allDates.addAll(expandedDates);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadMoreMonths();
    }
  }

  void _loadMoreMonths() {
    final lastDate = _allDates.last;
    final nextMonth = DateTime(lastDate.year, lastDate.month + 1, 1);
    final daysInNextMonth = DateUtils.getDaysInMonth(
      nextMonth.year,
      nextMonth.month,
    );
    for (int i = 0; i < daysInNextMonth; i++) {
      _allDates.add(DateTime(nextMonth.year, nextMonth.month, i + 1));
    }
    setState(() {});
  }

  void _jumpToToday() {
    final index = _allDates.indexWhere(
      (d) =>
          d.year == DateTime.now().year &&
          d.month == DateTime.now().month &&
          d.day == DateTime.now().day,
    );
    if (index != -1) {
      _scrollController.jumpTo(
        index * 117.8.w,
        // duration: const Duration(milliseconds: 300),
        // curve: Curves.easeInOut,
      );
    }
  }

  void _loadEvents() {
    if (!mounted) return;
    _eventsMap.clear();
    for (var res in Get.find<BikeBookingController>().bookingList) {
      final pickupDate = DateTime(
        res.pickupDate.year,
        res.pickupDate.month,
        res.pickupDate.day,
      );
      if (_eventsMap.containsKey(pickupDate)) {
        _eventsMap[pickupDate]!.add(res);
      } else {
        _eventsMap[pickupDate] = [res];
      }
    }
    setState(() {});
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
      body: ListView.builder(
        itemCount: _allDates.length,
        shrinkWrap: true,
        controller: _scrollController,
        itemBuilder: (context, index) {
          final currentDate = _allDates[index];
          final normalizedDate = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
          );
          final isSelected = isSameDay(currentDate, _selectedDay);
          final bookings = _eventsMap[normalizedDate] ?? [];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = currentDate;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 12.w,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? ColorUtils.primary : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  width: 80.w,
                  child: Column(
                    children: [
                      CustomText(
                        DateFormat('MMM').format(currentDate),
                        fontSize: 14.sp,
                        color: isSelected ? ColorUtils.white : ColorUtils.black,
                      ),
                      CustomText(
                        DateFormat('dd').format(currentDate),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? ColorUtils.white : Colors.black,
                      ),
                      CustomText(
                        DateFormat('yyyy').format(currentDate),
                        fontSize: 14.sp,
                        color: isSelected ? ColorUtils.white : Colors.black54,
                      ),
                      SizedBox(height: 6.h),
                      if (bookings.isNotEmpty)
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 3.w,
                          children: List.generate(
                            bookings.length > 4 ? 4 : bookings.length,
                            (i) => Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  child:
                      bookings.isEmpty
                          ? Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 30.h, left: 15.w),
                              child: CustomText(
                                StringUtils.noBookingAvailableForTheDay,
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                          )
                          : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  bookings.map((booking) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => BookingDetailsScreen(
                                            booking: booking,
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 4,
                                        margin: EdgeInsets.only(
                                          left: 10.w,
                                          right: 10.w,
                                          bottom: 10.h,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    booking
                                                            .userFullName
                                                            .capitalizeFirst ??
                                                        "",
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.h),
                                              _buildInfoRow(
                                                Icons.phone,
                                                "${StringUtils.phone}: ${booking.userPhone}",
                                              ),
                                              _buildInfoRow(
                                                Icons.email,
                                                "${StringUtils.email}: ${booking.userEmail}",
                                              ),
                                              SizedBox(height: 8.h),
                                              Divider(
                                                thickness: 1,
                                                height: 16.h,
                                              ),
                                              _buildPriceRow(
                                                StringUtils.totalRent,
                                                booking.totalRent
                                                    .toStringAsFixed(2),
                                                isBold: true,
                                              ),
                                              _buildPriceRow(
                                                StringUtils.deposit,
                                                booking.prepayment
                                                    .toStringAsFixed(2),
                                                isBold: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey),
        SizedBox(width: 6.w),
        CustomText(text, fontSize: 14.sp),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText("$label:", fontSize: 14.sp),
        SizedBox(width: 5.w),
        CustomText(
          "₹$value",
          fontSize: 14.sp,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ],
    );
  }
}
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/controller/bike_booking_controller.dart';
import 'package:rental_motor_cycle/controller/bike_controller.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/book_bike/booking_details_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

const Duration paginationChunk = Duration(days: 180); // 6 months

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final BikeBookingController bikeBookingController = Get.find();
  final BikeController bikeController = Get.find();
  // late Worker _reservationListener;
  bool isLoading = true;
  DateTime selectedMonth = DateTime.now();
  DateTime calenderCenterDate = DateTime.now();
  late ScrollController scrollController;
  List<DateTime> calenderDates = [];
  bool isDataLoad = false;
  late ScrollController dateHeaderController;
  // late ScrollController bookingGridController;
  late List<ScrollController> bookingRowControllers;
  bool _isSyncingScroll = false;
  final double cellWidth =
      50.w + 2.5.w * 2; // Cell width + margin on both sides

  @override
  void initState() {
    super.initState();
    final initialOffset = ((calenderDates.length ~/ 2) * cellWidth);
    dateHeaderController = ScrollController(initialScrollOffset: initialOffset);
    initializeScreen();
  }

  Future<void> initializeScreen() async {
    setState(() => isLoading = true);

    await bikeController.fetchBikes();
    await bikeBookingController.fetchBookings();

    await Future.delayed(Duration(milliseconds: 500), () {
      setCalenderDates(isFromInit: true);
    });

    final initialOffset = ((calenderDates.length ~/ 2) * cellWidth);
    bookingRowControllers = List.generate(
      bikeController.bikeList.length,
      (_) => ScrollController(initialScrollOffset: initialOffset),
    );

    setupScrollSync();

    if (mounted) setState(() => isLoading = false);
  }

  void setupScrollSync() {
    dateHeaderController.addListener(() {
      if (_isSyncingScroll) return;
      _isSyncingScroll = true;

      final offset = dateHeaderController.offset;
      updateSelectedMonthFromScroll(offset); // ✅ Add this line

      for (final controller in bookingRowControllers) {
        if (controller.hasClients && controller.offset != offset) {
          controller.jumpTo(offset);
        }
      }

      _isSyncingScroll = false;
    });

    for (final controller in bookingRowControllers) {
      controller.addListener(() {
        if (_isSyncingScroll) return;
        _isSyncingScroll = true;

        final offset = controller.offset;
        updateSelectedMonthFromScroll(offset); // ✅ Add this line

        if (dateHeaderController.hasClients &&
            dateHeaderController.offset != offset) {
          dateHeaderController.jumpTo(offset);
        }

        for (final other in bookingRowControllers) {
          if (other != controller &&
              other.hasClients &&
              other.offset != offset) {
            other.jumpTo(offset);
          }
        }

        _isSyncingScroll = false;
      });
    }
  }

  @override
  void dispose() {
    dateHeaderController.dispose();
    for (final controller in bookingRowControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void listenScrollController() {
    dateHeaderController.addListener(() {
      if (_isSyncingScroll) return;

      final offset = dateHeaderController.offset;
      updateSelectedMonthFromScroll(offset);

      if (offset <= 0 && !isDataLoad) {
        isDataLoad = true;
        setBeforeDates(isFromListen: true);
      } else if (offset >=
              dateHeaderController.position.maxScrollExtent - 200 &&
          !isDataLoad) {
        isDataLoad = true;
        setAfterDates(isFromListen: true);
      }
    });
  }

  void setCalenderDates({bool isFromInit = false}) {
    final now = calenderCenterDate;
    if (isFromInit) {
      listenScrollController();
    }

    final oldDates = List.generate(
      paginationChunk.inDays,
      (index) => now.subtract(Duration(days: index)),
    );
    calenderDates.addAll(oldDates.reversed);

    final newDates = List.generate(
      paginationChunk.inDays,
      (index) => now.add(Duration(days: index + 1)),
    );
    calenderDates.addAll(newDates);

    final initialOffset = ((calenderDates.length ~/ 2) * cellWidth) - 60.0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dateHeaderController.jumpTo(initialOffset);
      for (final controller in bookingRowControllers) {
        controller.jumpTo(initialOffset);
      }
      updateSelectedMonthFromScroll(initialOffset);
    });

    dateHeaderController.addListener(() {
      if (_isSyncingScroll) return;

      _isSyncingScroll = true;

      for (final controller in bookingRowControllers) {
        if (controller.hasClients &&
            controller.offset != dateHeaderController.offset) {
          controller.jumpTo(dateHeaderController.offset);
        }
      }

      final offset = dateHeaderController.offset;
      if (offset <= 0 && !isDataLoad) {
        isDataLoad = true;
        setBeforeDates(isFromListen: true);
      } else if (dateHeaderController.hasClients &&
          offset >=
              dateHeaderController.position.maxScrollExtent -
                  200 && // preload buffer
          !isDataLoad) {
        isDataLoad = true;
        setAfterDates(isFromListen: true);
      }

      _isSyncingScroll = false;
    });

    if (isFromInit) {}

    setState(() {});
  }

  void setBeforeDates({bool isFromListen = false}) {
    final startDate = calenderDates.first.subtract(Duration(days: 1));

    final oldDates = List.generate(
      paginationChunk.inDays,
      (index) => startDate.subtract(Duration(days: index)),
    );

    calenderDates.insertAll(0, oldDates.reversed);
    listenScrollController();
    setState(() {});

    if (isFromListen) {
      final jumpOffset = paginationChunk.inDays * cellWidth;
      dateHeaderController.jumpTo(jumpOffset);
      for (final controller in bookingRowControllers) {
        controller.jumpTo(jumpOffset);
      }

      Future.delayed(const Duration(seconds: 2), () => isDataLoad = false);
    } else {
      final offset =
          dateHeaderController.offset + (paginationChunk.inDays * 50.0);
      dateHeaderController.jumpTo(offset);
      for (final controller in bookingRowControllers) {
        controller.jumpTo(offset);
      }
    }
  }

  void setAfterDates({bool isFromListen = false}) {
    final startDate = calenderDates.last.add(Duration(days: 1));

    final newDates = List.generate(
      paginationChunk.inDays,
      (index) => startDate.add(Duration(days: index)),
    );

    calenderDates.addAll(newDates);
    setState(() {});

    if (isFromListen) {
      Future.delayed(const Duration(seconds: 2), () => isDataLoad = false);
    }
  }

  void scrollToToday() {
    final todayIndex = calenderDates.indexWhere(
      (date) =>
          DateFormat("dd-MM-yyyy").format(date) ==
          DateFormat("dd-MM-yyyy").format(DateTime.now()),
    );

    if (todayIndex != -1) {
      final scrollOffset = todayIndex * cellWidth;
      dateHeaderController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      for (final controller in bookingRowControllers) {
        controller.animateTo(
          scrollOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else {
      calenderDates.clear();
      calenderCenterDate = DateTime.now();
      setCalenderDates();
    }
  }

  void updateSelectedMonthFromScroll(double offset) {
    final screenWidth = MediaQuery.of(context).size.width;
    final centerOffset = offset + screenWidth / 2;
    final index = (centerOffset / cellWidth).floor();

    if (index >= 0 && index < calenderDates.length) {
      final date = calenderDates[index];

      if (selectedMonth.month != date.month ||
          selectedMonth.year != date.year) {
        setState(() {
          selectedMonth = DateTime(date.year, date.month);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateSelectedMonthFromScroll(dateHeaderController.offset);
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100.h,
        backgroundColor: ColorUtils.primary,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Title and Month/Year
                GestureDetector(
                  onTap: onDateTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        StringUtils.calendar,
                        fontSize: 22.sp,
                        color: ColorUtils.white,
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 16.sp,
                            color: ColorUtils.white,
                          ),
                          SizedBox(width: 4.w),
                          CustomText(
                            DateFormat('MMMM yyyy').format(selectedMonth),
                            fontSize: 14.sp,
                            color: ColorUtils.white,
                            fontWeight: FontWeight.w500,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18.sp,
                            color: ColorUtils.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right: Go to Today button
                ElevatedButton.icon(
                  onPressed: scrollToToday,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    elevation: 3,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon: Icon(Icons.today, size: 18.sp),
                  label: CustomText(
                    "Today",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : buildCalendarBody(),
    );
  }

  Widget buildCalendarBody() {
    return Column(
      children: [
        SizedBox(height: 10.h),
        // Horizontally scrollable Date Header
        SingleChildScrollView(
          controller: dateHeaderController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(calenderDates.length, (index) {
              final date = calenderDates[index];
              return Container(
                width: 50.w,
                height: 50.w,
                margin: EdgeInsets.symmetric(horizontal: 2.5.w),
                decoration: BoxDecoration(color: ColorUtils.greyD6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CustomText(
                    //   DateFormat('MMM').format(date), // Month (e.g., Apr)
                    //   fontSize: 12.sp,
                    // ),
                    // CustomText(
                    //   DateFormat('yyyy').format(date), // Year (e.g., 2025)
                    //   fontSize: 10.sp,
                    // ),
                    CustomText(
                      DateFormat('E').format(date).substring(0, 2),
                      fontSize: 12.sp,
                    ),
                    CustomText(
                      DateFormat('dd').format(date), // Day (e.g., 08)
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        // Booking rows vertically stacked
        Expanded(
          child:
              bikeController.bikeList.isEmpty
                  ? Center(
                    child: CustomText(
                      StringUtils.noBikesAddedYet,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                  : ListView.builder(
                    itemCount: bikeController.bikeList.length,
                    itemBuilder: (context, index) {
                      final bike = bikeController.bikeList[index];
                      final controller =
                          (index < bookingRowControllers.length)
                              ? bookingRowControllers[index]
                              : ScrollController(); // fallback (optional)
                      if (bookingRowControllers.length !=
                          bikeController.bikeList.length) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bike name (fixed)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 5.w,
                            ),
                            child: CustomText(
                              bike.name ?? '',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          ),

                          // Scrollable Booking Grid
                          SingleChildScrollView(
                            controller: controller,
                            scrollDirection: Axis.horizontal,
                            child: Stack(
                              children: [
                                // Grid Background Cells
                                Row(
                                  children: List.generate(
                                    calenderDates.length,
                                    (dateIndex) {
                                      return Container(
                                        width: 50.w,
                                        height: 50.w,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 2.5.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorUtils.greyD6,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                /// Booking Bars for this bike
                                ...bikeBookingController.bookingList
                                    .where((booking) {
                                      return booking.bikeName == bike.name;
                                    })
                                    .map((booking) {
                                      final startIndex = calenderDates
                                          .indexWhere(
                                            (d) => isSameDay(
                                              d,
                                              booking.pickupDate,
                                            ),
                                          );
                                      final endIndex = calenderDates.indexWhere(
                                        (d) =>
                                            isSameDay(d, booking.dropoffDate),
                                      );
                                      final duration =
                                          endIndex - startIndex + 1;

                                      if (startIndex == -1 || endIndex == -1) {
                                        return SizedBox.shrink();
                                      }

                                      return Positioned(
                                        left: startIndex * cellWidth,
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(
                                              () => BookingDetailsScreen(
                                                booking: booking,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: duration * cellWidth,
                                            height: 50.w,
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFC9A5),
                                            ),
                                            child: Center(
                                              child: CustomText(
                                                booking.userFullName,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                      /*              return Positioned(
                                        left: startIndex * cellWidth,
                                        child: ClipPath(
                                          clipper: ParallelogramClipper(),
                                          child: Container(
                                            width: duration * cellWidth,
                                            height: 50.w,
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                            ),
                                            color: const Color(0xFFFFC9A5),
                                            child: Center(
                                              child: CustomText(
                                                booking.userFullName,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );*/
                                    }),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
        ),
      ],
    );
  }

  ///Dinesh Sir design Working code
  /*Widget buildCalendarBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          Obx(() {
            logs(
              "-----bookingList.length----${bikeBookingController.bookingList.length}",
            );
            return SizedBox(
              width: Get.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Sidebar with Month + Room Names
                  SizedBox(
                    width: 130.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 50.h),
                        Column(
                          children:
                              bikeController.bikeList.map((e) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: ColorUtils.white,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(StringUtils.bike),
                                            ListTile(
                                              title: Text(
                                                e.name ?? "",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              // subtitle: Text("Room ID: ${room.id}\n${room.roomDesc}"),
                                              subtitle: CustomText(
                                                e.model ?? "",
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: ColorUtils.primary,
                                                    ),
                                                    onPressed: () {
                                                      // Get.back();
                                                      // addEditRoomBottomSheet(
                                                      //   room: e,
                                                      // );
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: ColorUtils.red,
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                      confirmDelete(e.id!);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 50.h,
                                    margin: EdgeInsets.fromLTRB(2, 0, 2, 2),
                                    decoration: BoxDecoration(
                                      color: ColorUtils.primary,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        e.name ?? "",
                                        fontSize: 20.sp,
                                        color: ColorUtils.white,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),

                  /// Calendar Grid
                  Expanded(
                    child: SizedBox(
                      height: (bikeController.bikeList.length + 1) * 51.5,
                      width: Get.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: scrollController,
                        child: Stack(
                          children: [
                            /// Calendar Day Headers + Grid
                            Row(
                              children: List.generate(calenderDates.length, (
                                index,
                              ) {
                                bool isCurrentDate =
                                    DateFormat(
                                      "dd-MM-yyyy",
                                    ).format(calenderDates[index]) ==
                                    DateFormat(
                                      "dd-MM-yyyy",
                                    ).format(DateTime.now());

                                return VisibilityDetector(
                                  key: ValueKey(
                                    calenderDates[index].millisecondsSinceEpoch,
                                  ),
                                  onVisibilityChanged: (info) {
                                    if (info.visibleFraction == 1.0 &&
                                        DateFormat(
                                              "MM-yyyy",
                                            ).format(selectedMonth) !=
                                            DateFormat(
                                              "MM-yyyy",
                                            ).format(calenderDates[index])) {
                                      setState(
                                        () =>
                                            selectedMonth =
                                                calenderDates[index],
                                      );
                                      if (calenderDates[index].isAfter(
                                        calenderCenterDate,
                                      )) {
                                        setAfterDates();
                                      } else {
                                        setBeforeDates();
                                      }
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 51.5,
                                        width: 50,
                                        child: Column(
                                          children: [
                                            Text("${calenderDates[index].day}"),
                                            Text(
                                              DateFormat("EEE")
                                                  .format(calenderDates[index])
                                                  .substring(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Column(
                                              children:
                                                  bikeController.bikeList.map((
                                                    e,
                                                  ) {
                                                    return InkWell(
                                                      onTap: () async {
                                                        // await addEditReservationBottomSheet();
                                                      },
                                                      child: Container(
                                                        height: 51.5,
                                                        width: 50,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: ColorUtils
                                                                .grey99
                                                                .withValues(
                                                                  alpha: 0.3,
                                                                ),
                                                            width: 0.4,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                                            if (isCurrentDate)
                                              Center(
                                                child: SizedBox(
                                                  height:
                                                      bikeController
                                                          .bikeList
                                                          .length *
                                                      51.5,
                                                  width: 50,
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: VerticalDivider(
                                                          color:
                                                              ColorUtils
                                                                  .primary,
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 5,
                                                                left: 1,
                                                              ),
                                                          child: CircleAvatar(
                                                            radius: 6,
                                                            backgroundColor:
                                                                ColorUtils
                                                                    .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),

                            /// Reservation Bars
                            for (
                              int i = 0;
                              i < bikeBookingController.bookingList.length;
                              i++
                            )
                              Builder(
                                builder: (context) {
                                  final booking =
                                      bikeBookingController.bookingList[i];
                                  if (booking.bikeId == 0) {
                                    return SizedBox();
                                  }

                                  final inDays =
                                      booking.dropoffDate
                                          .difference(booking.pickupDate)
                                          .inDays;
                                  logs("-----inDays----$inDays");

                                  final containIndex = calenderDates.indexWhere(
                                    (date) =>
                                        DateFormat("yyyy-MM-dd").format(date) ==
                                        DateFormat(
                                          "yyyy-MM-dd",
                                        ).format(booking.pickupDate),
                                  );

                                  if (containIndex == -1) {
                                    return SizedBox();
                                  }

                                  final roomIdIndex = bikeController.bikeList
                                      .indexWhere(
                                        (room) => room.id == booking.bikeId,
                                      );
                                  return Positioned(
                                    top: ((roomIdIndex + 1) * 51.5) + 2.5,
                                    left: (containIndex * 50),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => BookingDetailsScreen(
                                            booking: booking,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 45.h,
                                        width: ((inDays + 1) * 50.w),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            50.r,
                                          ),
                                        ),
                                        child: Center(
                                          child: Container(
                                            height: 45.h,
                                            width: (inDays * 50.w),
                                            decoration: BoxDecoration(
                                              color: CommonMethod()
                                                  .reservationColor(booking),
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                            ),
                                            child: Center(
                                              child: CustomText(
                                                booking.userFullName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                color:
                                                    booking.prepayment == 0
                                                        ? ColorUtils.black
                                                        : ColorUtils.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }*/
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime chosenDateTime = DateTime.now();

  void onDateTap() {
    iosDatePicker(context);

    // if (Platform.isIOS) {
    //   iosDatePicker(context);
    // } else {
    //   androidDatePicker(context);
    // }
  }

  androidDatePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      chosenDateTime = date;
    }
  }

  iosDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.35,
          color: ColorUtils.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.monthYear,
                  onDateTimeChanged: (value) {
                    chosenDateTime = value;
                  },
                  initialDateTime: DateTime.now(),
                  minimumYear: DateTime.now().year - 50,
                  maximumYear: DateTime.now().year + 50,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("CANCEL"),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        selectedMonth = chosenDateTime;
                        calenderCenterDate = chosenDateTime;
                        calenderDates.clear();
                        setCalenderDates();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void confirmDelete(int id) {
    // Get.defaultDialog(
    //   title: StringUtils.deleteRoomTitle,
    //   middleText: StringUtils.deleteRoomMessage,
    //   textConfirm: StringUtils.delete,
    //   textCancel: StringUtils.cancel,
    //   confirmTextColor: Colors.white,
    //   onConfirm: () async {
    //     // isProcessing.value = true; // ✅ Prevent multiple clicks
    //     await Future.delayed(Duration(milliseconds: 300)); // ✅ Delay execution
    //     await Get.find<RoomController>().deleteRoom(id);
    //     await Get.find<RoomController>()
    //         .fetchRooms(); // ✅ Refresh list after delete
    //     // isProcessing.value = false;
    //     Get.back();
    //   },
    // );
  }
}

class CommonMethod {
  MaterialColor reservationColor(BookingModel bookingModel) =>
      bookingModel.prepayment == 0
          ? Colors.yellow
          : bookingModel.prepayment > 0
          ? Colors.green
          : Colors.orange;
}

/*class SlantedBox extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const SlantedBox({
    Key? key,
    required this.color,
    this.width = 100,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ParallelogramClipper(),
      child: Container(width: width, height: height, color: color),
    );
  }
}

class ParallelogramClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double slant = 20; // how slanted you want it
    final path = Path();
    path.moveTo(slant, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - slant, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}*/
