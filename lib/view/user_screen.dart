import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import '../controller/user_controller.dart';
import '../model/user_model.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});
  @override
  State<EmployeesScreen> createState() => _EmployeesState();
}

class _EmployeesState extends State<EmployeesScreen> {
  final UserController userController = Get.find<UserController>();
  // ✅ Use Get.find() to avoid multiple instances
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = StringUtils.admin; // Default role
  List employRoleList = [StringUtils.admin, StringUtils.manager];
  final _formKey = GlobalKey<FormState>();

  var isProcessing = false.obs;

  // ✅ Prevent multiple clicks and database locks
  void showUserDialog({UserModel? user}) {
    if (user != null) {
      mobileController.text = user.mobileNumber;
      fullnameController.text = user.fullname;
      emailController.text = user.emailId;
      passwordController.text = user.password ?? '';
      selectedRole = user.role ?? StringUtils.admin;
    } else {
      mobileController.clear();
      fullnameController.clear();
      emailController.clear();
      passwordController.clear();
      selectedRole = StringUtils.admin;
    }

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  user == null
                      ? StringUtils.addEmployee
                      : StringUtils.editEmployee,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 10.h),

                // Full Name Field with Validation
                CommonTextField(
                  textEditController: fullnameController,
                  validator:
                      (value) => value!.isEmpty ? StringUtils.enterName : null,

                  keyBoardType: TextInputType.name,
                  pIcon: Icon(Icons.person, color: ColorUtils.grey99),
                  labelText: StringUtils.fullName,
                ),
                SizedBox(height: 10.h),

                // Mobile Number Field with Validation
                CommonTextField(
                  textEditController: mobileController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return StringUtils.enterMobileNumber;
                    } else if (value.length < 10 || value.length > 10) {
                      return StringUtils.mobileNumberValidation;
                    }
                    return null;
                  },
                  pIcon: Icon(Icons.phone, color: ColorUtils.grey99),
                  keyBoardType: TextInputType.phone,
                  labelText: StringUtils.mobileNumber,
                ),
                SizedBox(height: 10.h),
                CommonTextField(
                  textEditController: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return StringUtils.enterEmailAddress;
                    }
                    return null;
                  },
                  pIcon: Icon(Icons.email, color: ColorUtils.grey99),
                  keyBoardType: TextInputType.emailAddress,
                  labelText: StringUtils.emailId,
                ),
                SizedBox(height: 10.h),
                CommonTextField(
                  textEditController: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return StringUtils.enterPassword;
                    } else if (value.length < 6) {
                      return StringUtils.passwordValidation;
                    }
                    return null;
                  },
                  pIcon: Icon(Icons.lock, color: ColorUtils.grey99),
                  labelText: StringUtils.password,
                ),
                SizedBox(height: 10.h),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items:
                      employRoleList.map((role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: CustomText(role, color: Colors.black),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    labelText: StringUtils.role,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: ColorUtils.grey99,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedRole = value;
                      });
                    }
                  },
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        isProcessing.value
                            ? null
                            : () async {
                              if (_formKey.currentState!.validate()) {
                                // ✅ Validation
                                String mobilePattern =
                                    r'^[0-9]{10}$'; // Only 10-digit numbers
                                RegExp regExp = RegExp(mobilePattern);

                                if (fullnameController.text.trim().isEmpty) {
                                  Get.snackbar(
                                    StringUtils.error,
                                    StringUtils.fullNameRequired,
                                  );
                                  return;
                                }
                                if (!regExp.hasMatch(
                                  mobileController.text.trim(),
                                )) {
                                  Get.snackbar(
                                    StringUtils.error,
                                    StringUtils.validMobileRequired,
                                  );
                                  return;
                                }

                                isProcessing.value =
                                    true; // ✅ Prevent multiple clicks
                                await Future.delayed(
                                  Duration(milliseconds: 300),
                                ); // ✅ Ensure previous writes finish

                                var userId = SharedPreferenceUtils.getString(
                                  SharedPreferenceUtils.userId,
                                );

                                log('user id ---> $userId');

                                if (user == null) {
                                  await userController.addUser(
                                    UserModel(
                                      mobileNumber:
                                          mobileController.text.trim(),
                                      userId: await userId,
                                      fullname: fullnameController.text.trim(),
                                      emailId: emailController.text.trim(),
                                      password:
                                          passwordController.text
                                              .trim(), // ✅ added
                                      role: selectedRole,
                                    ),
                                  );
                                } else {
                                  await userController.updateUser(
                                    UserModel(
                                      id: user.id,
                                      userId: await userId,
                                      mobileNumber:
                                          mobileController.text.trim(),
                                      fullname: fullnameController.text.trim(),
                                      emailId: emailController.text.trim(),
                                      password:
                                          passwordController.text
                                              .trim(), // ✅ added
                                      role: selectedRole,
                                    ),
                                  );
                                }

                                await userController
                                    .fetchUsers(); // ✅ Update list immediately
                                isProcessing.value = false;
                                Get.back();
                              }
                            },
                    child: CustomText(
                      user == null
                          ? StringUtils.addEmployee
                          : StringUtils.updateEmployee,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void confirmDelete(int id) {
    Get.defaultDialog(
      title: StringUtils.deleteUser,
      middleText: StringUtils.confirmDeleteUser,
      textConfirm: StringUtils.delete,
      textCancel: StringUtils.cancel,
      confirmTextColor: Colors.black,
      cancelTextColor: Colors.black,
      onConfirm: () async {
        isProcessing.value = true; // ✅ Prevent multiple clicks
        await Future.delayed(Duration(milliseconds: 300)); // ✅ Delay execution
        await userController.deleteUser(id);
        await userController.fetchUsers(); // ✅ Refresh user list after delete
        isProcessing.value = false;
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.users,
        context: context,
        isLeading: false,
        isCenterTitle: false,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showUserDialog(),
        child: Icon(Icons.add),
      ),
      body: Obx(
        () =>
            userController.userList.isEmpty
                ? Center(child: CustomText(StringUtils.noUsersFound))
                : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: userController.userList.length,
                        itemBuilder: (context, index) {
                          final user = userController.userList[index];
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 10.w,
                            ),
                            child: ListTile(
                              title: CustomText(
                                user.fullname,
                                fontWeight: FontWeight.bold,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    "${StringUtils.mobileNumberPrefix} ${user.mobileNumber}",
                                  ),
                                  CustomText(
                                    "${StringUtils.emailIdPrefix} ${user.emailId}",
                                  ),
                                  CustomText(
                                    "${StringUtils.userRolePrefix} ${user.role}",
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => showUserDialog(user: user),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => confirmDelete(user.id!),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          // exportUsersAsPDF(userController.userList);
                          // Get.snackbar("Export Successful", "PDF saved in documents folder!");
                        },
                        child: CustomText(StringUtils.exportUsersAsPdf),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
