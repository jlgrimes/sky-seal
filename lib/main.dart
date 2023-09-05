import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/auth_controller.dart';
import 'package:sky_seal/deck_builder.dart';
import 'package:sky_seal/home_page.dart';
import 'package:sky_seal/signed_out_screen.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://amewqwemmqnnjnbxhxfy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtZXdxd2VtbXFubmpuYnhoeGZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM1MzI4OTcsImV4cCI6MjAwOTEwODg5N30.I7-M5bkOAofJton6bkWYro6vC3SEghIFyde96E9sNWc',
  );
  runApp(const MyApp());
}

/// This handles '/' and '/details'.
final router = GoRouter(routes: [
  GoRoute(
    path: '/:deckid',
    builder: (context, state) {
      // use state.params to get router parameter values
      final deckId = state.pathParameters['deckid'];
      return DeckBuilder();
    },
  ),
]);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppStateProvider>(
        create: (context) => AppStateProvider(),
        child: Consumer<AppStateProvider>(
            builder: (context, themeProvider, child) => MaterialApp(
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.blueAccent),
                    useMaterial3: true,
                  ),
                  home: AuthController(),
                )));
  }
}
