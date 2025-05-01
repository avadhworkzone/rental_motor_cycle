// ignore_for_file: unused_import

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
import 'blocs/auth/login/login_block.dart';
import 'blocs/auth/signup/signup_block.dart';
import 'routs/route_generator.dart';
import 'utils/Theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await GetStorage.init();
  final storage = GetStorage();
  final isDarkMode = storage.read('isDarkMode') ?? false;
  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
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
            BlocProvider<ReportBloc>(create: (_) => ReportBloc()),
            BlocProvider<LoginBloc>(create: (_) => LoginBloc(context: context)),
            BlocProvider<SignupBloc>(
              create: (_) => SignupBloc(context: context),
            ),
            BlocProvider<BookBikeBloc>(create: (_) => BookBikeBloc()),
            BlocProvider<BooingFormBloc>(
              create: (_) => BooingFormBloc(bikeBloc: null),
            ),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
            // theme: AppTheme.lightTheme,
            // darkTheme: AppTheme.darkTheme, // Dark theme
            // themeMode: ThemeMode.system,
            routes: AppPages.routes,
            initialRoute: AppPages.initialRoute,
          ),
        );
      },
    );
  }
}
