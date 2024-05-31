class SettingsModel {
  SettingsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<SettingsData> data;

  factory SettingsModel.fromJson(Map<String, dynamic> json){
    return SettingsModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? [] : List<SettingsData>.from(json["data"]!.map((x) => SettingsData.fromJson(x))),
    );
  }

}

class SettingsData {
  SettingsData({
    required this.id,
    required this.mobile1,
    required this.mobile2,
    required this.whatsappNo,
    required this.landline1,
    required this.landline2,
    required this.email1,
    required this.email2,
    required this.facebook,
    required this.twitter,
    required this.youtube,
    required this.googlePlus,
    required this.instagram,
    required this.latitude,
    required this.logitude,
    required this.address,
    required this.insertDate,
    required this.reffer,
    required this.convenienceFee,
  });

  final String? id;
  final String? mobile1;
  final String? mobile2;
  final String? whatsappNo;
  final String? landline1;
  final String? landline2;
  final String? email1;
  final String? email2;
  final String? facebook;
  final String? twitter;
  final String? youtube;
  final String? googlePlus;
  final String? instagram;
  final String? latitude;
  final String? logitude;
  final String? address;
  final DateTime? insertDate;
  final String? reffer;
  final String? convenienceFee;

  factory SettingsData.fromJson(Map<String, dynamic> json){
    return SettingsData(
      id: json["id"],
      mobile1: json["mobile_1"],
      mobile2: json["mobile_2"],
      whatsappNo: json["whatsapp_no"],
      landline1: json["landline_1"],
      landline2: json["landline_2"],
      email1: json["email_1"],
      email2: json["email_2"],
      facebook: json["facebook"],
      twitter: json["twitter"],
      youtube: json["youtube"],
      googlePlus: json["google_plus"],
      instagram: json["instagram"],
      latitude: json["latitude"],
      logitude: json["logitude"],
      address: json["address"],
      insertDate: DateTime.tryParse(json["insert_date"] ?? ""),
      reffer: json["reffer"],
      convenienceFee: json["convenience_fee"],
    );
  }

}
