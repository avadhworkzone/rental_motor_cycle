import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/controller/badge_controller.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/calender/calendar_screen.dart';
import 'package:rental_motor_cycle/view/book_bike/book_bike_screen.dart';
import 'package:rental_motor_cycle/view/reservation/reservation_screen.dart';
import 'package:rental_motor_cycle/view/setting/settings_screen.dart';
import 'package:rental_motor_cycle/view/today/today_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  RxInt currentIndex = 0.obs;
  final screens = [
    CalendarScreen(),
    // MyBikesScreen(),
    TodayScreen(),
    BookBikeScreen(),
    ReservationScreen(),
    SettingsScreen(),
  ];

  final BadgeController badgeController = Get.find<BadgeController>();

  void clearBadge(int index) {
    switch (index) {
      case 0:
        badgeController.calendarBadge.value = 0;
        break;
      case 1:
        badgeController.roomsBadge.value = 0;
        break;
      case 2:
        badgeController.reservationsBadge.value = 0;
        break;
      case 3:
        badgeController.usersBadge.value = 0;
        break;
      case 4:
        badgeController.settingsBadge.value = 0;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      // extendBody: false, // Removes floating bottom bar
      // appBar: AppBar(
      //   backgroundColor: ColorUtils.primary,
      //   leading: Icon(
      //     Icons.calendar_month,
      //     size: 30.sp,
      //     color: ColorUtils.white,
      //   ),
      //
      //   // ✅ Replace with your logo
      //   title: CustomText(
      //     StringUtils.calendar,
      //     color: ColorUtils.white,
      //     fontWeight: FontWeight.bold,
      //     fontSize: 22.sp,
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.search, color: ColorUtils.white),
      //       onPressed: () {
      //         // Get.to(()=>SearchReservation());
      //         //  showSearch(context: context, delegate: DataSearch());
      //       },
      //     ),
      //   ],
      // ),
      body: Obx(() => screens[currentIndex.value]),
      bottomNavigationBar: Obx(
        () => SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: isDarkTheme ? ColorUtils.darkThemeBg : ColorUtils.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) => _buildNavItem(index)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    List<IconData> icons = [
      Icons.calendar_today_rounded,
      // Icons.pedal_bike,
      Icons.today,
      Icons.event_note_outlined,

      Icons.book_online_outlined,
      Icons.settings,
    ];
    List<String> labels = [
      StringUtils.calendar,
      // StringUtils.myBikes,
      StringUtils.today,
      StringUtils.bookBike,

      StringUtils.reservation,
      StringUtils.settings,
    ];

    return GestureDetector(
      onTap: () {
        currentIndex.value = index;
        clearBadge(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
        decoration: BoxDecoration(
          color:
              currentIndex.value == index
                  ? ColorUtils.primary.withOpacity(0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icons[index],
              size: currentIndex.value == index ? 28.sp : 24.sp,
              color:
                  isDarkTheme
                      ? ColorUtils.white
                      : currentIndex.value == index
                      ? ColorUtils.primary
                      : ColorUtils.darkBlue35,
            ),
            SizedBox(height: 4.h),
            CustomText(
              labels[index],
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color:
                  isDarkTheme
                      ? ColorUtils.white
                      : currentIndex.value == index
                      ? ColorUtils.primary
                      : ColorUtils.darkBlue35,
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Search Feature with Improved UI
class DataSearch extends SearchDelegate<String> {
  final List<String> searchItems = [
    "User 1",
    "User 2",
    "Room 101",
    "Room 102",
    "Reservation A",
    "Reservation B",
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Colors.black),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => close(context, ""),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: CustomText("Result: $query", color: Colors.black, fontSize: 18.sp),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        searchItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder:
          (context, index) => ListTile(
            leading: Icon(Icons.search, color: Colors.black),
            title: CustomText(suggestions[index], color: Colors.black),
            onTap: () => query = suggestions[index],
          ),
    );
  }
}
