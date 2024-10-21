import 'package:get/get.dart';

class DataStoreController extends GetxController {
  // Create an observable Map to hold dynamic data
  RxString sugarFundsBalance = "".obs;

  var data = <String, dynamic>{}.obs;

  // Method to add or update data dynamically
  void setData(String key, dynamic value) {
    data[key] = value; // Insert or update the key-value pair
  }

  // Method to retrieve data by key
  dynamic getData(String key) {
    return data[key]; // Return the value associated with the key
  }

  // Method to remove a key-value pair from the Map
  void removeData(String key) {
    data.remove(key);
  }

  // Method to check if a key exists
  bool containsKey(String key) {
    return data.containsKey(key);
  }
}
