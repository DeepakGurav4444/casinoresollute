import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireabase_demo/utils/models/result_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatisticsProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  List<ResultModel>? gameModelList;

  set setResults(List<ResultModel> val) {
    gameModelList = val;
    notifyListeners();
  }

  Future<void> fetchAllGames() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('games')
        .orderBy('insert_date_time', descending: true)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs
          .map((document) => document.data() as Map<String, dynamic>)
          .toList();
      setResults = data.map((e) => ResultModel.fromJson(e)).toList();
    } else {
      setResults = [];
    }
  }

  String getFormatedDate(int index) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        gameModelList![index].insertDateTime!.millisecondsSinceEpoch);
    return DateFormat('dd-MMM-yy hh:mm a').format(dateTime);
  }
}
