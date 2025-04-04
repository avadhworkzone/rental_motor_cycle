import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/commonWidgets/common_assets.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/iamge_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import '../utils/shared_preference_utils.dart';

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

    logs("--onBoardingSeen: ${SharedPreferenceUtils.getIsLogin()}");

    if (!hasSeenOnboarding) {
      await SharedPreferenceUtils.setValue(
        SharedPreferenceUtils.onBoarding,
        true,
      );
      Get.offAllNamed(AppRoutes.onBoardingScreen);
    } else if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.bottomNavigationBarScreen);
    } else {
      Get.offAllNamed(AppRoutes.loginScreen);
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
