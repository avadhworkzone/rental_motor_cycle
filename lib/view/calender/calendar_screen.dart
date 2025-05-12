// ignore_for_file: use_build_context_synchronously

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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/blocs/book_bike/book_bike_home_bloc/book_bike_state.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/book_bike/booking_details_screen.dart';
import '../../blocs/bikes/bike_crud_bloc/bike_bloc.dart';
import '../../blocs/bikes/bike_crud_bloc/bike_event.dart';
import '../../blocs/book_bike/book_bike_home_bloc/book_bike_bloc.dart';
import '../../blocs/book_bike/book_bike_home_bloc/book_bike_event.dart';

const Duration paginationChunk = Duration(days: 180); // 6 months

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool isLoading = false;
  DateTime selectedMonth = DateTime.now();
  DateTime calenderCenterDate = DateTime.now();
  late ScrollController scrollController;
  List<DateTime> calenderDates = [];
  bool isDataLoad = false;
  late ScrollController dateHeaderController;
  late List<ScrollController> bookingRowControllers;
  bool _isSyncingScroll = false;
  final double cellWidth = 50.w + 1.w * 2;

  @override
  void initState() {
    super.initState();
    final initialOffset = ((calenderDates.length ~/ 2) * cellWidth);
    dateHeaderController = ScrollController(initialScrollOffset: initialOffset);
    initializeScreen();
  }

  Future<void> initializeScreen() async {
    setState(() => isLoading = true);
    //
    // await bikeController.fetchBikes();
    // await bikeBookingController.fetchBookings();
    context.read<BikeBloc>().add(FetchBikesEvent());
    context.read<BookBikeBloc>().add(FetchBookingsEvent());
    await Future.delayed(Duration(milliseconds: 500), () {
      setCalenderDates(isFromInit: true);
    });

    final initialOffset = ((calenderDates.length ~/ 2) * cellWidth);
    bookingRowControllers = List.generate(
      context.read<BikeBloc>().bikeLength,
      // bikeController.bikeList.length,
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
      logs("---Coming in IF");
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
      if (dateHeaderController.hasClients) {
        updateSelectedMonthFromScroll(dateHeaderController.offset);
      }
    });
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<BookBikeBloc, BookBikeState>(
      listenWhen: (prev, curr) => curr is BookBikeLoaded,
      listener: (context, state) {
        if (state is BookBikeLoaded) {
          final initialOffset = ((calenderDates.length ~/ 2) * cellWidth);
          bookingRowControllers = List.generate(
            state.bikes.length,
            (_) => ScrollController(initialScrollOffset: initialOffset),
          );
          setupScrollSync();
          if (mounted) setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: isDarkTheme ? Colors.black : Colors.white,

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
                    onTap: () {
                      onDateTap(isDarkTheme);
                    },
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
                    icon: Icon(
                      Icons.today,
                      size: 18.sp,
                      color: ColorUtils.primary,
                    ),
                    label: CustomText(
                      "Today",
                      fontSize: 14.sp,
                      color: ColorUtils.black21,
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
                : buildCalendarBody(isDarkTheme),
      ),
    );
  }

  Widget buildCalendarBody(bool isDarkTheme) {
    return Column(
      children: [
        SizedBox(height: 10.h),

        /// Horizontally scrollable Date Header
        SingleChildScrollView(
          controller: dateHeaderController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(calenderDates.length, (index) {
              final date = calenderDates[index];
              final now = DateTime.now();
              final isToday =
                  date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day;

              return Container(
                width: 50.w,
                height: 50.w,
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                decoration: BoxDecoration(
                  color:
                      isToday
                          ? ColorUtils.primary
                          : isDarkTheme
                          ? ColorUtils.darkGrey
                          : ColorUtils.greyDF,

                  // color: isToday ? ColorUtils.primary : ColorUtils.greyDF,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      DateFormat('E').format(date).substring(0, 2),
                      color:
                          isToday
                              ? ColorUtils.white
                              : isDarkTheme
                              ? ColorUtils.white
                              : ColorUtils.black21,
                      fontSize: 12.sp,
                    ),
                    CustomText(
                      DateFormat('dd').format(date),
                      fontSize: 15.sp,
                      color:
                          isToday
                              ? ColorUtils.white
                              : isDarkTheme
                              ? ColorUtils.white
                              : ColorUtils.black21,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        /// Booking rows vertically stacked
        BlocBuilder<BookBikeBloc, BookBikeState>(
          builder: (context, state) {
            logs("---state---$state");
            if (state is BookBikeLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is BookBikeLoaded) {
              final bikes = state.bikes;
              final bookings = state.bookings;
              logs("---bikes---${state.bikes}");
              logs("---bookings---${state.bookings}");
              if (bikes.isEmpty) {
                return SizedBox(
                  height: 550.h,
                  child: Center(
                    child: CustomText(
                      StringUtils.noBikesAddedYet,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return Expanded(
                child:
                    bikes.isEmpty
                        ? Center(
                          child: CustomText(
                            StringUtils.noBikesAddedYet,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        : ListView.builder(
                          itemCount: bikes.length,
                          itemBuilder: (context, index) {
                            final bike = bikes[index];
                            final controller =
                                (index < bookingRowControllers.length)
                                    ? bookingRowControllers[index]
                                    : ScrollController(); // fallback (optional)
                            if (bookingRowControllers.length != bikes.length) {
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
                                  child: Row(
                                    children: [
                                      CustomText(
                                        bike.brandName ?? '',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                      ),
                                      SizedBox(width: 5.w),
                                      CustomText(
                                        "(${bike.model ?? ''})",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ],
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
                                                horizontal: 1.w,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    isDarkTheme
                                                        ? ColorUtils.darkGrey
                                                        : ColorUtils.greyDF,
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      /// Booking Bars for this bike
                                      ...bookings
                                          .where((booking) {
                                            return booking.bikeId == bike.id;
                                          })
                                          .map((booking) {
                                            final startIndex = calenderDates
                                                .indexWhere(
                                                  (d) => isSameDay(
                                                    d,
                                                    booking.pickupDate,
                                                  ),
                                                );
                                            final endIndex = calenderDates
                                                .indexWhere(
                                                  (d) => isSameDay(
                                                    d,
                                                    booking.dropoffDate,
                                                  ),
                                                );
                                            final duration =
                                                endIndex - startIndex + 1;

                                            if (startIndex == -1 ||
                                                endIndex == -1) {
                                              return SizedBox.shrink();
                                            }

                                            return Positioned(
                                              left:
                                                  (startIndex * cellWidth) +
                                                  1.w,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              BookingDetailsScreen(
                                                                booking:
                                                                    booking,
                                                              ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width:
                                                      (duration * cellWidth) -
                                                      2.w,
                                                  height: 50.w,
                                                  alignment:
                                                      Alignment.centerRight,
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

                                                      color:
                                                          isDarkTheme
                                                              ? ColorUtils
                                                                  .black21
                                                              : ColorUtils
                                                                  .black21,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
              );
            }
            return SizedBox();
          },
        ),
      ],
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime chosenDateTime = DateTime.now();

  void onDateTap(bool isDarkTheme) {
    iosDatePicker(context, isDarkTheme);

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

  iosDatePicker(BuildContext context, bool isDarkTheme) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.35,
          color: isDarkTheme ? ColorUtils.darkThemeBg : ColorUtils.white,
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
                        Navigator.pop(context);
                      },
                      child: CustomText("CANCEL"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        selectedMonth = chosenDateTime;
                        calenderCenterDate = chosenDateTime;
                        calenderDates.clear();
                        setCalenderDates();
                      },
                      child: CustomText("OK"),
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
