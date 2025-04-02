import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/commonWidgets/common_assets.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/iamge_utils.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _images = [
    LocalAssets(imagePath: AssetUtils.splashLogo),
    LocalAssets(imagePath: AssetUtils.splashLogo),
    LocalAssets(imagePath: AssetUtils.splashLogo),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: theme.secondaryHeaderColor,
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      children: _images,
                    ),
                    Positioned(
                      bottom: 24,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: ColorUtils.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorUtils.shadowColor,
                    offset: Offset(0, -3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 32.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: CustomText(
                      StringUtils.onboadingTitle,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 42.w),
                    child: CustomText(
                      StringUtils.onboadingDetails,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                      color: ColorUtils.grey55,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 24.h,
                    ),
                    child: CustomBtn(
                      onTap: () async {
                        await SharedPreferenceUtils.setValue(
                          SharedPreferenceUtils.onBoarding,
                          true,
                        );
                        bool hasSeenOnboarding =
                            await SharedPreferenceUtils.getBool(
                              SharedPreferenceUtils.onBoarding,
                            );
                        bool isLoggedIn = await SharedPreferenceUtils.getBool(
                          SharedPreferenceUtils.isLoggedIn,
                        );
                        logs(
                          "-IN Onboading BUTTON SET---onBoardingSeen: $hasSeenOnboarding, isLoggedIn: $isLoggedIn",
                        );
                        Get.offAllNamed(AppRoutes.loginScreen);
                      },
                      title: StringUtils.startRiding,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _images.length; i++) {
      indicators.add(
        Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i ? ColorUtils.primary : ColorUtils.greyF0,
          ),
        ),
      );
    }
    return indicators;
  }
}
