import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireabase_demo/ui/widgets/dialogs/result_dialog.dart';
import 'package:fireabase_demo/ui/widgets/dialogs/spin_dialog.dart';
import 'package:fireabase_demo/utils/local_data/save_data.dart';
import 'package:fireabase_demo/utils/models/card_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/models/bet_option.dart';
import '../utils/models/result_model.dart';

class GamePageProvider extends ChangeNotifier {
  bool isSpinLoading = false;
  late ResultModel resultModel;
  late int randomInt;
  late int totalAmount;
  late DateTime gameTime;
  late BuildContext gameContext;
  int creditBalance = 0;
  set setCreditBalance(int val) {
    creditBalance = val;
    notifyListeners();
  }

  set setIsSpinLoading(bool val) {
    isSpinLoading = val;
    notifyListeners();
  }

  List<CardData> cardList = List.generate(
      12,
      (index) => CardData(
          cardName: index == 0
              ? "A"
              : index == 10
                  ? "J"
                  : index == 11
                      ? "Q"
                      : "${index + 1}"));

  List<BetOption> betOptions = [
    BetOption(price: 10, tokenPath: "assets/images/tokens/10.png"),
    BetOption(price: 50, tokenPath: "assets/images/tokens/50.png"),
    BetOption(price: 100, tokenPath: "assets/images/tokens/100.png"),
    BetOption(price: 500, tokenPath: "assets/images/tokens/500.png")
  ];

  Future<void> onTapOnBet(int index) async {
    var previousBetIndex =
        betOptions.indexWhere((element) => element.isSelected == true);
    if (previousBetIndex == -1) {
      betOptions[index].isSelected = true;
      notifyListeners();
    } else if (previousBetIndex != index) {
      betOptions[previousBetIndex].isSelected = false;
      betOptions[index].isSelected = true;
      notifyListeners();
    }
  }

  setIsPressed(bool val, int index) {
    cardList[index].isPressed = val;
    notifyListeners();
  }

  void onPressed(int index) {
    setIsPressed(true, index);
  }

  Future<void> onReleased(int index) async {
    await Future.delayed(const Duration(milliseconds: 200));
    setIsPressed(false, index);
  }

  Future<void> onTapOncard(BuildContext context, int index) async {
    var selctedBet =
        betOptions.indexWhere((element) => element.isSelected ?? false);
    if (selctedBet != -1) {
      if (creditBalance >= (betOptions[selctedBet].price ?? 0)) {
        creditBalance -= betOptions[selctedBet].price ?? 0;
        await SaveData.saveCredit(creditBalance);
        changeCardBetCount(index, selctedBet);
        notifyListeners();
      } else {
        showMessage("Credit Balance Not Enough to bet.");
      }
    } else {
      showMessage("Select a bet.");
    }
  }

  Future<void> addRecord(int randomIndex) async {
    var sumOfTenToken = cardList.fold(
        0, (previousValue, element) => previousValue + element.numTenTokens!);
    var sumOfFiftyToken = cardList.fold(
        0, (previousValue, element) => previousValue + element.numFiftyTokens!);
    var sumOfHundredToken = cardList.fold(0,
        (previousValue, element) => previousValue + element.numHundredTokens!);
    var sumOfFiveHundredToken = cardList.fold(
        0,
        (previousValue, element) =>
            previousValue + element.numFiveHundredTokens!);
    totalAmount = (sumOfTenToken * 10) +
        (sumOfFiftyToken * 50) +
        (sumOfHundredToken * 100) +
        (sumOfFiveHundredToken * 500);
    var randomCard = cardList[randomIndex];
    var winningAmount = ((randomCard.numTenTokens ?? 0) * 10) +
        ((randomCard.numFiftyTokens ?? 0) * 50) +
        ((randomCard.numHundredTokens ?? 0) * 100) +
        ((randomCard.numFiveHundredTokens ?? 0) * 500);
    var finalAmount = (winningAmount*2) - totalAmount;
    final firestore = FirebaseFirestore.instance;
    gameTime = DateTime.now();

    await firestore.collection('games').add({
      'insert_date_time': gameTime,
      'result_index': randomIndex,
      'amount': finalAmount
    }).then((value) async {
      setIsSpinLoading = true;
      await showSpinDialog();
    });
  }

  void changeCardBetCount(int cardIndex, int betIndex) {
    switch (betIndex) {
      case 0:
        cardList[cardIndex].numTenTokens =
            cardList[cardIndex].numTenTokens! + 1;
        break;
      case 1:
        cardList[cardIndex].numFiftyTokens =
            cardList[cardIndex].numFiftyTokens! + 1;
        break;
      case 2:
        cardList[cardIndex].numHundredTokens =
            cardList[cardIndex].numHundredTokens! + 1;
        break;
      case 3:
        cardList[cardIndex].numFiveHundredTokens =
            cardList[cardIndex].numFiveHundredTokens! + 1;
        break;
      default:
    }
  }

  int secondsRemaining = 60;
  late Timer timer;

  Future<void> initiatePage(BuildContext context) async {
    gameContext = context;
    startTimer();
    await insertCredits();
  }

  Future<void> insertCredits() async {
    var userCredit = await SaveData.getCredit();
    if (userCredit != null) {
      setCreditBalance = userCredit;
    } else {
      await SaveData.saveCredit(4000);
      setCreditBalance = 4000;
    }
  }

  clearAllNumOfToken() {
    for (var card in cardList) {
      card.numTenTokens = 0;
      card.numFiftyTokens = 0;
      card.numHundredTokens = 0;
      card.numFiveHundredTokens = 0;
    }
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (kDebugMode) {
        print(secondsRemaining);
      }
      if (secondsRemaining > 0) {
        secondsRemaining--;
        notifyListeners();
      }
      if (secondsRemaining == 10) {
        generateRandomNumber();
      } else if (secondsRemaining == 3) {
        showResult();
      }
    });
  }

  Future<void> generateRandomNumber() async {
    randomInt = Random().nextInt(11) + 1;
     // Generates a random integer between 0 and 99
    if (kDebugMode) {
      print('Random Integer: $randomInt');
    }
    await addRecord(randomInt);
  }

  Future<void> showResult() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DateTime dateTime = DateTime(gameTime.year, gameTime.month, gameTime.day,
        gameTime.hour, gameTime.minute);

    QuerySnapshot querySnapshot = await firestore
        .collection('games')
        .where('insert_date_time', isGreaterThanOrEqualTo: dateTime)
        .where('insert_date_time',
            isLessThan: dateTime.add(const Duration(minutes: 1)))
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        Timestamp timestamp = data['insert_date_time'];
        DateTime dateTime = timestamp.toDate(); // Convert to DateTime
        resultModel = ResultModel.fromJson(data);
        debugPrint('Amount: ${data['amount']}');
        debugPrint('Result Index: ${data['result_index']}');
        debugPrint('Insert Date Time: $dateTime');
        break;
      }
      showResultDialog();
    }
  }

  //For showing spining dialog
  Future<void> showSpinDialog() async {
    showGeneralDialog(
      barrierLabel: "Spin",
      barrierDismissible: false,
      context: gameContext,
      pageBuilder: (context, an, bc) => const SpinDialog(),
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, anim, _, child) => ScaleTransition(
        scale: Tween(begin: 0.0, end: 1.0).animate(anim),
        child: child,
      ),
    );
  }

  //For showing result dialog
  Future<void> showResultDialog() async {
    showGeneralDialog(
      barrierLabel: "Win",
      barrierDismissible: false,
      context: gameContext,
      pageBuilder: (context, an, bc) => const ResultDialog(),
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, anim, _, child) => ScaleTransition(
        scale: Tween(begin: 0.0, end: 1.0).animate(anim),
        child: child,
      ),
    ).then((value) async {
      if ((resultModel.amount??0) > 0) {
        creditBalance += (resultModel.amount??0);
        await SaveData.saveCredit(creditBalance);
        notifyListeners();
      }
      setIsSpinLoading = false;
      secondsRemaining = 60;
      clearAllNumOfToken();
      notifyListeners();
    });
  }

  showMessage(String message) {
    Size size = MediaQuery.of(gameContext).size;
    Fluttertoast.showToast(
        msg: message,
        fontSize: size.width * 0.05,
        textColor: Colors.black87,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.amber);
  }
}
