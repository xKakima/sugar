import 'package:flutter/material.dart';
import 'package:sugar/components/background.dart';
import 'package:sugar/monthly_budget_page.dart';

class InvitePage extends StatelessWidget {
  final String role;

  const InvitePage({super.key, required this.role});

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
                    onPressed: () {
                      // Handle link sharing Copy to clipboard
                    },
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    icon:
                        const Icon(Icons.share, color: Colors.white, size: 50),
                    onPressed: () {
                      // Handle sharing via other apps
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
