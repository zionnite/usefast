// To parse this JSON data, do
//
//     final accountModel = accountModelFromJson(jsonString);

import 'dart:convert';

List<AccountModel> accountModelFromJson(String str) => List<AccountModel>.from(json.decode(str).map((x) => AccountModel.fromJson(x)));

String accountModelToJson(List<AccountModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccountModel {
  int? totalWorth;
  int? totalWithdrawl;
  int? totalDeposit;

  AccountModel({
    this.totalWorth,
    this.totalWithdrawl,
    this.totalDeposit,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        totalWorth: json["total_worth"],
        totalWithdrawl: json["total_withdrawl"],
        totalDeposit: json["total_deposit"],
      );

  Map<String, dynamic> toJson() => {
        "total_worth": totalWorth,
        "total_withdrawl": totalWithdrawl,
        "total_deposit": totalDeposit,
      };
}
