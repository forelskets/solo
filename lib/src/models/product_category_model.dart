class ProductCateModel {
  String responseCode;
  String message;
  List<Category> category;
  String status;

  ProductCateModel({this.responseCode, this.message, this.category, this.status});

  ProductCateModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Category {
  String id;
  String cName;
  String image;

  Category({this.id, this.cName, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cName = json['c_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['c_name'] = this.cName;
    data['image'] = this.image;
    return data;
  }
}