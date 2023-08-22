import 'package:fireabase_demo/provider/game_page_provider.dart';
import 'package:fireabase_demo/provider/result_dialog_provider.dart';
import 'package:fireabase_demo/provider/spin_dialog_provider.dart';
import 'package:fireabase_demo/provider/start_page_provider.dart';
import 'package:fireabase_demo/provider/statistics_provider.dart';
import 'package:fireabase_demo/utils/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GamePageProvider>(
          create: (context) => GamePageProvider(),
        ),
        ChangeNotifierProvider<ResultDialogProvider>(
          create: (context) => ResultDialogProvider(),
        ),
        ChangeNotifierProvider<SpinDialogProvider>(
          create: (context) => SpinDialogProvider(),
        ),
        ChangeNotifierProvider<StartPageProvider>(
          create: (context) => StartPageProvider(),
        ),
        ChangeNotifierProvider<StatisticsProvider>(
          create: (context) => StatisticsProvider(),
        ),
      ],
      child: MaterialApp(
        routes: routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
