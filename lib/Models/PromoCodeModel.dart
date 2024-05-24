class PromoCodeModel {
  PromoCodeModel({
    required this.msg,
    required this.status,
    required this.data,
  });

  final String? msg;
  final bool? status;
  final List<PromoData> data;

  factory PromoCodeModel.fromJson(Map<String, dynamic> json){
    return PromoCodeModel(
      msg: json["msg"],
      status: json["status"],
      data: json["data"] == null ? [] : List<PromoData>.from(json["data"]!.map((x) => PromoData.fromJson(x))),
    );
  }

}

class PromoData {
  PromoData({
    required this.id,
    required this.promoCode,
    required this.message,
    required this.validFrom,
    required this.validTill,
    required this.noOfUsers,
    required this.discount,
    required this.discountType,
    required this.status,
    required this.insertDate,
    required this.minimumOrderAmount,
    required this.repeatUsage,
    required this.noOfRepeatUsage,
    required this.maxDiscountAmount,
    required this.title,
  });

  final String? id;
  final String? promoCode;
  final String? title;
  final String? message;
  final DateTime? validFrom;
  final DateTime? validTill;
  final String? noOfUsers;
  final String? discount;
  final String? discountType;
  final String? status;
  final DateTime? insertDate;
  final String? minimumOrderAmount;
  final String? repeatUsage;
  final String? noOfRepeatUsage;
  final String? maxDiscountAmount;

  factory PromoData.fromJson(Map<String, dynamic> json){
    return PromoData(
      id: json["id"],
      title: json["title"],
      promoCode: json["promo_code"],
      message: json["message"],
      validFrom: DateTime.tryParse(json["valid_from"] ?? ""),
      validTill: DateTime.tryParse(json["valid_till"] ?? ""),
      noOfUsers: json["no_of_users"],
      discount: json["discount"],
      discountType: json["discount_type"],
      status: json["status"],
      insertDate: DateTime.tryParse(json["insert_date"] ?? ""),
      minimumOrderAmount: json["minimum_order_amount"],
      repeatUsage: json["repeat_usage"],
      noOfRepeatUsage: json["no_of_repeat_usage"],
      maxDiscountAmount: json["max_discount_amount"],
    );
  }

}
