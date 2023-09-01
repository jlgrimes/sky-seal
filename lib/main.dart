import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/signed_out_screen.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await supabase.Supabase.initialize(
    url: 'https://amewqwemmqnnjnbxhxfy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtZXdxd2VtbXFubmpuYnhoeGZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM1MzI4OTcsImV4cCI6MjAwOTEwODg5N30.I7-M5bkOAofJton6bkWYro6vC3SEghIFyde96E9sNWc',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppStateProvider>(
        create: (context) => AppStateProvider(),
        child: Consumer<AppStateProvider>(
            builder: (context, themeProvider, child) => MaterialApp(
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  home: SignedOutScreen(),
                )));
  }
}
