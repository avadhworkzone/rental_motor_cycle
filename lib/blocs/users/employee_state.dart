import 'package:rental_motor_cycle/model/user_model.dart';

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<UserModel> userList;
  EmployeeLoaded({required this.userList});
}

class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);
}
