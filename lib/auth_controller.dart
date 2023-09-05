import 'package:flutter/material.dart';
import 'package:sky_seal/home_page.dart';
import 'package:sky_seal/signed_out_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends StatelessWidget {
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.data?.event == AuthChangeEvent.signedIn) {
            return MyHomePage();
          } else {
            return SignedOutScreen();
          }
        });
  }
}
