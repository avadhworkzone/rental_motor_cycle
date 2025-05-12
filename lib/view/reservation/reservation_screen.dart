import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/iamge_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/reservation/reservation_card_view.dart';
import '../../blocs/bikes/bike_crud_bloc/bike_bloc.dart';
import '../../blocs/bikes/bike_crud_bloc/bike_event.dart';
import '../../blocs/book_bike/book_bike_home_bloc/book_bike_bloc.dart';
import '../../blocs/book_bike/book_bike_home_bloc/book_bike_event.dart';
import '../../blocs/book_bike/book_bike_home_bloc/book_bike_state.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = StringUtils.thisWeek;
  DateTimeRange? customRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    initMethod();
  }

  initMethod() async {
    context.read<BikeBloc>().add(FetchBikesEvent());
    context.read<BookBikeBloc>().add(FetchBookingsEvent());
  }

  List<BookingModel> getFilteredReservations(String type) {
    final now = DateTime.now();
    final all = context.read<BookBikeBloc>().bookingList;

    List<BookingModel> list =
        all.where((r) {
          final checkin = r.pickupDate; // already DateTime
          final checkout = r.dropoffDate; // already DateTime

          if (type == StringUtils.current) {
            return checkin.isBefore(now.add(Duration(days: 1))) &&
                checkout.isAfter(now.subtract(Duration(days: 1)));
          } else if (type == StringUtils.upcoming) {
            return checkin.isAfter(now);
          } else {
            return checkout.isBefore(now);
          }
        }).toList();

    // No filter for "Current"
    if (type == StringUtils.current) return list;

    // Apply filters only for Upcoming & History
    return list.where((r) {
      final checkin = r.pickupDate;
      switch (selectedFilter) {
        case StringUtils.thisWeek:
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(Duration(days: 6));
          return checkin.isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
              checkin.isBefore(endOfWeek.add(Duration(days: 1)));
        case StringUtils.thisMonth:
          return checkin.year == now.year && checkin.month == now.month;
        case StringUtils.custom:
          if (customRange == null) return true;
          return checkin.isAfter(
                customRange!.start.subtract(Duration(seconds: 1)),
              ) &&
              checkin.isBefore(customRange!.end.add(Duration(days: 1)));
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tabLabels = [
      StringUtils.current,
      StringUtils.upcoming,
      StringUtils.history,
    ];
    final currentTab = tabLabels[_tabController.index];
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,

      appBar: AppBar(
        backgroundColor: ColorUtils.primary,
        title: CustomText(
          StringUtils.reservations,
          fontSize: 22.sp,
          color: ColorUtils.white,
          fontWeight: FontWeight.bold,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ColorUtils.white,
          labelColor: ColorUtils.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            fontFamily: FontUtils.cerebriSans,
          ), // Selected tab bold
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: FontUtils.cerebriSans,
            fontSize: 16.sp,
          ),
          tabs: tabLabels.map((label) => Tab(text: label)).toList(),
        ),
      ),
      body: Column(
        children: [
          if (currentTab != StringUtils.current)
            Padding(
              padding: EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip(StringUtils.thisWeek),
                  _buildFilterChip(StringUtils.thisMonth),
                  _buildFilterChip(StringUtils.custom),
                ],
              ),
            ),
          BlocBuilder<BookBikeBloc, BookBikeState>(
            builder: (context, state) {
              if (state is BookBikeLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is BookBikeLoaded) {
                final bikes = state.bikes;
                final filteredList = getFilteredReservations(currentTab);

                if (filteredList.isEmpty) {
                  return SizedBox(
                    height: 600.h,
                    child: Center(
                      child: CustomText(
                        StringUtils.noReservationsFound,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final reservation = filteredList[index];
                      // Match the bike by bikeId
                      BikeModel? matchingBike;
                      try {
                        matchingBike = bikes.firstWhere(
                          (bike) => bike.id == reservation.bikeId,
                        );
                      } catch (e) {
                        matchingBike = null;
                      }

                      return ReservationCardView(
                        booking: reservation,
                        canEditDelete: currentTab != StringUtils.history,
                        bike:
                            matchingBike ??
                            BikeModel(
                              id: -1,
                              brandName: "Unknown",
                              model: "N/A",
                              numberPlate: "N/A",
                              location: "N/A",
                              fuelType: "N/A",
                              engineCC: 0,
                              description: "Bike not found",
                              imageUrl: "",
                              userId: -1,
                              createdAt: DateTime.now(),
                              kmLimit: 0,
                              makeYear: 0,
                              transmission: "N/A",
                              seater: 1,
                              fuelIncluded: "N/A",
                            ),

                        isFromToday: false,
                      );
                    },
                  ),
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return ChoiceChip(
      backgroundColor: ColorUtils.primary.withValues(alpha: 0.15),
      label: CustomText(label),
      selected: selectedFilter == label,
      onSelected: (selected) async {
        if (label == StringUtils.custom && selected) {
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2025),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            setState(() {
              customRange = picked;
              selectedFilter = label;
            });
          }
        } else {
          setState(() {
            selectedFilter = label;
            if (label != StringUtils.custom) customRange = null;
          });
        }
      },
    );
  }
}
