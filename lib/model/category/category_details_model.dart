// ignore_for_file: prefer_void_to_null

class CategoryDetailModel {
  late  bool? status;
  late  Data? data;

  CategoryDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = Data.fromJson(json['data']);
  }
}

class Data {
  late  int? currentPage;
  late   List<ProductData>? productData;
  late String? firstPageUrl;
  late  int? from;
  late  int? lastPage;
  late  String? lastPageUrl;
  late  Null nextPageUrl;
  late   String? path;
  late  int? perPage;
  late  Null prevPageUrl;
  late  int? to;
  late  int? total;

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    productData = [];
    json['data'].forEach((element) {
      productData!.add(ProductData.fromJson(element));
    });
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }
}

class ProductData {
  late  int? id;
  late  dynamic price;
  late dynamic oldPrice;
  late  dynamic discount;
  late  String? image;
  late  String? name;
  late  String? description;
  late  List<String>? images;
  late  bool? inFavorites;
  late  bool? inCart;

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'].cast<String>();
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}
