import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugar/components/background.dart';
import 'package:sugar/components/notifier.dart';
import 'package:sugar/pages/selection_page.dart';
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

    // Save login status in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    // Show a SnackBar with the user's email
    Notifier.show(context, 'Successfully signed in as ${googleUser.email}', 3);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Successfully signed in as ${googleUser.email}'),
    //     duration: const Duration(seconds: 3),
    //   ),
    // );

    print("Signed in with Google as ${googleUser.email}");

    // Call the callback function (e.g., navigate to the selection page)
    callback();
  } catch (error) {
    // Handle any errors during sign-in
    print("Sign-in failed: $error");
    Notifier.show(context, 'Sign-in failed: $error', 3);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Sign-in failed: $error'),
    //     duration: const Duration(seconds: 3),
    //   ),
    // );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Future<void> _handleSignIn(BuildContext context) async {
  //   await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
  // }

  void _goToSelectionPage() {
    print(" Go to selection page");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SelectionPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // Set the size of the button to 20% of the parent width, and 10% height
              double buttonWidth = constraints.maxWidth * 0.2;
              double buttonHeight = constraints.maxHeight * 0.1;

              return OutlinedButton(
                onPressed: () =>
                    _nativeGoogleSignIn(context, _goToSelectionPage),
                style: OutlinedButton.styleFrom(
                  side: BorderSide.none, // Remove border for a cleaner look
                ),
                child: Image.asset(
                  'assets/images/google_icon.png',
                  width: buttonWidth,
                  height: buttonHeight,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
