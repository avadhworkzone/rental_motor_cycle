import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rental_motor_cycle/commonWidgets/common_assets.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
import 'package:rental_motor_cycle/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/iamge_utils.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/bottom_navigation_bar_screen.dart';
import 'package:rental_motor_cycle/view/signup_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserController userController = Get.find<UserController>();
  var isProcessing = false.obs;

  /// ✅ **Login Logic**
  void _login() async {
    if (_formKey.currentState!.validate()) {
      isProcessing.value = true;
      await userController.loginFetchUsers();
      String username = usernameController.text.trim();
      String password = passwordController.text.trim();
      var user = userController.loginUserList.firstWhereOrNull(
        (user) => user.username == username && user.password == password,
      );

      print('user--->> ${user}----> ${userController.loginUserList}');
      if (user != null) {
        await SharedPreferenceUtils.setValue(
          SharedPreferenceUtils.isLoggedIn,
          true,
        );

        bool isLoggedIn = await SharedPreferenceUtils.getBool(
          SharedPreferenceUtils.isLoggedIn,
        );
        logs(
          "--LOGIN SharedPreferenceUtils.getBool(SharedPreferenceUtils.isLoggedIn)---$isLoggedIn",
        );
        await SharedPreferenceUtils.setValue(
          SharedPreferenceUtils.userId,
          userController.loginUserList.first.id.toString(),
        );
        await SharedPreferenceUtils.setValue(
          SharedPreferenceUtils.username,
          username,
        );
        showCustomSnackBar(message: StringUtils.loginSuccessful);
        Get.offAllNamed(AppRoutes.bottomNavigationBarScreen);
      } else {
        showCustomSnackBar(message: StringUtils.invalidCredentials);
      }
      isProcessing.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.login,
        context: context,
        isLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LocalAssets(height: 200.h, imagePath: AssetUtils.splashLogo),
                  SizedBox(height: 50.h),
                  CommonTextField(
                    textEditController: usernameController,
                    labelText: StringUtils.userName,
                    validator:
                        (value) =>
                            value!.isEmpty ? StringUtils.enterUserName : null,
                  ),
                  SizedBox(height: 10.h),
                  CommonTextField(
                    textEditController: passwordController,
                    labelText: StringUtils.password,
                    obscureValue: true,
                    validator:
                        (value) =>
                            value!.length < 6
                                ? StringUtils.passwordMustBeSixCharaters
                                : null,
                  ),
                  SizedBox(height: 20.h),
                  Obx(
                    () =>
                        isProcessing.value
                            ? CircularProgressIndicator()
                            : CustomBtn(
                              onTap: () {
                                _login();
                              },
                              title: StringUtils.login,
                            ),
                  ),
                  SizedBox(height: 20.h),
                  RichText(
                    text: TextSpan(
                      text: StringUtils.dontHaveAnAccount,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorUtils.black,
                        fontFamily: FontUtils.cerebriSans,
                      ),
                      children: [
                        TextSpan(
                          text: StringUtils.signup,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorUtils.primary,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontUtils.cerebriSans,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.offAllNamed(AppRoutes.signupScreen);
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
