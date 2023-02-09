
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/state.dart';
import 'package:shop_app/module/edit/edit.dart';
import 'package:shop_app/module/login/login_screen.dart';
import 'package:shop_app/shared/componnetns/components.dart';
import 'package:shop_app/shared/mode_cubit/cubit.dart';
import 'package:shop_app/shared/styles/icon_broken.dart';
import '../../shared/componnetns/constants.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    bool value = false;

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {
        if (state is UserLoginSuccessStates) {}
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      height: 200,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Image(image: AssetImage('assets/images/th .jpg'),),
                        ),

                      ),
                    ),
                  ],
                ),
                space(0, 20),
                InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.TOPSLIDE,
                      title: 'Do you want to change mode?',
                      btnOkOnPress: () {
                        ModeCubit.get(context).changeAppMode();
                      },
                      btnCancelOnPress: () {},
                    ).show();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.dark_mode_outlined,
                          color: Colors.deepOrange,
                          size: 35,
                        ),
                        space(15, 0),
                        const Text(
                          'Theme Mode',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Spacer(),
                        Switch(
                          value: value,
                          onChanged: (value) {
                            ModeCubit.get(context).changeAppMode();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    navigateTo(context, EditScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        const Icon(
                          IconBroken.Profile,
                          color: Colors.deepOrange,
                          size: 35,
                        ),
                        space(15, 0),
                         Text(
                          'My Profile',
                           style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.RIGHSLIDE,
                      title: 'Do you want to Logout?',
                      desc: "Please, Login soon 🤚",
                      btnOkOnPress: () {
                        logOut(context);
                      },
                      btnCancelOnPress: () {},
                    ).show();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        const Icon(
                          IconBroken.Logout,
                          color: Colors.deepOrange,
                          size: 35,
                        ),
                        space(15, 0),
                        TextButton(
                          onPressed: ()
                          {
                            navigateAndFinish(context, LoginScreen());
                          },
                          child:  Text(
                            'Log Out',
                            style: Theme.of(context).textTheme.bodyText1,
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
