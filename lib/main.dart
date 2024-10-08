import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sugar/pages/splash_screen_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: "assets/.env");

  // print(dotenv.env['SUPABASE_URL']);

  await Supabase.initialize(
    url: "https://hcttbvnryoqdwfvmbbnn.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhjdHRidm5yeW9xZHdmdm1iYm5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc1MjI1MTksImV4cCI6MjA0MzA5ODUxOX0.8UD_O56w8GCGAaTSOALVXaK6d9V13eC5AR467qvGCZw",
    postgrestOptions: const PostgrestClientOptions(schema: 'sugar'),
  ).then((value) => print("Supabase initialized: $value"));

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
