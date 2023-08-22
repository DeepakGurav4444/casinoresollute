import 'package:cloud_firestore/cloud_firestore.dart';
class ResultModel {
  int? amount;
  Timestamp? insertDateTime;
  int? resultIndex;

  ResultModel({this.amount, this.insertDateTime, this.resultIndex});

  ResultModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    insertDateTime = json['insert_date_time'];
    resultIndex = json['result_index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['insert_date_time'] = insertDateTime;
    data['result_index'] = resultIndex;
    return data;
  }
}
