// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  String? status;
  List<Transaction>? transaction;

  TransactionModel({
    this.status,
    this.transaction,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        status: json["status"],
        transaction: json["transaction"] == null
            ? []
            : List<Transaction>.from(
                json["transaction"]!.map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "transaction": transaction == null
            ? []
            : List<dynamic>.from(transaction!.map((x) => x.toJson())),
      };
}

class Transaction {
  String? id;
  String? disUserId;
  String? disAmount;
  String? transType;
  String? transMethod;
  String? transStatus;
  String? transItem;
  String? dateCreated;
  String? day;
  String? month;
  String? year;
  String? time;
  String? docName;

  Transaction({
    this.id,
    this.disUserId,
    this.disAmount,
    this.transType,
    this.transMethod,
    this.transStatus,
    this.transItem,
    this.dateCreated,
    this.day,
    this.month,
    this.year,
    this.time,
    this.docName,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        disUserId: json["dis_user_id"],
        disAmount: json["dis_amount"],
        transType: json["trans_type"],
        transMethod: json["trans_method"],
        transStatus: json["trans_status"],
        transItem: json["transItem"],
        dateCreated: json["date_created"],
        day: json["day"],
        month: json["month"],
        year: json["year"],
        time: json["time"],
        docName: json["doc_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dis_user_id": disUserId,
        "dis_amount": disAmount,
        "trans_type": transType,
        "trans_method": transMethod,
        "trans_status": transStatus,
        "transItem": transItem,
        "date_created": dateCreated,
        "day": day,
        "month": month,
        "year": year,
        "time": time,
        "doc_name": docName,
      };
}
