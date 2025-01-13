import 'package:baby_monitoring_app/screens/first_screen.dart';
import 'package:baby_monitoring_app/utils/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:baby_monitoring_app/src/rust/frb_generated.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(
    ChangeNotifierProvider(create: (context) => AppStateProvider(), child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
