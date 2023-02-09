
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/state.dart';
import 'package:shop_app/model/category/category_model.dart';
import 'package:shop_app/model/home/home_model.dart';
import 'package:shop_app/module/category_details/category_details.dart';
import 'package:shop_app/module/product_detalis/product_details.dart';
import 'package:shop_app/shared/componnetns/components.dart';


class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {
        if (state is ChangeFavoritesSuccessStates) {
          if (state.model.status!) {
            showToast(
              text: state.model.message!,
              state: ToastStates.success,
            );
          } else {
            showToast(
              text: state.model.message!,
              state: ToastStates.error,
            );
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: MainCubit.get(context).homeModel != null &&
              MainCubit.get(context).categoriesModel != null,
          builder: (context) => productsBuilder(
              MainCubit.get(context).homeModel!,
              MainCubit.get(context).categoriesModel!,
              context),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(
          HomeModel homeModel, CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: CarouselSlider(
                items: homeModel.data!.banners
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image(
                              image: NetworkImage('${e.image}'),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  height: 250,
                  initialPage: 0,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlayInterval: const Duration(seconds: 30),
                  autoPlayAnimationDuration: const Duration(seconds: 5),
                  autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                  scrollDirection: Axis.horizontal,

                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 140.0,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Scrollbar(
                      thickness: 1,
                      child: ListView.separated(
                        padding:
                            const EdgeInsetsDirectional.only(start: 10.0, top: 10),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => CategoriesItem(
                            categoriesModel.data!.data[index], context),
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 10.0,
                        ),
                        itemCount: categoriesModel.data!.data.length,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'New Products',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1 / 1.5,
                    children: List.generate(
                      homeModel.data!.products.length,
                      (index) =>
                          GridProducts(homeModel.data!.products[index], context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget CategoriesItem( DataModel dataModel, context) => InkWell(
        onTap: () {
          MainCubit.get(context).getCategoriesDetailData(dataModel.id!);
          navigateTo(context, CategoryProductsScreen(dataModel.name!));
        },
        child: SizedBox(
          width: 105,
          child: Column(
            children: [
              Container(
                width: 95.0,
                height: 82.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.deepOrange, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(
                      dataModel.image!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                dataModel.name!.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );

  Widget GridProducts(ProductModel productModel, context) => InkWell(
        onTap: () {
          MainCubit.get(context)
              .getProductData(productModel.id)
              .then((value) => navigateTo(context, ProductDetailsScreen()));
        },
        child: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.none,
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: NetworkImage(
                        productModel.image!,
                      ),
                      width: double.infinity,
                      height: 150.0,
                    ),
                    Column(
                      children: [
                        Text(
                          productModel.name!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              '${productModel.price.round()} LE',
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(
                              width: 7.0,
                            ),
                            if (productModel.discount != 0)
                              Text(
                                '${productModel.oldPrice.round()}LE',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 0,
              child: IconButton(
                onPressed: () {
                  MainCubit.get(context).changeFavorites(productModel.id!);
                },
                icon: Icon(
                  MainCubit.get(context).favorites[productModel.id]
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: MainCubit.get(context).favorites[productModel.id]
                      ? Colors.red
                      : Colors.grey,
                  size: 26,
                ),
              ),
            ),
            if (productModel.discount != 0)
              Positioned.fill(
                child: Align(
                  alignment: const Alignment(1, -1),
                  child: ClipRect(
                    child: Banner(
                      message: 'OFFERS',
                      textStyle: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                      location: BannerLocation.topStart,
                      color: Colors.red,
                      child: Container(
                        height: 100.0,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
