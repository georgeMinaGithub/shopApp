
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/state.dart';
import 'package:shop_app/model/cart/add_cart_model.dart';
import 'package:shop_app/model/cart/get_cart_model.dart';
import 'package:shop_app/model/cart/update_cart_model.dart';
import 'package:shop_app/model/category/category_details_model.dart';
import 'package:shop_app/model/category/category_model.dart';
import 'package:shop_app/model/favorite/favorite_model.dart';
import 'package:shop_app/model/home/home_model.dart';
import 'package:shop_app/model/login/login_model.dart';
import 'package:shop_app/module/Categories/category.dart';
import 'package:shop_app/module/Favorites/favorite.dart';
import 'package:shop_app/module/Products_Home/product_Home.dart';
import 'package:shop_app/module/setting/setting.dart';
import 'package:shop_app/shared/componnetns/components.dart';
import 'package:shop_app/shared/componnetns/constants.dart';
import 'package:shop_app/shared/network/dio_helper.dart';
import 'package:shop_app/shared/network/end_point.dart';



class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitialStates());
  static MainCubit get(context) => BlocProvider.of(context);

  Map<dynamic, dynamic> favorites = {};
  Map<dynamic, dynamic> cart = {};

  int currentIndex = 0;

  List<Widget> pages = [
    ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const SettingScreen(),
  ];

  void ChangeNavBar(int index) {
    currentIndex = index;
    emit(ChangeNavBarItem());
  }

  late LoginModel? UserData  ;

  void getUserData() {
    emit(UserLoginLoadingStates());

    DioHelper.getData(
      url: profile,
      token: token,
    ).then((value) {
      UserData = LoginModel.fromJson(value.data);
      emit(UserLoginSuccessStates(UserData!));
    }).catchError((error) {
      debugPrint(error.toString());
      emit(UserLoginErrorStates(error.toString()));
    });
  }

  void UpdateUserData({
    required String email,
    required String name,
    required String phone,
    String? image,
  }) {
    emit(UserUpdateLoadingStates());
    DioHelper.putData(
      url: update,
      token: token,
      data: {
        'email': email,
        'name': name,
        'phone': phone,
      },
    ).then((value) {
      UserData = LoginModel.fromJson(value.data);
      emit(UserUpdateSuccessStates(UserData!));
    }).catchError((error) {
      print(error.toString());
      emit(UserUpdateErrorStates(error.toString()));
    });
  }

  late HomeModel? homeModel = null ;

  void getHomeData() {
    emit(HomeLoadingStates());
    DioHelper.getData(
      url: home,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      //printFullText(homeModel.data.banners.toString());
      if (kDebugMode) {
        print(homeModel!.status);
        print(token);
      }

      for (var element in homeModel!.data!.products)
      {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      }
      for (var element in homeModel!.data!.products)
      {
        cart.addAll({
          element.id: element.inCart,
        });
      }
      emit(HomeSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorStates());
    });
  }

  late CategoriesModel? categoriesModel = null ;
  void getCategoriesData() {
    DioHelper.getData(
      url: categories,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(CategoriesSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(CategoriesErrorStates());
    });
  }

  late CategoryDetailModel? categoriesDetailModel ;
  void getCategoriesDetailData(int categoryID) {
    emit(CategoryDetailsLoadingStates());
    DioHelper.getData(url: "categories/$categoryID", query: {
      'category_id': '$categoryID',
    }).then((value) {
      categoriesDetailModel = CategoryDetailModel.fromJson(value.data);
      for (var element in categoriesDetailModel!.data!.productData!) {}
      if (kDebugMode) {
        print('categories Detail ${categoriesDetailModel!.status}');
      }
      emit(CategoryDetailsSuccessStates());
    }).catchError((error) {
      emit(CategoryDetailsErrorStates());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

// changeCart
  late ChangeCartModel? changeCartModel ;
  void changeCart(int productId) {
    // cart[productId] = !cart[productId];
    emit(ChangeCartStates());
    DioHelper.postData(
      url: carts,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeCartModel = ChangeCartModel.fromJson(value.data);
      // print('changeCartModel ' + changeCartModel.status.toString());
      if (changeCartModel!.status!)
      {
        getCartData();
        getHomeData();
      }
      else
      {
        showToast(
          text: changeCartModel!.message!,
          state: ToastStates.success,
        );
      }
      emit(ChangeCartSuccessStates(changeCartModel!));
    }).catchError((error) {
      emit(ChangeCartErrorStates());
      if (kDebugMode)
      {
        print(error.toString());
      }
    });
  }

  // get cart data
  late CartModel? cartModel = [] as CartModel?;

  void getCartData() {
    emit(CartLoadingStates());
    DioHelper.getData(url: carts, token: token).then((value) {
      cartModel = CartModel.fromJson(value.data);
      // print('Get Cart'+cartModel.toString());
      emit(GetCartSuccessStates());
    }).catchError((error) {
      if (kDebugMode)
      {
        print(error.toString());
      }
      emit(GetCartErrorStates());
    });
  }

// update cart
 late  UpdateCartModel? updateCartModel;
  void updateCartData(int id, int quantity) {
    emit(UpdateCartLoadingStates());
    DioHelper.putData(
            url: 'carts/$id',
            data: {
              'quantity': '$quantity',
            },
            token: token)
        .then((value) {
      updateCartModel = UpdateCartModel.fromJson(value.data);
      if (updateCartModel!.status!)
      {
        getCartData();
      }
      else
      {
        showToast(
          text: updateCartModel!.message!,
          state: ToastStates.success,
        );
      }
      //  print('updateCartModel ' + updateCartModel.status.toString());
      emit(UpdateCartSuccessStates());
    }).catchError((error) {
      emit(UpdateCartErrorStates());
      if (kDebugMode)
      {
        print(error.toString());
      }
    });
  }

  late ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productID) {
    favorites[productID] = !favorites[productID];
    emit(ChangeFavoritesStates());

    DioHelper.postData(
        url: favorite,
        token: token,
        data:
        {
         'product_id': productID,
        }).then((value)
      {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (kDebugMode)
      {
        print(value.data);
      }

      if (!changeFavoritesModel!.status!)
      {
        favorites[productID] = !favorites[productID];
      }
      else
      {
        getFavoritesData();
      }
      emit(ChangeFavoritesSuccessStates(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productID] = !favorites[productID];
      emit(ChangeFavoritesErrorStates());
    });
  }

  late FavoritesModel? favoritesModel;

  void getFavoritesData() {
    emit(FavoritesLoadingStates());
    DioHelper.getData(
      url: favorite,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(GetFavoritesSuccessStates());
    }).catchError((error) {
      if (kDebugMode)
      {
        print(error.toString());
      }
      emit(GetFavoritesErrorStates());
    });
  }

 late  ProductResponse? productResponse;
  Future getProductData(productId) async {
    productResponse ;
    emit(ProductLoadingStates());
    return await DioHelper.getData(url: 'products/$productId', token: token)
        .then((value) {
      productResponse = ProductResponse.fromJson(value.data);
      //print('Product Detail '+productsModel.status.toString());
      emit(ProductSuccessStates(productResponse!));
    }).catchError((error) {
      emit(ProductErrorStates());
      if (kDebugMode) {
          print(error.toString());
      }
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void ShowPassword() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ShowPasswordStates());
  }
}
