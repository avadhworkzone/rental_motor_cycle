import 'package:get_storage/get_storage.dart';

class SharedPreferenceUtils {
  static GetStorage getStorage = GetStorage();
  static const onBoarding = "onBoarding";
  static const isLoggedIn = "isLoggedIn";
  static const loggedIn = "loggedIn";
  static const username = "username";
  static const userId = "userId";

  static Future<void> setValue(String key, dynamic value) async {
    await getStorage.write(key, value);
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
    SharedPreferenceUtils.setValue(SharedPreferenceUtils.onBoarding, false);
    SharedPreferenceUtils.setValue(SharedPreferenceUtils.isLoggedIn, false);
    SharedPreferenceUtils.setValue(SharedPreferenceUtils.username, false);
    SharedPreferenceUtils.setValue(SharedPreferenceUtils.userId, false);
  }
}
