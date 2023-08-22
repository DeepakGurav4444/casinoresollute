import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StartPageProvider extends ChangeNotifier {
  Future<void> goToGamePage(BuildContext context) async {
    Navigator.pushNamed(context, "/GamePage");
  }

  Future<void> goToStatisticsPage(BuildContext context) async {
    Navigator.pushNamed(context, "/Statistics");
  }

  Future<void> exitGame(BuildContext context) async {
    SystemNavigator.pop(animated: true);
  }
}
