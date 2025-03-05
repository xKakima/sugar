import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataStoreController extends GetxController {
  // Create an observable Map to hold dynamic data
  RxString sugarFundsBalance = "".obs;
  final data = RxMap<String, dynamic>();
  late SharedPreferences prefs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    // Load any saved boolean values
    final keys = prefs.getKeys();
    for (final key in keys) {
      data[key] = prefs.get(key);
    }
  }

  // Method to add or update data dynamically
  void setData(String key, dynamic value) {
    data[key] = value; // Update in-memory
    _saveToPrefs(key, value); // Persist to SharedPreferences
  }

  // Method to get data
  dynamic getData(String key) {
    return data[key];
  }

  // Private method to save to SharedPreferences
  void _saveToPrefs(String key, dynamic value) async {
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }
}
