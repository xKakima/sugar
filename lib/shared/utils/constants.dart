import 'package:get/get.dart';
import 'package:sugar/core/services/data_store_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final dataStore = Get.find<DataStoreController>();
