import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_bloc.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_event.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_state.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/my_bike/dialogs/my_bike_dialogs.dart';

/*class MyBikesScreen extends StatefulWidget {
  const MyBikesScreen({super.key});
  @override
  State<MyBikesScreen> createState() => _MyBikesScreenState();
}

class _MyBikesScreenState extends State<MyBikesScreen> {
  final BikeController bikeController = Get.find<BikeController>();
  final EmployeeController employeeController = Get.find<EmployeeController>();
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController roomDescController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.myBikes,
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
        onPressed: () => showAddBikeBottomSheet(context),
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        if (bikeController.bikeList.isEmpty) {
          return Center(
            child: CustomText(
              StringUtils.noBikesFound,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: bikeController.bikeList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final bike = bikeController.bikeList[index];

            return GestureDetector(
              onTap:
                  () =>
                      Get.toNamed(AppRoutes.bikeDetailsScreen, arguments: bike),

              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: EdgeInsets.only(bottom: 12.w),
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bike Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            bike.imageUrl?.isNotEmpty ?? false
                                ? Image.file(
                                  File(bike.imageUrl ?? ""),
                                  height: 100.w,
                                  width: 120.w,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  height: 100,
                                  width: 120,
                                  color: ColorUtils.grey55,
                                  child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: ColorUtils.grey99,
                                  ),
                                ),
                      ),

                      SizedBox(width: 12.w),

                      // Bike Info & Actions
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              bike.brandName ?? "",
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            CustomText(
                              "📍 ${bike.location}",
                              fontSize: 15.sp,
                              color: ColorUtils.grey99,
                            ),
                            SizedBox(height: 4),
                            // CustomText(
                            //   "💰 ${bike.rentPerDay?.toStringAsFixed(2)} ${StringUtils.perDay}",
                            //   fontWeight: FontWeight.bold,
                            //   fontSize: 15.sp,
                            //   color: ColorUtils.primary,
                            // ),

                            // Action Buttons
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FloatingActionButton.extended(
                                  onPressed:
                                      () => showAddBikeBottomSheet(
                                        context,
                                        bike: bike,
                                      ),
                                  label: CustomText(
                                    StringUtils.edit,
                                    color: ColorUtils.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  icon: Icon(Icons.edit),
                                  backgroundColor: ColorUtils.primary,
                                  elevation: 2,
                                ),
                                SizedBox(width: 10.w),
                                FloatingActionButton.extended(
                                  onPressed: () => confirmDelete(bike.id ?? 0),
                                  label: CustomText(
                                    StringUtils.delete,
                                    color: ColorUtils.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  icon: Icon(Icons.delete),
                                  backgroundColor: ColorUtils.red,
                                  elevation: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}*/

// ✅ STEP 5: UI Widget using Bloc
class MyBikesScreen extends StatelessWidget {
  const MyBikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.myBikes,
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
        backgroundColor: ColorUtils.primary,
        onPressed: () => showAddBikeBottomSheet(context),
        child: Icon(Icons.add),
      ),

      body: BlocBuilder<BikeBloc, BikeState>(
        builder: (context, state) {
          if (state is BikeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is BikeLoaded) {
            if (state.bikes.isEmpty) {
              return Center(
                child: CustomText(
                  StringUtils.noBikesFound,
                  fontWeight: FontWeight.bold,
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: state.bikes.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final bike = state.bikes[index];

                return GestureDetector(
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        AppRoutes.bikeDetailsScreen,
                        arguments: bike,
                      ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 12.w),
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bike Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:
                                bike.imageUrl?.isNotEmpty ?? false
                                    ? Image.file(
                                      File(bike.imageUrl ?? ""),
                                      height: 100.w,
                                      width: 120.w,
                                      fit: BoxFit.cover,
                                    )
                                    : Container(
                                      height: 100,
                                      width: 120,
                                      color: ColorUtils.grey55,
                                      child: Icon(
                                        Icons.image,
                                        size: 40,
                                        color: ColorUtils.grey99,
                                      ),
                                    ),
                          ),

                          SizedBox(width: 12.w),

                          // Bike Info & Actions
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  bike.brandName ?? "",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                CustomText(
                                  "📍 ${bike.location}",
                                  fontSize: 15.sp,
                                  color: ColorUtils.grey99,
                                ),
                                SizedBox(height: 4.h),

                                // Uncomment if rent display is needed
                                // CustomText(
                                //   "💰 ${bike.rentPerDay?.toStringAsFixed(2)} ${StringUtils.perDay}",
                                //   fontWeight: FontWeight.bold,
                                //   fontSize: 15.sp,
                                //   color: ColorUtils.primary,
                                // ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    FloatingActionButton.extended(
                                      onPressed:
                                          () => showAddBikeBottomSheet(
                                            context,
                                            bike: bike,
                                          ),
                                      label: CustomText(
                                        StringUtils.edit,
                                        color: ColorUtils.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      icon: Icon(Icons.edit),
                                      backgroundColor: ColorUtils.primary,
                                      elevation: 2,
                                    ),
                                    SizedBox(width: 10.w),
                                    FloatingActionButton.extended(
                                      onPressed:
                                          () => confirmDelete(
                                            context,
                                            bike.id ?? 0,
                                          ),
                                      label: CustomText(
                                        StringUtils.delete,
                                        color: ColorUtils.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      icon: Icon(Icons.delete),
                                      backgroundColor: ColorUtils.red,
                                      elevation: 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is BikeError) {
            return Center(child: CustomText(state.message));
          }

          return SizedBox();
        },
      ),
    );
  }
}

void confirmDelete(BuildContext context, int id) {
  bool isProcessing = false;
  bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

  // Get.defaultDialog(
  //   title: StringUtils.deleteBike,
  //   middleText: StringUtils.deleteConfirmation,
  //   textConfirm: StringUtils.delete,
  //   textCancel: StringUtils.cancel,
  //   cancelTextColor: ColorUtils.black,
  //   confirmTextColor: ColorUtils.black,
  //   onConfirm: () async {
  //     isProcessing = true;
  //     await Future.delayed(Duration(milliseconds: 300));
  //
  //     // Dispatch the delete event to BLoC
  //     context.read<BikeBloc>().add(DeleteBikeEvent(id));
  //
  //     isProcessing = false;
  //     Get.back();
  //   },
  // );
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: CustomText(
          StringUtils.deleteBike,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        content: CustomText(
          StringUtils.deleteConfirmation,
          fontWeight: FontWeight.w500,
          fontSize: 15.sp,
        ),
        actionsPadding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 12.h,
          bottom: 20.h,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorUtils.black,
              backgroundColor: ColorUtils.white,
              elevation: 2,
              minimumSize: Size(100.w, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: ColorUtils.grey99),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: CustomText(
              StringUtils.cancel,
              color: isDarkTheme ? ColorUtils.black21 : ColorUtils.black21,
            ),
          ),
          SizedBox(width: 15.w),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorUtils.white,
              backgroundColor: Colors.redAccent,
              elevation: 3,
              minimumSize: Size(100.w, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await Future.delayed(Duration(milliseconds: 300));
              context.read<BikeBloc>().add(DeleteBikeEvent(id));
            },
            child: CustomText(StringUtils.delete, color: ColorUtils.white),
          ),
        ],
      );
    },
  );
}
