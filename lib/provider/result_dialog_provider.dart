import 'package:flutter/material.dart';
import 'dart:math';

class ResultDialogProvider extends ChangeNotifier {
  bool animeDirection = false;
  late AnimationController cardFlipAnimeController;
  double angle = 0 * -pi;

  double? get getAngle => angle;

  bool get getAnimeDirection => animeDirection;

  setAnimeDirection(bool val) {
    animeDirection = val;
    notifyListeners();
  }

  setAngle(double val) {
    angle = val * -pi;
    notifyListeners();
  }

  listenToFlipAnimation() {
    cardFlipAnimeController.forward();
    cardFlipAnimeController.addListener(() {
      if (getAnimeDirection) {
        setAngle(cardFlipAnimeController.value * pi / ~15);
      } else {
        setAngle(-cardFlipAnimeController.value * pi / ~15);
      }
      cardFlipAnimeController.addStatusListener((animationStatus) {
        switch (animationStatus) {
          case AnimationStatus.completed:
            setAnimeDirection(!getAnimeDirection);
            cardFlipAnimeController.reverse();
            break;
          case AnimationStatus.dismissed:
            setAnimeDirection(!getAnimeDirection);
            cardFlipAnimeController.forward();
            break;
          case AnimationStatus.forward:
            break;
          case AnimationStatus.reverse:
            break;
        }
      });
    });
  }
}
