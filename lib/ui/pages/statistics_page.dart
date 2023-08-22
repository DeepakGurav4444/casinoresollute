import 'package:fireabase_demo/provider/statistics_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    var statProvider = Provider.of<StatisticsProvider>(context, listen: false);
    statProvider.fetchAllGames();
    super.initState();
  }

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
        child: SafeArea(
          child: Consumer<StatisticsProvider>(
            builder: (context, statModel, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(size.height * 0.05),
                  child: Text(
                    "STATISTICS",
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: const Color(0xFFc59d5f), width: 4),
                      color: const Color(0xFFf7e7ac),
                    ),
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: size.height * 0.7,
                        child: statModel.gameModelList != null
                            ? statModel.gameModelList!.isNotEmpty
                                ? Theme(
                                    data: ThemeData(
                                        scrollbarTheme: ScrollbarThemeData(
                                            thumbColor:
                                                MaterialStatePropertyAll(
                                                    const Color(0xFFc59d5f)
                                                        .withOpacity(0.5)))),
                                    child: Scrollbar(
                                      controller: statModel.scrollController,
                                      thickness: size.width * 0.025,
                                      thumbVisibility: true,
                                      radius: const Radius.circular(5),
                                      child: ListView.builder(
                                        controller: statModel.scrollController,
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                          subtitle: Text(
                                            statModel.getFormatedDate(index),
                                            style: TextStyle(
                                                fontSize: size.width * 0.04,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54),
                                          ),
                                          trailing: Text(
                                            "${statModel.gameModelList![index].amount!.abs()}",
                                            style: TextStyle(
                                              fontSize: size.width * 0.045,
                                              fontWeight: FontWeight.w700,
                                              color: (statModel
                                                              .gameModelList![
                                                                  index]
                                                              .amount ??
                                                          0) >
                                                      0
                                                  ? Colors.green
                                                  : (statModel
                                                                  .gameModelList![
                                                                      index]
                                                                  .amount ??
                                                              0) ==
                                                          0
                                                      ? Colors.deepOrange
                                                      : Colors.red,
                                            ),
                                          ),
                                          title: Text(
                                            (statModel.gameModelList![index]
                                                            .amount ??
                                                        0) >
                                                    0
                                                ? "YOU WON"
                                                : (statModel
                                                                .gameModelList![
                                                                    index]
                                                                .amount ??
                                                            0) ==
                                                        0
                                                    ? "YOU GET STALEMATED"
                                                    : "YOU LOSE",
                                            style: TextStyle(
                                                fontSize: size.width * 0.045,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87),
                                          ),
                                        ),
                                        itemCount:
                                            statModel.gameModelList!.length,
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Games not found.",
                                    style: TextStyle(
                                        fontSize: size.width * 0.06,
                                        color: Colors.brown,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
