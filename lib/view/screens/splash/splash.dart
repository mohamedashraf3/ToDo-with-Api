import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:note_application/view/screens/statistics/statistics_screen.dart';
import 'package:note_application/view_model/utils/app_colors.dart';
import '../../../view_model/data/local/shared_prefrence/shared_keys.dart';
import '../../../view_model/data/local/shared_prefrence/shared_prefrence.dart';
import '../../../view_model/utils/imgs.dart';
import '../../components/customs/text_custom.dart';
import '../login/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color(0xff303030),
      animationDuration: const Duration(seconds: 3),
      splash: Column(
        children: [
          Expanded(child: Image.asset(Imgs.splash, height: 400, width: 300)),
          const SizedBox(height: 10,),
          const TextCustom(
            text: "To Do App",
            color: AppColors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
      splashIconSize: 250,
      nextScreen: (LocalData.get(SharedKeys.isLogin) ?? false)
          ? const StatisticsScreen()
          : const LoginScreen(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
