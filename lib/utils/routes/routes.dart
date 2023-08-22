import 'package:fireabase_demo/ui/pages/home_page.dart';
import 'package:fireabase_demo/ui/pages/start_page.dart';
import 'package:fireabase_demo/ui/pages/statistics_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  "/": (context) => const StartPage(),
  "/GamePage": (context) => const HomePage(),
  "/Statistics": (context) => const StatisticsPage()
};
