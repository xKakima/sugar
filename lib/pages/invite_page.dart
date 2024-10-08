import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sugar/components/background.dart';
import 'package:sugar/components/buttons/rectangle_button.dart';
import 'package:sugar/components/notifier.dart';
import 'package:sugar/database/user_data.dart';
import 'package:sugar/pages/monthly_budget_page.dart';

class InvitePage extends StatefulWidget {
  final String role;

  InvitePage({Key? key, required this.role}) : super(key: key);

  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  late String uniqueCode = '';

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
    String inviteText = widget.role == 'sugar_baby'
        ? 'invite\nyour\nsugar\ndaddy'
        : 'invite\nyour\nsugar\nbaby';

    String iconAsset = widget.role == 'sugar_baby'
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
                crossAxisAlignment: CrossAxisAlignment.values[1],
                children: [
                  // Image for sugar daddy or sugar baby
                  Image.asset(
                    iconAsset,
                    width: 280,
                    height: 280,
                  ),
                  // Text inviting sugar daddy or sugar baby
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          inviteText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ])
                ],
              ),
              const SizedBox(height: 40),
              // Row with icons for copying link and sharing
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.link, color: Colors.white, size: 50),
                  //   onPressed: () async {
                  //     Clipboard.setData(ClipboardData(text: uniqueCode));
                  //     Notifier.show(
                  //       context,
                  //       "Link copied to clipboard",
                  //       3,
                  //     );
                  //   },
                  // ),
                  RectangleButton(
                      image: "assets/images/link_button.png",
                      isFullSize: false,
                      onPressed: () async {
                        Clipboard.setData(ClipboardData(text: uniqueCode));
                        Notifier.show(
                          context,
                          "Link copied to clipboard",
                          3,
                        );
                      }),
                  const SizedBox(width: 40),
                  RectangleButton(
                    image: "assets/images/share_button.png",
                    isFullSize: false,
                    onPressed: () async {
                      Share.share(uniqueCode); // Using share_plus for sharing
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
