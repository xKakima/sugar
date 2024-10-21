import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sugar/controller/data_store_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sugar/firebase_options.dart';
import 'package:sugar/pages/splash_screen_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    postgrestOptions: const PostgrestClientOptions(schema: 'sugar'),
  );
  Get.put(DataStoreController());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const SplashScreen(),
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Figtree',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Figtree'),
          bodyMedium: TextStyle(fontFamily: 'Figtree'),
          bodySmall: TextStyle(fontFamily: 'Figtree'),
          titleLarge: TextStyle(fontFamily: 'Figtree'),
        ),
      ),
    );
  }
}
