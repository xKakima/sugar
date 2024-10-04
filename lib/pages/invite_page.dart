import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart'; // Updated import
import 'package:sugar/components/background.dart';
import 'package:sugar/components/notifier.dart';
import 'package:sugar/pages/monthly_budget_page.dart';

class InvitePage extends StatelessWidget {
  final String role;

  const InvitePage({super.key, required this.role});

  Future<String> generateLink() async {
    // Simulate a network call or some async operation
    await Future.delayed(const Duration(seconds: 1));
    return "ABCD"; // Replace with actual link generation logic
  }

  @override
  Widget build(BuildContext context) {
    String inviteText = role == 'sugar_baby'
        ? 'Invite your sugar daddy'
        : 'Invite your sugar baby';

    return Scaffold(
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Text(
                inviteText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.link, color: Colors.white, size: 50),
                    onPressed: () async {
                      // Handle link sharing Copy to clipboard
                      String link = await generateLink();
                      Clipboard.setData(ClipboardData(text: link));
                      Notifier.show(
                        context,
                        "Link copied to clipboard",
                        3,
                      );
                    },
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    icon:
                        const Icon(Icons.share, color: Colors.white, size: 50),
                    onPressed: () async {
                      // Handle sharing via other apps
                      String link = await generateLink();
                      Share.share(link); // Using share_plus for sharing
                    },
                  ),
                ],
              ),
              const Spacer(),
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
