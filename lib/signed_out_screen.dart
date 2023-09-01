import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Function to generate a random 16 character string.
String _generateRandomString() {
  final random = Random.secure();
  return base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
}

Future<AuthResponse> signInWithGoogle() async {
  // Just a random string
  final rawNonce = _generateRandomString();
  final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

  /// TODO: update the client ID with your own
  ///
  /// Client ID that you registered with Google Cloud.
  /// You will have two different values for iOS and Android.
  String clientId = Platform.isIOS
      ? '10007324611-3q3j2p3m76jguirophir91d7vrgtagcp.apps.googleusercontent.com'
      : '10007324611-r43e1b65jacughbdkk8ed143cr99879g.apps.googleusercontent.com';

  /// reverse DNS form of the client ID + `:/` is set as the redirect URL
  final redirectUrl = '${clientId.split('.').reversed.join('.')}:/';

  /// Fixed value for google login
  const discoveryUrl =
      'https://accounts.google.com/.well-known/openid-configuration';

  final appAuth = FlutterAppAuth();

  // authorize the user by opening the consent page
  final result = await appAuth.authorize(
    AuthorizationRequest(
      clientId,
      redirectUrl,
      discoveryUrl: discoveryUrl,
      nonce: hashedNonce,
      scopes: [
        'openid',
        'email',
      ],
    ),
  );

  if (result == null) {
    throw 'Could not find AuthorizationResponse after authorizing';
  }

  // Request the access and id token to google
  final tokenResult = await appAuth.token(
    TokenRequest(
      clientId,
      redirectUrl,
      authorizationCode: result.authorizationCode,
      discoveryUrl: discoveryUrl,
      codeVerifier: result.codeVerifier,
      nonce: result.nonce,
      scopes: [
        'openid',
        'email',
      ],
    ),
  );

  final idToken = tokenResult?.idToken;

  if (idToken == null) {
    throw 'Could not find idToken from the token response';
  }

  return Supabase.instance.client.auth.signInWithIdToken(
    provider: Provider.google,
    idToken: idToken,
    accessToken: tokenResult?.accessToken,
    nonce: rawNonce,
  );
}

class SignedOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: signInWithGoogle, child: Text('Sign in with Google'))
          ],
        ),
      ),
    );
  }
}
