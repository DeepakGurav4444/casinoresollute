import 'package:fireabase_demo/provider/spin_dialog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:provider/provider.dart';
import '../../../provider/game_page_provider.dart';

class SpinDialog extends StatefulWidget {
  const SpinDialog({super.key});

  @override
  State<SpinDialog> createState() => _SpinDialogState();
}

class _SpinDialogState extends State<SpinDialog> {
  late SpinDialogProvider spinProvider;
  @override
  void initState() {
    var gameProvider = Provider.of<GamePageProvider>(context, listen: false);
    spinProvider = Provider.of<SpinDialogProvider>(context, listen: false);
    spinProvider.initiateValue(gameProvider.randomInt);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<GamePageProvider>(
        builder: (context, gameModel, child) => Consumer<SpinDialogProvider>(
          builder: (context, spinModel, child) => Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: size.width * 0.85,
                width: size.width * 0.85,
                padding: EdgeInsets.all(size.width * 0.05),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FortuneWheel(
                  duration: const Duration(seconds: 5),
                  onAnimationEnd: () => Navigator.pop(context),
                  selected: spinModel.selectedStream,
                  rotationCount: 6,
                  items: List.generate(
                    gameModel.cardList.length,
                    (index) => FortuneItem(
                        child: Text(
                          gameModel.cardList[index].cardName ?? "",
                          style: TextStyle(
                              fontSize: size.width * 0.06,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        style: FortuneItemStyle(
                          color: index % 2 == 0
                              ? const Color(0xFFd01c17)
                              : const Color(0xFF0a0001),
                          borderColor: Colors.white,
                          borderWidth: 2.0,
                          textAlign: TextAlign.right,
                        )),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    spinProvider.selectedStreamController.close();
    super.dispose();
  }
}
