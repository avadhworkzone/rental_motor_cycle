import '../../model/user_model.dart';

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<UserModel> userList;
  EmployeeLoaded(this.userList);
}

class EmployeeProcessing extends EmployeeState {}

class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);
}
