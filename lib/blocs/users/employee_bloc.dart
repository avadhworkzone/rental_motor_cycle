import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_motor_cycle/database/db_helper.dart';
import 'package:rental_motor_cycle/model/user_model.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeInitial());

  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    if (event is FetchUsersEvent) {
      yield* _mapFetchUsersToState();
    } else if (event is AddUserEvent) {
      yield* _mapAddUserToState(event);
    } else if (event is AddLoginUserEvent) {
      yield* _mapAddLoginUserToState(event);
    } else if (event is UpdateUserEvent) {
      yield* _mapUpdateUserToState(event);
    } else if (event is DeleteUserEvent) {
      yield* _mapDeleteUserToState(event);
    }
  }

  Stream<EmployeeState> _mapFetchUsersToState() async* {
    try {
      yield EmployeeLoading();
      final users = await DBHelper.getUsers();
      final userList = users.map((e) => UserModel.fromMap(e)).toList();
      yield EmployeeLoaded(userList: userList);
    } catch (_) {
      yield EmployeeError("Failed to fetch users.");
    }
  }

  Stream<EmployeeState> _mapAddUserToState(AddUserEvent event) async* {
    try {
      yield EmployeeLoading();
      await DBHelper.database.then((db) async {
        await db.transaction((txn) async {
          await txn.insert('Users', event.user.toMap());
        });
      });
      add(FetchUsersEvent()); // Re-fetch users after adding
    } catch (_) {
      yield EmployeeError("Failed to add user.");
    }
  }

  Stream<EmployeeState> _mapAddLoginUserToState(
    AddLoginUserEvent event,
  ) async* {
    try {
      yield EmployeeLoading();
      await DBHelper.database.then((db) async {
        await db.transaction((txn) async {
          await txn.insert('LoginUsers', event.user.toMap());
        });
      });
      add(FetchLoginUsersEvent()); // Re-fetch login users after adding
    } catch (_) {
      yield EmployeeError("Failed to add login user.");
    }
  }

  Stream<EmployeeState> _mapUpdateUserToState(UpdateUserEvent event) async* {
    try {
      yield EmployeeLoading();
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
      add(FetchUsersEvent()); // Re-fetch users after updating
    } catch (_) {
      yield EmployeeError("Failed to update user.");
    }
  }

  Stream<EmployeeState> _mapDeleteUserToState(DeleteUserEvent event) async* {
    try {
      yield EmployeeLoading();
      await DBHelper.database.then((db) async {
        await db.transaction((txn) async {
          await txn.delete('Users', where: 'id = ?', whereArgs: [event.id]);
        });
      });
      add(FetchUsersEvent()); // Re-fetch users after deleting
    } catch (_) {
      yield EmployeeError("Failed to delete user.");
    }
  }
}
