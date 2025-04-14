import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/commonWidgets/common_dropdown.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import '../../controller/employee_controller.dart';
import '../../model/user_model.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesState();
}

class _EmployeesState extends State<EmployeesScreen> {
  final EmployeeController employeeController = Get.find<EmployeeController>();

  // ✅ Use Get.find() to avoid multiple instances
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = StringUtils.admin; // Default role
  List<String> employRoleList = [StringUtils.admin, StringUtils.manager];
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
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? ColorUtils.darkThemeBg
                  : Colors.white,
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
                CommonDropdown(
                  items: employRoleList,
                  labelText: StringUtils.seater,
                  selectedValue: selectedRole,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedRole = value;
                      });
                    }
                  },
                  validationMessage: StringUtils.selectSeater,
                ),
                // DropdownButtonFormField<String>(
                //   value: selectedRole,
                //   items:
                //       employRoleList.map((role) {
                //         return DropdownMenuItem<String>(
                //           value: role,
                //           child: CustomText(role, color: Colors.black),
                //         );
                //       }).toList(),
                //   decoration: InputDecoration(
                //     labelText: StringUtils.role,
                //     prefixIcon: Icon(
                //       Icons.person_outline,
                //       color: ColorUtils.grey99,
                //     ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   onChanged: (value) {
                //     if (value != null) {
                //       setState(() {
                //         selectedRole = value;
                //       });
                //     }
                //   },
                // ),
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        isProcessing.value
                            ? null
                            : () async {
                              if (_formKey.currentState!.validate()) {
                                // ✅ Validation

                                if (fullnameController.text.trim().isEmpty) {
                                  Get.snackbar(
                                    StringUtils.error,
                                    StringUtils.fullNameRequired,
                                  );
                                  return;
                                }
                                isProcessing.value = true;
                                await Future.delayed(
                                  Duration(milliseconds: 300),
                                );

                                var userId = SharedPreferenceUtils.getString(
                                  SharedPreferenceUtils.userId,
                                );

                                log('user id ---> $userId');

                                if (user == null) {
                                  await employeeController.addUser(
                                    UserModel(
                                      mobileNumber:
                                          mobileController.text.trim(),
                                      userId: await userId,
                                      fullname: fullnameController.text.trim(),
                                      emailId: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      role: selectedRole,
                                    ),
                                  );
                                } else {
                                  await employeeController.updateUser(
                                    UserModel(
                                      id: user.id,
                                      userId: await userId,
                                      mobileNumber:
                                          mobileController.text.trim(),
                                      fullname: fullnameController.text.trim(),
                                      emailId: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      role: selectedRole,
                                    ),
                                  );
                                }

                                await employeeController.fetchUsers();
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
        isProcessing.value = true;
        await Future.delayed(Duration(milliseconds: 300));
        await employeeController.deleteUser(id);
        await employeeController.fetchUsers();
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
        isLeading: true,
        isCenterTitle: true,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        backgroundColor: ColorUtils.primary,
        fontColor: ColorUtils.white,
        iconColor: ColorUtils.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showUserDialog(),
        child: Icon(Icons.add),
      ),
      body: Obx(
        () =>
            employeeController.userList.isEmpty
                ? Center(
                  child: CustomText(
                    StringUtils.noUsersFound,
                    fontWeight: FontWeight.bold,
                  ),
                )
                : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: employeeController.userList.length,
                        itemBuilder: (context, index) {
                          final user = employeeController.userList[index];
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
