import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugar/database/user_data.dart';
import 'package:sugar/pages/partner_code_page.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> _nativeGoogleSignIn(
    BuildContext context, VoidCallback callback) async {
  const webClientId =
      "511559276850-3bip5mii1caom58sde2gllmvpotiihs1.apps.googleusercontent.com";

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "511559276850-a64rvj07blo1fh3p5r956nm75jrcte29.apps.googleusercontent.com",
    serverClientId: webClientId,
  );

  try {
    // Force account selection by disconnecting the current session, if any
    await googleSignIn.signOut(); // Ensure the user chooses an account

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw 'Google sign-in aborted.';
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw 'No Access Token or ID Token found.';
    }

    // Sign in to Supabase with Google
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    final userData = await fetchUserData();
    if (userData.isEmpty || userData['user_id'] == null) {
      final insertResponse =
          await insertUserData(supabase.auth.currentUser!.id);
      if (!insertResponse['success']) {
        throw Exception(insertResponse['message']);
      }
    }

    Notifier.show(
      "Welcome, ${supabase.auth.currentUser!.userMetadata?["name"]}!",
      3,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("googleIdToken", idToken);
    await prefs.setString("googleAccessToken", accessToken);
    await prefs.setBool('isLoggedIn', true);
    callback();
  } catch (error) {
    print("Sign-in failed: $error");
    if (context.mounted) {
      Notifier.show(
        "Sign-in failed: $error",
        3,
      );
    }
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double buttonSize = constraints.maxWidth * 0.15;
            double textTopPadding = constraints.maxHeight * 0.25;
            double buttonTopPadding = constraints.maxHeight * 0.15;

            return Center(
              child: Column(
                children: [
                  SizedBox(
                      height: textTopPadding), // Space above the login text
                  const Text(
                    'login.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: buttonTopPadding), // Space above the button
                  GestureDetector(
                    onTap: () => _nativeGoogleSignIn(
                        context, () => Get.to(() => PartnerCodePage())),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        'assets/images/google_icon.png',
                        width: buttonSize,
                        height: buttonSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
