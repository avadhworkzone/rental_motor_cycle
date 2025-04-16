import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_bloc.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_form_bloc/bike_form_bloc.dart';
import 'package:rental_motor_cycle/blocs/book_bike/book_bike_home_bloc/book_bike_bloc.dart';
import 'package:rental_motor_cycle/blocs/book_bike/booking_form_bloc/booking_form_bloc.dart';
import 'package:rental_motor_cycle/blocs/report/report_bloc.dart';
import 'package:rental_motor_cycle/blocs/users/employee_bloc.dart';
import 'package:rental_motor_cycle/blocs/users/employee_event.dart';
import 'package:rental_motor_cycle/controller/badge_controller.dart';
import 'package:rental_motor_cycle/controller/bike_booking_controller.dart';
import 'package:rental_motor_cycle/controller/bike_controller.dart';
import 'package:rental_motor_cycle/controller/employee_controller.dart';
import 'package:rental_motor_cycle/view/setting/report_screen.dart';
import 'routs/route_generator.dart';
import 'utils/Theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await GetSecureStorage.init(password: StringUtils.storagePassword);
  // Force Portrait Mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await GetStorage.init();
  await Get.putAsync(() async => EmployeeController());
  await Get.putAsync(() async => BikeController());
  await Get.putAsync(() async => BikeBookingController());
  await Get.putAsync(() async => BadgeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      // builder: (context, child) {
      //   return GetMaterialApp(
      //     title: 'Flutter Demo',
      //     debugShowCheckedModeBanner: false,
      //     theme: AppTheme.lightTheme, // Light theme
      //     // darkTheme: AppTheme.darkTheme, // Dark theme
      //     // themeMode: ThemeMode.system,
      //     getPages: AppPages.route,
      //     initialRoute: AppPages.initialRoute,
      //   );
      // },
      //   );
      // }
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<BikeBloc>(
              create: (_) => BikeBloc(),
            ), // Providing BikeBloc
            BlocProvider<BikeFormBloc>(
              create:
                  (context) => BikeFormBloc(bikeBloc: context.read<BikeBloc>()),
            ),
            BlocProvider<EmployeeBloc>(
              create: (_) => EmployeeBloc()..add(FetchUsers()),
            ),
            BlocProvider<ReportBloc>(
              create: (_) => ReportBloc(),
              // child: ReportScreen(),
            ),
            BlocProvider<ReportBloc>(create: (_) => ReportBloc()),
            BlocProvider<BookBikeBloc>(create: (_) => BookBikeBloc()),
            BlocProvider<BooingFormBloc>(
              create: (_) => BooingFormBloc(bikeBloc: null),
            ),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme, // Light theme
            // darkTheme: AppTheme.darkTheme, // Dark theme
            // themeMode: ThemeMode.system,
            getPages: AppPages.route,
            initialRoute: AppPages.initialRoute,
          ),
        );
      },
    );
  }
}
