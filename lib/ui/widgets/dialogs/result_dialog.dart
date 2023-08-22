import 'package:fireabase_demo/provider/game_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/result_dialog_provider.dart';
import '../clip_paths/result_top_box_path.dart';

class ResultDialog extends StatefulWidget {
  const ResultDialog({Key? key}) : super(key: key);

  @override
  State<ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<ResultDialog>
    with TickerProviderStateMixin {
  late ResultDialogProvider resultProvider;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      resultProvider =
          Provider.of<ResultDialogProvider>(context, listen: false);
      resultProvider.cardFlipAnimeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
      );
      resultProvider.listenToFlipAnimation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<GamePageProvider>(
        builder: (context, gameModel, child) => Consumer<ResultDialogProvider>(
          builder: (context, winModel, child) => Center(
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    height: size.width * 1.5,
                    width: size.width * 0.8,
                    alignment: Alignment.center,
                    child: Container(
                        padding: EdgeInsets.all(size.width * 0.05),
                        height: size.width * 0.9,
                        width: size.width * 0.7,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFFc59d5f), width: 4),
                          color: const Color(0xFFf7e7ac),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: size.width * 0.05),
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(winModel.getAngle!),
                                child: Container(
                                  height: size.width * 0.28,
                                  width: size.width * 0.2,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    color: Colors.purple.withOpacity(0.8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.grey,
                                    child: Center(
                                      child: Text(
                                        '${gameModel.cardList[gameModel.resultModel.resultIndex ?? 0].cardName}',
                                        style: TextStyle(
                                            fontSize: size.width * 0.08,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: size.width * 0.08,
                                bottom: size.width * 0.05,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: gameModel.totalAmount == 0
                                          ? "Missed Out? Don't Miss the Next One!"
                                          : (gameModel.resultModel.amount ??
                                                      0) >
                                                  0
                                              ? "YOU WON : "
                                              : (gameModel.resultModel.amount ??
                                                          0) ==
                                                      0
                                                  ? "YOU GET STALEMATED : "
                                                  : "YOU LOSE : ",
                                      style: TextStyle(
                                          fontSize: size.width * 0.05,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                    gameModel.totalAmount != 0
                                        ? TextSpan(
                                            text:
                                                "${gameModel.resultModel.amount!.abs()} CREDITS",
                                            style: TextStyle(
                                              fontSize: size.width * 0.05,
                                              fontWeight: FontWeight.w700,
                                              color: (gameModel.resultModel
                                                              .amount ??
                                                          0) >
                                                      0
                                                  ? Colors.green
                                                  : (gameModel.resultModel
                                                                  .amount ??
                                                              0) ==
                                                          0
                                                      ? Colors.deepOrange
                                                      : Colors.red,
                                            ),
                                          )
                                        : const WidgetSpan(
                                            child: SizedBox(),
                                          )
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: size.width * 0.05),
                              child: Container(
                                height: size.width * 0.1,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF338F62),
                                        Color(0xFF07301B)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      tileMode: TileMode.clamp,
                                    )),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                          color: Colors.white, width: 2),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    disabledForegroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: Center(
                                    child: Text(
                                      'NEW GAME',
                                      style: TextStyle(
                                          fontSize: size.width * 0.04,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Positioned(
                    top: size.width * 0.25,
                    left: size.width * 0.1375,
                    child: ClipPath(
                      clipper: ResultTopBoxPath(),
                      child: Container(
                        width: size.width * 0.525,
                        height: size.width * 0.18,
                        alignment: Alignment.center,
                        decoration:
                            const BoxDecoration(color: Color(0xFF6C63FF)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.width * 0.28,
                    left: size.width * 0.275,
                    child: SizedBox(
                      width: size.width * 0.25,
                      child: FittedBox(
                        child: Text(
                          "RESULT",
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    resultProvider.cardFlipAnimeController.dispose();
    super.dispose();
  }
}
