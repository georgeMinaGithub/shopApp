import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/home_screen.dart';
import 'package:shop_app/module/login/login_screen.dart';
import 'package:shop_app/module/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/module/splash/splash_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/componnetns/constants.dart';
import 'package:shop_app/shared/mode_cubit/cubit.dart';
import 'package:shop_app/shared/mode_cubit/state.dart';
import 'package:shop_app/shared/network/cach_helper.dart';
import 'package:shop_app/shared/network/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  // BlocOverrides.runZoned(
  //       () {},
  //   blocObserver: MyBlocObserver() ,
  // );
  DioHelper.init();
  await CacheHelper.init();

  late bool? isDark = CacheHelper.getBoolean(key: 'isDark');

  Widget widget;

  late  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

  token = CacheHelper.getData(key: 'token');

  if(onBoarding != null)
  {
    if(token != null)
    {
      widget = HomeScreen() ;
    }
    else
    {
      widget = LoginScreen();
    }
  }
  else
  {
    widget = const OnBoardingScreen() ;
  }

  runApp(Myapp(
    startWidget: widget ,
    isDark: isDark,
  ));
}

class Myapp extends StatelessWidget {
  final  bool? isDark;
  final Widget startWidget;

  const Myapp({Key? key, required this.startWidget, this.isDark}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => MainCubit()
              ..getHomeData()
              ..getCategoriesData()
              ..getFavoritesData()
              ..getUserData()
              ..getCartData()
        ) ,
        BlocProvider(
          create: (context) => ModeCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ) ,
      ],
      child: BlocConsumer<ModeCubit, ModeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ModeCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(
              splash:  const SplashScreen() ,
              backgroundColor:
              ModeCubit.get(context).backgroundColor.withOpacity(1),
              nextScreen: startWidget,
              animationDuration: const Duration(milliseconds: 2000),
              splashTransition: SplashTransition.scaleTransition,
            ),
          );
        },
      ),
    );
  }
}
