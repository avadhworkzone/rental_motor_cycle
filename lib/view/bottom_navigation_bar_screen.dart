/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/controller/badge_controller.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/calendar_screen.dart';
import 'package:rental_motor_cycle/view/book_bike_screen.dart';
import 'package:rental_motor_cycle/view/my_bike_screen.dart';
import 'package:rental_motor_cycle/view/settings_screen.dart';
import 'package:rental_motor_cycle/view/user_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int currentIndex = 0;
  final screens = [
    CalendarScreen(),
    RoomScreen(),
    ReservationScreen(),
    UserScreen(),
    SettingsScreen(),
  ];

  final BadgeController badgeController = Get.find<BadgeController>();

  /// Clear badge count for the selected screen when tapped
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
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        leading: Icon(
          Icons.calendar_month,
          size: 25.sp,
          color: ColorUtils.darkBlue35,
        ),
        title: CustomText(
          StringUtils.rentalMotorCycle,
          fontSize: 18.sp,
          color: ColorUtils.darkBlue35,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: ColorUtils.darkBlue35),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
        ],
      ),
      body: screens[currentIndex],

      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
              clearBadge(index);
            });
          },
          destinations: [
            _buildNavItem(
              Icons.calendar_today_rounded,
              StringUtils.calendar,
              badgeController.calendarBadge.value,
            ),
            _buildNavItem(
              Icons.pedal_bike,
              StringUtils.myBikes,
              badgeController.roomsBadge.value,
            ),
            _buildNavItem(
              Icons.event_note_outlined,
              StringUtils.bookBike,
              badgeController.reservationsBadge.value,
            ),
            _buildNavItem(
              Icons.person,
              StringUtils.users,
              badgeController.usersBadge.value,
            ),
            _buildNavItem(
              Icons.settings,
              StringUtils.settings,
              badgeController.settingsBadge.value,
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Modern **Navigation Bar Item with Notification Badges**
  NavigationDestination _buildNavItem(
    IconData icon,
    String label,
    int badgeCount,
  ) {
    return NavigationDestination(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, size: 28.sp, color: ColorUtils.darkBlue35),
          // if (badgeCount > 0)
          //   Positioned(
          //     right: -2,
          //     top: -2,
          //     child: Container(
          //       padding: EdgeInsets.all(4),
          //       decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          //       constraints: BoxConstraints(minWidth: 18, minHeight: 18),
          //       child: Text(
          //         badgeCount > 99 ? "99+" : badgeCount.toString(),
          //         style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          //         textAlign: TextAlign.center,
          //       ),
          //     ),
          //   ),
        ],
      ),
      label: label,
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
}*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/controller/badge_controller.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/calendar_screen.dart';
import 'package:rental_motor_cycle/view/book_bike/book_bike_screen.dart';
import 'package:rental_motor_cycle/view/my_bike/my_bike_screen.dart';
import 'package:rental_motor_cycle/view/new_book_bike_screen.dart';
import 'package:rental_motor_cycle/view/settings_screen.dart';
import 'package:rental_motor_cycle/view/user_screen.dart';

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
    MyBikesScreen(),
    NewBookBikeScreen(),
    EmployeesScreen(),
    SettingsScreen(),
  ];
  void navigateToScreen(int index) {
    List<String> routes = [
      AppRoutes.calendarScreen,
      AppRoutes.myBikesScreen,
      AppRoutes.bookBikeScreen,
      AppRoutes.userScreen,
      AppRoutes.settingsScreen,
    ];

    if (currentIndex.value != index) {
      Get.offNamed(routes[index]);
      currentIndex.value = index;
      clearBadge(index);
    }
  }

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
    return Scaffold(
      body: Obx(() => screens[currentIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
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
    );
  }

  Widget _buildNavItem(int index) {
    List<IconData> icons = [
      Icons.calendar_today_rounded,
      Icons.pedal_bike,
      Icons.event_note_outlined,
      Icons.person,
      Icons.settings,
    ];
    List<String> labels = [
      StringUtils.calendar,
      StringUtils.myBikes,
      StringUtils.bookBike,
      StringUtils.users,
      StringUtils.settings,
    ];

    return GestureDetector(
      onTap: () {
        currentIndex.value = index;
        clearBadge(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
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
              size: currentIndex.value == index ? 30.sp : 24.sp,
              color:
                  currentIndex.value == index
                      ? ColorUtils.primary
                      : ColorUtils.darkBlue35,
            ),
            SizedBox(height: 4.h),
            Text(
              labels[index],
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color:
                    currentIndex.value == index
                        ? ColorUtils.primary
                        : ColorUtils.darkBlue35,
              ),
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
