import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_application/view/screens/splash/splash.dart';
import 'package:note_application/view_model/bloc/cubit/auth/auth_cubit.dart';
import 'package:note_application/view_model/bloc/cubit/to_do_cubit.dart';
import 'package:note_application/view_model/bloc/observer.dart';
import 'package:note_application/view_model/data/local/shared_prefrence/shared_prefrence.dart';
import 'package:note_application/view_model/data/network/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await DioHelper.init();
  await LocalData.init();
  // LocalData.clearData();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ToDoCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: !true,
      ),
    ),
  );
}
