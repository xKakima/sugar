import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugar/shared/widgets/background.dart';
import 'package:sugar/shared/utils/utils.dart';
import 'package:sugar/core/services/data_store_controller.dart';
import 'package:sugar/core/database/budget.dart';
import 'package:sugar/core/database/user_data.dart';
import 'package:sugar/features/home/views/home_page.dart';
import 'package:sugar/features/auth/views/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sugar/shared/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final dataStore = Get.find<DataStoreController>();
  double _progress = 0.0;
  late Timer _timer;
  late int _loadDuration;

  @override
  void initState() {
    super.initState();
    _loadDuration = Random().nextInt(2) + 1;
    _startLoading();
  }

  Future<void> _startLoading() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    const duration =
        Duration(milliseconds: 16); // ~60 FPS for smoother animation
    final totalTicks = _loadDuration * 1000 / duration.inMilliseconds;

    // Start with a quick initial progress
    setState(() => _progress = 0.1);

    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        // Use a curved animation for more natural feel
        final targetProgress = _progress + (1.5 / totalTicks);
        _progress = _progress + (targetProgress - _progress) * 0.3;

        if (_progress >= 0.99) {
          _progress = 1.0;
          _timer.cancel();
          _redirect(isLoggedIn);
        }
      });
    });
  }

  Future<void> _redirect(isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    if (!isLoggedIn) {
      Get.to(() => LoginPage());
      return;
    }
    try {
      final googleUser = await GoogleSignIn().signInSilently();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final accessToken = googleAuth.accessToken;
        final idToken = googleAuth.idToken;
        await prefs.setString("googleIdToken", idToken!);
        await prefs.setString("googleAccessToken", accessToken!);
        await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );

        final userData = await fetchUserData();
        if (userData.isEmpty || userData['user_id'] == null) {
          Get.to(() => LoginPage());
          return;
        }

        late String balance;
        if (userData['partner_id'] != null) {
          dataStore.setData("partnerId", userData['partner_id']);
          balance = await fetchMonthlyBalance(userData['partner_id']);
        } else {
          balance = await fetchMonthlyBalance(null);
        }

        dataStore.sugarFundsBalance.value = balance;
        dataStore.setData("userType", userData['user_type'].toString());
        Get.to(() => HomePage());
      } else {
        await logout();
        Get.to(() => LoginPage());
      }
    } catch (e) {
      await logout();
      Get.to(() => LoginPage());
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset(
                  'assets/images/splash_screen_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.15,
                right: MediaQuery.of(context).size.width * 0.08,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(
                    begin: 0.0,
                    end: _progress,
                  ),
                  builder: (context, value, child) => Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26), // 0.1 opacity = 26/255
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          spreadRadius: value * 2,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Background (Grey loading bar)
                        Container(
                          color: Colors.grey[300],
                        ),
                        // White progress fill with gradient
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: _progress,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.white,
                                    Colors.white.withAlpha(230), // 0.9 opacity = 230/255
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Loading bar shape mask
                        Image.asset(
                          'assets/images/loading_bar.png',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.fill,
                          color: Colors.white,
                          colorBlendMode: BlendMode.dstIn,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
