class ChangeCartModel {
 late   bool? status;
 late  String? message;
 late AddCartProductData? data;


  ChangeCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =json['data'] != null ?  AddCartProductData.fromJson(json['data']) : null;
  }
}

class AddCartProductData {
  late  int? id;
  late dynamic quantity;
  late CartProduct? product;


  AddCartProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product =json['data'] != null ?  CartProduct.fromJson(json['product']) : null;
  }
}

class CartProduct {
  late int? id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String? image;
  late  String? name;
  late  String? description;


  CartProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}