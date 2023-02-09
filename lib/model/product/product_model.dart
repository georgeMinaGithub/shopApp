class ProductDetailsModel {
  late  bool status;
  late  ProductDetailsData data;

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = (json['data'] != null ? ProductDetailsData.fromJson(json['data']) : null)!;
  }

}

class ProductDetailsData {
  late  int id;
  late  dynamic price;
  late  dynamic oldPrice;
  late  dynamic discount;
  late  String image;
  late  String name;
  late  String description;
  late  bool inFavorites;
  late  bool inCart;
  late  List<String> images;



  ProductDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
    images = json['images'].cast<String>();
  }
}