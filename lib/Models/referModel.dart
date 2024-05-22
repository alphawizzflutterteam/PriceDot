class ReferralModel {
  ReferralModel({
    required this.msg,
    required this.status,
    required this.data,
  });

  final String? msg;
  final bool? status;
  final List<ReferData> data;

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      msg: json["msg"],
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<ReferData>.from(
              json["data"]!.map((x) => ReferData.fromJson(x))),
    );
  }
}

class ReferData {
  ReferData({
    required this.userId,
    required this.userName,
    required this.email,
    required this.mobile,
    required this.password,
    required this.apiKey,
    required this.referralCode,
    required this.referredBy,
    required this.securityPin,
    required this.pinExpiry,
    required this.image,
    required this.address,
    required this.dob,
    required this.walletBalance,
    required this.holdAmount,
    required this.lastUpdate,
    required this.insertDate,
    required this.status,
    required this.verified,
    required this.adf,
    required this.adb,
    required this.pan,
    required this.bettingStatus,
    required this.notificationStatus,
    required this.transferPointStatus,
    required this.fcmId,
    required this.amount,
  });

  final String? userId;
  final String? userName;
  final String? email;
  final String? mobile;
  final String? password;
  final String? apiKey;
  final String? referralCode;
  final String? referredBy;
  final String? securityPin;
  final String? pinExpiry;
  final dynamic image;
  final dynamic address;
  final dynamic dob;
  final String? walletBalance;
  final String? holdAmount;
  final DateTime? lastUpdate;
  final DateTime? insertDate;
  final String? status;
  final String? verified;
  final String? adf;
  final String? adb;
  final String? pan;
  final String? bettingStatus;
  final String? notificationStatus;
  final String? transferPointStatus;
  final String? fcmId;
  final String? amount;

  factory ReferData.fromJson(Map<String, dynamic> json) {
    return ReferData(
      userId: json["user_id"],
      userName: json["user_name"],
      email: json["email"],
      mobile: json["mobile"],
      password: json["password"],
      apiKey: json["api_key"],
      referralCode: json["referral_code"],
      referredBy: json["referred_by"],
      securityPin: json["security_pin"],
      pinExpiry: json["pin_expiry"],
      image: json["image"],
      address: json["address"],
      dob: json["dob"],
      walletBalance: json["wallet_balance"],
      holdAmount: json["hold_amount"],
      lastUpdate: DateTime.tryParse(json["last_update"] ?? ""),
      insertDate: DateTime.tryParse(json["insert_date"] ?? ""),
      status: json["status"],
      verified: json["verified"],
      adf: json["adf"],
      adb: json["adb"],
      pan: json["pan"],
      bettingStatus: json["betting_status"],
      notificationStatus: json["notification_status"],
      transferPointStatus: json["transfer_point_status"],
      fcmId: json["fcm_id"],
      amount: json["amount"].toString(),
    );
  }
}
