import 'package:flutter/material.dart';
import 'package:sugar/monthly_budget_page.dart';
import 'package:sugar/splash_screen_page.dart';
import 'package:sugar/selection_page.dart';
import 'package:sugar/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required to use async in main

  await dotenv.load(fileName: "assets/.env");

  print(dotenv.env['SUPABASE_URL']);

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
    postgrestOptions: const PostgrestClientOptions(schema: 'sugar'),
  ).then((value) => print("done supabase connection"));

  // Check the login status
  final prefs = await SharedPreferences.getInstance();
  //TODO REMOVE
  await prefs.setBool('isLoggedIn', false);
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn
          ? const MonthlyBudget() // If logged in, go to the main selection page
          : const SplashScreen(), // If not logged in, start with splash screen
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(bodyLarge: TextStyle(fontFamily: 'Figtree')),
      ),
    );
  }
}
