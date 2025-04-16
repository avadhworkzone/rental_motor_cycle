import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:rental_motor_cycle/commonWidgets/common_assets.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
import 'package:rental_motor_cycle/controller/employee_controller.dart';
import 'package:rental_motor_cycle/database/db_helper.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/iamge_utils.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import '../../model/login_user_model.dart';
import 'login_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final EmployeeController employeeController = Get.find<EmployeeController>();
  var isProcessing = false.obs;

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      isProcessing.value = true;

      // await DBHelper.insertUser();

      await employeeController.addLoginUser(
        LoginUserModel(
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
          fullname: fullnameController.text.trim(),
        ),
      );

      isProcessing.value = false;
      showCustomSnackBar(message: StringUtils.signUpSuccessful);
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.signup,
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
                  SizedBox(height: 10.h),
                  CommonTextField(
                    textEditController: fullnameController,
                    labelText: StringUtils.fullName,
                    validator:
                        (value) =>
                            value!.isEmpty ? StringUtils.enterFullName : null,
                  ),
                  SizedBox(height: 20.h),
                  Obx(() {
                    return isProcessing.value
                        ? CircularProgressIndicator()
                        : CustomBtn(
                          onTap: isProcessing.value ? null : _signup,
                          title: StringUtils.signup,
                        );
                  }),
                  SizedBox(height: 20.h),
                  RichText(
                    text: TextSpan(
                      text: StringUtils.alreadyHaveAnAccount,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorUtils.black,
                        fontFamily: FontUtils.cerebriSans,
                      ),
                      children: [
                        TextSpan(
                          text: StringUtils.login,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorUtils.primary,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontUtils.cerebriSans,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.offAllNamed(AppRoutes.loginScreen);
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
