import 'package:get/get.dart';
import 'package:rental_motor_cycle/view/book_bike/book_bike_screen.dart';
import 'package:rental_motor_cycle/view/book_bike/select_date_time_for_booking_screen.dart';
import 'package:rental_motor_cycle/view/bottom_navigation_bar_screen.dart';
import 'package:rental_motor_cycle/view/calendar_screen.dart';
import 'package:rental_motor_cycle/view/login_screen.dart';
import 'package:rental_motor_cycle/view/my_bike/bike_details_screen.dart';
import 'package:rental_motor_cycle/view/my_bike/my_bike_screen.dart';
import 'package:rental_motor_cycle/view/new_book_bike_screen.dart';
import 'package:rental_motor_cycle/view/settings_screen.dart';
import 'package:rental_motor_cycle/view/signup_screen.dart';
import 'package:rental_motor_cycle/view/splash_screen.dart';
import 'package:rental_motor_cycle/view/today/today_screen.dart';
import 'package:rental_motor_cycle/view/user_screen.dart';

import '../view/on_boarding_screen.dart';
import 'app_page.dart';

class AppPages {
  static const initialRoute = AppRoutes.splashScreen;

  static List<GetPage> route = [
    GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen()),
    GetPage(
      name: AppRoutes.onBoardingScreen,
      page: () => OnBoardingScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.bottomNavigationBarScreen,
      page: () => BottomNavigationBarScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.bookBikeScreen,
      page: () => NewBookBikeScreen(),
      // page: () => BookBikeScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.calendarScreen,
      page: () => CalendarScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => LoginScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.myBikesScreen,
      page: () => MyBikesScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.employeesScreen,
      page: () => EmployeesScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.settingsScreen,
      page: () => SettingsScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.signupScreen,
      page: () => SignupScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.userScreen,
      page: () => EmployeesScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.bikeDetailsScreen,
      page: () => BikeDetailsScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.todayScreen,
      page: () => TodayScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.selectDateTimeForBookingScreen,
      page: () => SelectDateTimeForBookingScreen(),
      transition: Transition.cupertino,
    ),
  ];
}
