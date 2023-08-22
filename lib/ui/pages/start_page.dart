import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/start_page_provider.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset("assets/images/game_background.jpg").image,
              fit: BoxFit.cover),
        ),
        child: Consumer<StartPageProvider>(
          builder: (context, startModel, child) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildButton(size, context, startModel, "NEW GAME",
                    onTap: startModel.goToGamePage),
                buildButton(
                  size,
                  context,
                  startModel,
                  "STATISTICS",
                  onTap: startModel.goToStatisticsPage,
                ),
                buildButton(size, context, startModel, "EXIT",
                    onTap: startModel.exitGame),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(Size size, BuildContext context,
      StartPageProvider startModel, String btnText,
      {Function? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
      child: SizedBox(
          height: size.width * 0.14,
          width: size.width * 0.5,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                backgroundColor: MaterialStateProperty.resolveWith((states) =>
                    states.contains(MaterialState.pressed)
                        ? Colors.orange
                        : Colors
                            .white) //MaterialStateProperty.all<Color>(Colors.white),
                ),
            onPressed: () async => await onTap!(context),
            child: Text(
              btnText,
              style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          )),
    );
  }
}
