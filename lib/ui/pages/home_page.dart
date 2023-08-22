import 'package:fireabase_demo/provider/game_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GamePageProvider gameProvider;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      gameProvider = Provider.of<GamePageProvider>(context, listen: false);
      gameProvider.initiatePage(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double appBarHeight = AppBar().preferredSize.height;
    double navigationButtonHeight = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset("assets/images/game_background.jpg").image,
              fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Consumer<GamePageProvider>(
            builder: (context, gameModel, child) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.24,
                      height: appBarHeight - size.width * 0.02,
                      margin: EdgeInsets.only(
                          left: size.width * 0.01, right: size.width * 0.005),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: gameModel.secondsRemaining > 30
                            ? Colors.green
                            : gameModel.secondsRemaining > 10
                                ? Colors.yellow
                                : Colors.red,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        shape: BoxShape.circle,
                        // borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${gameModel.secondsRemaining}",
                        style: TextStyle(
                          fontSize: size.width * 0.06,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.65,
                      height: appBarHeight - size.width * 0.02,
                      margin: EdgeInsets.only(
                          right: size.width * 0.01, left: size.width * 0.005),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.lime,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Credits : ${gameModel.creditBalance}",
                        style: TextStyle(
                          fontSize: size.width * 0.06,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.83 -
                      (appBarHeight + navigationButtonHeight),
                  // color: Colors.green,
                  child: GridView.builder(
                    padding: EdgeInsets.all(size.height * 0.01),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns in the grid
                        childAspectRatio:
                            0.5, // Width/Height ratio of each card
                        crossAxisSpacing: size.width * 0.045,
                        mainAxisExtent: size.height * 0.175,
                        mainAxisSpacing: size.height * 0.01),
                    itemCount:
                        gameModel.cardList.length, // Total number of cards
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ExpandedButton(
                            size: size, gameModel: gameModel, index: index),
                      );
                    },
                  ),
                ),
                Container(
                  height: size.height * 0.1,
                  color: Colors.transparent,
                  margin: EdgeInsets.all(size.height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      gameModel.betOptions.length,
                      (index) => SizedBox(
                        width: size.height * 0.1, // Adjust size as needed
                        height: size.height * 0.1, // Adjust size as needed
                        child: GestureDetector(
                          onTap: () async => await gameModel.onTapOnBet(index),
                          child: Card(
                            color: Colors.transparent,
                            elevation: gameModel.betOptions[index].isSelected!
                                ? 4.0
                                : 0,
                            shape: const CircleBorder(),
                            child: Opacity(
                              opacity: gameModel.betOptions[index].isSelected!
                                  ? 1
                                  : 0.5,
                              child: Image.asset(
                                  gameModel.betOptions[index].tokenPath!),
                            ),
                          ),
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
    );
  }

  @override
  void dispose() {
    gameProvider.timer.cancel();
    gameProvider.secondsRemaining = 60;
    super.dispose();
  }
}

class ExpandedButton extends StatelessWidget {
  final GamePageProvider gameModel;
  final int index;
  const ExpandedButton({
    super.key,
    required this.size,
    required this.gameModel,
    required this.index,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTapDown: !gameModel.isSpinLoading
          ? (details) => gameModel.onPressed(index)
          : null,
      onTapUp: !gameModel.isSpinLoading
          ? (details) async => await gameModel.onReleased(index)
          : null,
      onTapCancel: !gameModel.isSpinLoading
          ? () async => await gameModel.onReleased(index)
          : null,
      onTap: !gameModel.isSpinLoading
          ? () async => await gameModel.onTapOncard(context, index)
          : null,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.0)),
            transformAlignment: Alignment.center,
            transform: Matrix4.identity()
              ..scale(gameModel.cardList[index].isPressed ?? false ? 1.2 : 1.0),
            child: Card(
              color: gameModel.cardList[index].isPressed ?? false
                  ? Colors.orange.withOpacity(0.8)
                  : Colors.purple.withOpacity(0.8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.zero,
              child: Center(
                child: Text(
                  '${gameModel.cardList[index].cardName}',
                  style: TextStyle(
                      fontSize: size.width * 0.08,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          // ...List.generate(
          //     gameModel.cardList[index].numTenTokens ?? 0,
          //     (index) =>
          gameModel.cardList[index].numTenTokens != 0
              ? Positioned(
                  top: size.width * 0.02,
                  left: size.width * 0.02,
                  height: size.width * 0.08,
                  width: size.width * 0.12,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 0.5)),
                        child: Image.asset(
                          gameModel.betOptions[0].tokenPath!,
                          height: size.width * 0.048,
                          width: size.width * 0.048,
                        ),
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: " × ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.width * 0.04,
                                color: Colors.white)),
                        TextSpan(
                            text:
                                "${gameModel.cardList[index].numTenTokens ?? 0}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.04,
                              color: Colors.lime,
                            ))
                      ]))
                    ],
                  ))
              : const SizedBox(),
          // ),
          // ...List.generate(
          //     gameModel.cardList[index].numFiftyTokens ?? 0,
          //     (index) =>
          gameModel.cardList[index].numFiftyTokens != 0
              ? Positioned(
                  top: size.width * 0.02,
                  right: size.width * 0.02,
                  height: size.width * 0.08,
                  width: size.width * 0.12,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 0.5)),
                        child: Image.asset(
                          gameModel.betOptions[1].tokenPath!,
                          height: size.width * 0.048,
                          width: size.width * 0.048,
                        ),
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: " × ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.width * 0.04,
                                color: Colors.white)),
                        TextSpan(
                            text:
                                "${gameModel.cardList[index].numFiftyTokens ?? 0}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.04,
                              color: Colors.lime,
                            ))
                      ]))
                    ],
                  ))
              : const SizedBox(),
          // ),
          // ...List.generate(
          gameModel.cardList[index].numHundredTokens != 0
              ?
              // (index) =>
              Positioned(
                  bottom: size.width * 0.02,
                  left: size.width * 0.02,
                  height: size.width * 0.08,
                  width: size.width * 0.12,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 0.5)),
                        child: Image.asset(
                          gameModel.betOptions[2].tokenPath!,
                          height: size.width * 0.048,
                          width: size.width * 0.048,
                        ),
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: " × ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.width * 0.04,
                                color: Colors.white)),
                        TextSpan(
                            text:
                                "${gameModel.cardList[index].numHundredTokens ?? 0}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.04,
                              color: Colors.lime,
                            ))
                      ]))
                    ],
                  ))
              : const SizedBox(),
          // ...List.generate(
          //     gameModel.cardList[index].numFiveHundredTokens ?? 0,
          //     (index) =>
          gameModel.cardList[index].numFiveHundredTokens != 0
              ? Positioned(
                  bottom: size.width * 0.02,
                  right: size.width * 0.02,
                  height: size.width * 0.08,
                  width: size.width * 0.12,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 0.5)),
                        child: Image.asset(
                          gameModel.betOptions[3].tokenPath!,
                          height: size.width * 0.048,
                          width: size.width * 0.048,
                        ),
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: " × ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.width * 0.04,
                                color: Colors.white)),
                        TextSpan(
                            text:
                                "${gameModel.cardList[index].numFiveHundredTokens ?? 0}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.04,
                              color: Colors.lime,
                            ))
                      ]))
                    ],
                  ))
              : const SizedBox(),
        ],
      ),
    ));
  }
}
