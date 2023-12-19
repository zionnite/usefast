// To parse this JSON data, do
//
//     final flutterWaveBillModelCables = flutterWaveBillModelCablesFromJson(jsonString);

import 'dart:convert';

FlutterWaveBillModelCables flutterWaveBillModelCablesFromJson(String str) =>
    FlutterWaveBillModelCables.fromJson(json.decode(str));

String flutterWaveBillModelCablesToJson(FlutterWaveBillModelCables data) =>
    json.encode(data.toJson());

class FlutterWaveBillModelCables {
  String? status;
  String? message;
  List<Datum>? data;

  FlutterWaveBillModelCables({
    this.status,
    this.message,
    this.data,
  });

  factory FlutterWaveBillModelCables.fromJson(Map<String, dynamic> json) =>
      FlutterWaveBillModelCables(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? billerCode;
  String? name;
  double? defaultCommission;
  DateTime? dateAdded;
  Country? country;
  bool? isAirtime;
  String? billerName;
  String? itemCode;
  String? shortName;
  int? fee;
  bool? commissionOnFee;
  LabelName? labelName;
  double? amount;

  Datum({
    this.id,
    this.billerCode,
    this.name,
    this.defaultCommission,
    this.dateAdded,
    this.country,
    this.isAirtime,
    this.billerName,
    this.itemCode,
    this.shortName,
    this.fee,
    this.commissionOnFee,
    this.labelName,
    this.amount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        billerCode: json["biller_code"],
        name: json["name"],
        defaultCommission: json["default_commission"]?.toDouble(),
        dateAdded: json["date_added"] == null
            ? null
            : DateTime.parse(json["date_added"]),
        country: countryValues.map[json["country"]]!,
        isAirtime: json["is_airtime"],
        billerName: json["biller_name"],
        itemCode: json["item_code"],
        shortName: json["short_name"],
        fee: json["fee"],
        commissionOnFee: json["commission_on_fee"],
        labelName: labelNameValues.map[json["label_name"]]!,
        amount: json["amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "biller_code": billerCode,
        "name": name,
        "default_commission": defaultCommission,
        "date_added": dateAdded?.toIso8601String(),
        "country": countryValues.reverse[country],
        "is_airtime": isAirtime,
        "biller_name": billerName,
        "item_code": itemCode,
        "short_name": shortName,
        "fee": fee,
        "commission_on_fee": commissionOnFee,
        "label_name": labelNameValues.reverse[labelName],
        "amount": amount,
      };
}

enum Country { NG }

final countryValues = EnumValues({"NG": Country.NG});

enum LabelName {
  ACCOUNT_NUMBER,
  LCC_NUMBER,
  METER_NUMBER,
  MOBILE_NUMBER,
  NUMBER,
  SMARTCARD_NUMBER,
  SMART_CARD_NUMBER,
  TAX_IDENTIFICATION_NUMBER_TIN
}

final labelNameValues = EnumValues({
  "Account Number": LabelName.ACCOUNT_NUMBER,
  "Lcc Number": LabelName.LCC_NUMBER,
  "Meter Number": LabelName.METER_NUMBER,
  "Mobile Number": LabelName.MOBILE_NUMBER,
  "Number": LabelName.NUMBER,
  "Smartcard Number": LabelName.SMARTCARD_NUMBER,
  "SmartCard Number": LabelName.SMART_CARD_NUMBER,
  "Tax Identification Number (TIN)": LabelName.TAX_IDENTIFICATION_NUMBER_TIN
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
