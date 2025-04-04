import 'package:get_secure_storage/get_secure_storage.dart';

class SharedPreferenceUtils {
  static GetSecureStorage getStorage = GetSecureStorage(
    // password: StringUtils.storagePassword,
  );
  static const onBoarding = "onBoarding";
  static const isLoggedIn = "isLoggedIn";
  static const loggedIn = "loggedIn";
  static const username = "username";
  static const userId = "userId";

  static Future<void> setValue(String key, dynamic value) async {
    await getStorage.write(key, value);
  }

  static Future setIsLogin(bool? value) async {
    await getStorage.write(loggedIn, value);
  }

  static bool getIsLogin() {
    return getStorage.read(loggedIn) ?? false;
  }

  static Future<String> getString(String key) async {
    return await getStorage.read(key) ?? "";
  }

  static Future<int> getNum(String key) async {
    return await getStorage.read(key) ?? 0;
  }

  static Future<bool> getBool(String key) async {
    return await getStorage.read(key) ?? false;
  }

  static Future<void> clearPreference() async {
    await getStorage.erase();
    SharedPreferenceUtils.setValue(SharedPreferenceUtils.onBoarding, true);
    SharedPreferenceUtils.setValue(SharedPreferenceUtils.isLoggedIn, true);
    SharedPreferenceUtils.setValue(SharedPreferenceUtils.username, true);
    SharedPreferenceUtils.setValue(SharedPreferenceUtils.userId, true);
  }
}
