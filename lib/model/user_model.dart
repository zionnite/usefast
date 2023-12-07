// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

UsersModel usersModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  String? status;
  List<User>? users;

  UsersModel({
    this.status,
    this.users,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        status: json["status"],
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class User {
  String? id;
  String? userName;
  String? fullName;
  String? email;
  String? imageName;
  String? userStatus;
  String? phone;
  String? age;
  String? sex;
  String? address;
  String? dateCreated;
  String? accountName;
  String? accountNumber;
  String? bankName;
  String? bankCode;
  String? currentBalance;
  String? loginStatus;
  bool? adminStatus;
  String? isbankVerify;
  String? status;
  String? totalWorth;
  String? totalWithdrawl;
  String? totalDeposit;

  User({
    this.id,
    this.userName,
    this.fullName,
    this.email,
    this.imageName,
    this.userStatus,
    this.phone,
    this.age,
    this.sex,
    this.address,
    this.dateCreated,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.bankCode,
    this.currentBalance,
    this.loginStatus,
    this.adminStatus,
    this.isbankVerify,
    this.status,
    this.totalWorth,
    this.totalWithdrawl,
    this.totalDeposit,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userName: json["user_name"],
        fullName: json["full_name"],
        email: json["email"],
        imageName: json["image_name"],
        userStatus: json["user_status"],
        phone: json["phone"],
        age: json["age"],
        sex: json["sex"],
        address: json["address"],
        dateCreated: json["date_created"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        bankName: json["bank_name"],
        bankCode: json["bank_code"],
        currentBalance: json["current_balance"],
        loginStatus: json["login_status"],
        adminStatus: json["admin_status"],
        isbankVerify: json["isbank_verify"],
        status: json["status"],
        totalWorth: json["total_worth"],
        totalWithdrawl: json["total_withdrawl"],
        totalDeposit: json["total_deposit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "full_name": fullName,
        "email": email,
        "image_name": imageName,
        "user_status": userStatus,
        "phone": phone,
        "age": age,
        "sex": sex,
        "address": address,
        "date_created": dateCreated,
        "account_name": accountName,
        "account_number": accountNumber,
        "bank_name": bankName,
        "bank_code": bankCode,
        "current_balance": currentBalance,
        "login_status": loginStatus,
        "admin_status": adminStatus,
        "isbank_verify": isbankVerify,
        "status": status,
        "total_worth": totalWorth,
        "total_withdrawl": totalWithdrawl,
        "total_deposit": totalDeposit,
      };
}
