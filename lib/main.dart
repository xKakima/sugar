import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sugar/pages/splash_screen_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required to use async in main

  await dotenv.load(fileName: "assets/.env");

  print(dotenv.env['SUPABASE_URL']);

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
    postgrestOptions: const PostgrestClientOptions(schema: 'sugar'),
  ).then((value) => print("done supabase connection"));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(bodyLarge: TextStyle(fontFamily: 'Figtree')),
      ),
    );
  }
}
