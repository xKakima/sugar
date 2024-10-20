import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sugar/controller/data_store_controller.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/buttons/rectangle_button.dart';
import 'package:sugar/widgets/notifier.dart';
import 'package:sugar/database/user_data.dart';
import 'package:sugar/pages/monthly_budget_page.dart';

class InvitePage extends StatefulWidget {
  InvitePage({Key? key}) : super(key: key);

  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  final dataStore = Get.find<DataStoreController>();
  late String uniqueCode = '';
  late String userType = dataStore.getData("userType");

  @override
  void initState() {
    super.initState();
    getInviteCode();
  }

  Future<void> getInviteCode() async {
    final userDataResponse = await fetchSpecificUserData('unique_code');
    uniqueCode = userDataResponse[0]['unique_code'].toString();
    print(uniqueCode);
  }

  @override
  Widget build(BuildContext context) {
    String inviteText = userType == 'BABY'
        ? 'invite\nyour\nsugar\ndaddy'
        : 'invite\nyour\nsugar\nbaby';

    String iconAsset = userType == 'BABY'
        ? 'assets/images/sugar_baby_icon.png'
        : 'assets/images/sugar_daddy_icon.png';

    return Scaffold(
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image for sugar daddy or sugar baby
                  Image.asset(
                    iconAsset,
                    width: 280,
                    height: 280,
                  ),
                  // const SizedBox(
                  //     width: 5), // Add spacing between the image and text
                  // const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      inviteText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RectangleButton(
                    image: "assets/images/link_button.png",
                    isFullSize: false,
                    onPressed: () async {
                      Clipboard.setData(ClipboardData(text: uniqueCode));
                      Notifier.show(
                        "Link copied to clipboard",
                        3,
                      );
                    },
                  ),
                  const SizedBox(width: 40),
                  RectangleButton(
                    image: "assets/images/share_button.png",
                    isFullSize: false,
                    onPressed: () async {
                      Share.share(uniqueCode);
                    },
                  ),
                ],
              ),
              const Spacer(),
              // Bottom check circle icon
              IconButton(
                icon: const Icon(Icons.check_circle,
                    color: Colors.white, size: 50),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MonthlyBudget()),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
