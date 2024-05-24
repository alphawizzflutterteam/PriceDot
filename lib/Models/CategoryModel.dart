class CategoryModel {
  CategoryModel({
    required this.msg,
    required this.status,
    required this.data,
  });

  final String? msg;
  final bool? status;
  final List<CatData> data;

  factory CategoryModel.fromJson(Map<String, dynamic> json){
    return CategoryModel(
      msg: json["msg"],
      status: json["status"],
      data: json["data"] == null ? [] : List<CatData>.from(json["data"]!.map((x) => CatData.fromJson(x))),
    );
  }

}

class CatData {
  CatData({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.insertDate,
    required this.status,
  });

  final String? categoryId;
  final String? categoryName;
  final String? categoryImage;
  final DateTime? insertDate;
  final String? status;

  factory CatData.fromJson(Map<String, dynamic> json){
    return CatData(
      categoryId: json["category_id"],
      categoryName: json["category_name"],
      categoryImage: json["category_image"],
      insertDate: DateTime.tryParse(json["insert_date"] ?? ""),
      status: json["status"],
    );
  }

}
