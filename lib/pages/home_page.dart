import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/constants/app_colors.dart';
import 'package:sugar/controller/data_store_controller.dart';
import 'package:sugar/database/user_data.dart';
import 'package:sugar/pages/account_page.dart';
import 'package:sugar/pages/sugar_funds_page.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/balance_box.dart';
import 'package:sugar/widgets/notifier.dart';
import 'package:sugar/widgets/plus_button.dart';
import 'package:sugar/widgets/profile_icon.dart';
import 'package:sugar/widgets/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  final dataStore = Get.find<DataStoreController>();
  late String sweetFundsBalance = dataStore.getData("sweetFundsBalance") ?? '0';
  late String welcomeText =
      dataStore.getData("userType") == "DADDY" ? "Hi, Daddy!" : "Hi, Baby!";

  late bool hasPartner = dataStore.getData("partnerId") != null ? true : false;

  String getBalanceBoxTitle(bool isUsersAccount) {
    if (isUsersAccount) {
      return dataStore.getData("userType") == "DADDY"
          ? "sugar daddy balance"
          : "sugar baby balance";
    }
    return dataStore.getData("userType") == "DADDY"
        ? "sugar baby balance"
        : "sugar daddy balance";
  }

  Color getBalanceBoxColor(bool isUsersAccount) {
    if (isUsersAccount) {
      return dataStore.getData("userType") == "DADDY"
          ? AppColors.sugarDaddyBalance.color
          : AppColors.sugarBabyBalance.color;
    }
    return dataStore.getData("userType") == "DADDY"
        ? AppColors.sugarBabyBalance.color
        : AppColors.sugarDaddyBalance.color;
  }

  List<dynamic> balanceBoxes() {
    print("Has Partner: $hasPartner");
    if (!hasPartner) {
      return [
        BalanceBox(
          title: getBalanceBoxTitle(true),
          amount: '0',
          onTap: () => Get.to(() => AccountPage(
                title: getBalanceBoxTitle(true),
                headerColor: getBalanceBoxColor(true),
              )),
          color: getBalanceBoxColor(true),
        ),
        const SizedBox(height: 8),
        BalanceBox(
          title: '',
          amount: '600,000',
          onTap: () => Get.to(() =>
              AccountPage(title: '', headerColor: getBalanceBoxColor(false))),
          color: getBalanceBoxColor(false),
          hasNoLink: true,
        ),
        const SizedBox(height: 16)
      ];
    }

    return [
      BalanceBox(
        title: getBalanceBoxTitle(true),
        amount: '0',
        onTap: () => Get.to(() => AccountPage(
            title: getBalanceBoxTitle(true),
            headerColor: getBalanceBoxColor(true))),
        color: getBalanceBoxColor(true),
      ),
      const SizedBox(height: 8),
      BalanceBox(
        title: getBalanceBoxTitle(false),
        amount: '600,000',
        onTap: () => Get.to(
            () => AccountPage(
                  title: getBalanceBoxTitle(false),
                  headerColor: getBalanceBoxColor(false),
                ),
            transition: Transition.upToDown),
        color: getBalanceBoxColor(false),
      ),
      const SizedBox(height: 16)
    ];
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    final data = await supabase
        .from("user_data")
        .select("fcm_token")
        .eq("user_id", supabase.auth.currentUser!.id)
        .single();
    print("USER DATA's FCM TOKEN: ${data}");
    // Listen to the auth state changes
    supabase.auth.onAuthStateChange.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn) {
        await FirebaseMessaging.instance.requestPermission();
        await FirebaseMessaging.instance.getAPNSToken();

        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await upsertUserData({"fcm_token": fcmToken});
        }
      }
    });

    // Handle token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      await upsertUserData({"fcm_token": fcmToken});
    });

    FirebaseMessaging.onMessage.listen((payload) {
      final notification = payload.notification;
      if (notification == null) return;

      Notifier.show(notification.body ?? '', 3,
          title: notification.title ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Background(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with Date and Profile Icon
                    SizedBox(
                      width: double.infinity, // Constrain Row width properly
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                          ProfileIcon(),
                        ],
                      ),
                    ),
                    // Welcome Text
                    Text(
                      welcomeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "Budget",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Balance Box for Sweet Funds
                    BalanceBox(
                        title: 'sugar funds',
                        amount: sweetFundsBalance,
                        onTap: () => Get.to(
                              () => SugarFundsPage(
                                  title: 'sugar funds',
                                  headerColor:
                                      AppColors.sugarFundsBalance.color,
                                  balance: sweetFundsBalance),
                            ),
                        color: AppColors.sugarFundsFullBalance.color),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "Balance",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Column(
                      children: [...balanceBoxes()],
                    ),

                    const Spacer(),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: PlusButton(
                        onPressed: () => print("ADD Transaction"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
