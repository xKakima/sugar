import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sugar/components/background.dart';
import 'package:sugar/selection_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final supabase = Supabase.instance.client;

Future<void> _nativeGoogleSignIn(callback) async {
  const webClientId =
      "511559276850-3bip5mii1caom58sde2gllmvpotiihs1.apps.googleusercontent.com";

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "511559276850-a64rvj07blo1fh3p5r956nm75jrcte29.apps.googleusercontent.com",
    serverClientId: webClientId,
  );
  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser!.authentication;
  final accessToken = googleAuth.accessToken;
  final idToken = googleAuth.idToken;

  if (accessToken == null) {
    throw 'No Access Token found.';
  }
  if (idToken == null) {
    throw 'No ID Token found.';
  }

  await supabase.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  );

  // Save login status in SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);

  print("Signed in with Google");
  callback();
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
                onPressed: () => _nativeGoogleSignIn(_goToSelectionPage),
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
