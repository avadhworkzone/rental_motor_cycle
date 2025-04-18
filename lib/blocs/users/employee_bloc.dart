import 'package:flutter_bloc/flutter_bloc.dart';
import 'employee_event.dart';
import 'employee_state.dart';
import '../../database/db_helper.dart';
import '../../model/user_model.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<AddUser>(_onAddUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  final userList = [];

  Future<void> _onFetchUsers(
    FetchUsers event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    final users = await DBHelper.getUsers();
    var userList = users.map((e) => UserModel.fromMap(e)).toList();
    userList = userList;
    emit(EmployeeLoaded(userList));
  }

  Future<void> _onAddUser(AddUser event, Emitter<EmployeeState> emit) async {
    emit(EmployeeProcessing());
    await DBHelper.database.then((db) async {
      await db.transaction((txn) async {
        await txn.insert('Users', event.user.toMap());
      });
    });
    add(FetchUsers());
  }

  Future<void> _onUpdateUser(
    UpdateUser event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeProcessing());
    await DBHelper.database.then((db) async {
      await db.transaction((txn) async {
        await txn.update(
          'Users',
          event.user.toMap(),
          where: 'id = ?',
          whereArgs: [event.user.id],
        );
      });
    });
    add(FetchUsers());
  }

  Future<void> _onDeleteUser(
    DeleteUser event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeProcessing());
    await DBHelper.database.then((db) async {
      await db.transaction((txn) async {
        await txn.delete('Users', where: 'id = ?', whereArgs: [event.id]);
      });
    });
    add(FetchUsers());
  }
}
