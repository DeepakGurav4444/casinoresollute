import 'dart:async';

import 'package:flutter/material.dart';

class SpinDialogProvider extends ChangeNotifier {
  late StreamController<int> selectedStreamController;
  late Stream<int> selectedStream;

  initiateValue(int randomIndex) {
    selectedStreamController = StreamController<int>();
    selectedStream = selectedStreamController.stream;
    selectedStreamController.add(randomIndex);
  }
}
