// ignore_for_file: unnecessary_new

class UpdateCartModel {
  late  bool? status;
  late  String? message;
  late UpdateData? data;

  UpdateCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new UpdateData.fromJson(json['data']) : null;
  }
}

class UpdateData {
  late UpdateCart? cart;
  late dynamic subTotal;
  late  dynamic total;

  UpdateData.fromJson(Map<String, dynamic> json) {
    cart = json['cart'] != null ? UpdateCart.fromJson(json['cart']) : null;
    subTotal = json['sub_total'];
    total = json['total'];
  }
}

class UpdateCart {
  late  int? id;
  late  dynamic quantity;
  late  CartProduct? product;

  UpdateCart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product =
        json['product'] != null ? CartProduct.fromJson(json['product']) : null;
  }
}

class CartProduct {
  late  int? id;
  late  dynamic price;
  late  dynamic oldPrice;
  late  dynamic discount;
  late  String? image;

  CartProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
  }
}
