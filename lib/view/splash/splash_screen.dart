import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rental_motor_cycle/commonWidgets/common_assets.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/iamge_utils.dart';
import '../../utils/shared_preference_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    initMethod();
    super.initState();
  }

  initMethod() async {
    await Future.delayed(const Duration(seconds: 3));

    bool hasSeenOnboarding = await SharedPreferenceUtils.getBool(
      SharedPreferenceUtils.onBoarding,
    );
    bool isLoggedIn = await SharedPreferenceUtils.getBool(
      SharedPreferenceUtils.isLoggedIn,
    );

    if (!hasSeenOnboarding) {
      await SharedPreferenceUtils.setValue(
        SharedPreferenceUtils.onBoarding,
        true,
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.onBoardingScreen,
        (route) => false,
      );
    } else if (isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.bottomNavigationBarScreen,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.loginScreen,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: LocalAssets(imagePath: AssetUtils.splashLogo),
        ),
      ),
    );
  }
}
