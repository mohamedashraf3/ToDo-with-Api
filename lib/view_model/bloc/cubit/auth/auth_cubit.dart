import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:note_application/view_model/bloc/cubit/to_do_cubit.dart';
import '../../../data/local/shared_prefrence/shared_keys.dart';
import '../../../data/local/shared_prefrence/shared_prefrence.dart';
import '../../../data/network/dio_helper.dart';
import '../../../data/network/end_points.dart';
import '../../../utils/functions.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController confirmPassController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Future<void> loginWithApi({required context}) async {
    LocalData.removeData(SharedKeys.token);
    emit(LoginLoadingState());
    await DioHelper.post(endpoint: EndPoints.login, body: {
      "email": emailController.text,
      "password": passwordController.text,
    }).then((value) {
      print(value?.data);
      saveDataToLocal(value?.data);
      emit(LoginSuccessState());
      Functions.showSuccessToast(
          context: context, msg: "logged in successfully");
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        print(error.response?.data);
        if (error.response?.data != null &&
            error.response?.data.containsKey('errors')) {
          if (error.response?.data['errors'].containsKey('email')) {
            Functions.showErrorToast(
              msg: error.response?.data['errors']['email'][0].toString() ??
                  'Error on Login',
              context: context,
            );
          } else {
            Functions.showErrorToast(
              msg: 'Wrong Password',
              context: context,
            );
          }
        } else {
          Functions.showErrorToast(
            msg: 'Error on Login',
            context: context,
          );
        }
      }
      emit(LoginErrorState());
      throw error;
    });
  }

  Future<void> logoutWithApi({required context}) async {
    emit(LogoutLoadingState());
    await DioHelper.post(
            endpoint: EndPoints.logout, token: LocalData.get(SharedKeys.token))
        .then((value) {
      print(value?.data);
      emit(LogoutSuccessState());
      Functions.showSuccessToast(
        context: context,
        msg: "logged out successfully",
      );
      LocalData.clearData();
      ToDoCubit.get(context).isLoading = false;
      ToDoCubit.get(context).hasMoreTasks = true;
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        print(error.response?.data);
      }
      emit(LogoutErrorState());
      throw error;
    });
  }

  void saveDataToLocal(Map<String, dynamic> value) {
    LocalData.set(key: SharedKeys.isLogin, value: true);
    LocalData.set(key: SharedKeys.token, value: value['data']['token']);
    LocalData.set(key: SharedKeys.usedID, value: value['data']['user']['id']);
    LocalData.set(key: SharedKeys.name, value: value['data']['user']['name']);
    LocalData.set(key: SharedKeys.email, value: value['data']['user']['email']);
  }

  Future<void> registerWithApi({required context}) async {
    emit(RegisterSuccessState());
    await DioHelper.post(endpoint: EndPoints.register, body: {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "password_confirmation": confirmPassController.text,
    }).then((value) {
      print(value?.data);
      emit(RegisterSuccessState());
      Functions.showSuccessToast(context: context, msg: "Register done");
      restControllers();
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        print(error.response?.data);

        Functions.showErrorToast(
            msg: error.response!.data['errors']['password'][0].toString(),
            context: context,
            milliseconds: 400);
        const SizedBox(
          height: 20,
        );
        Functions.showErrorToast(
            msg: error.response!.data['errors']['email'][0].toString(),
            context: context,
            milliseconds: 6000);
      }
      emit(RegisterErrorState());
      throw error;
    });
  }

  void restControllers() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPassController.clear();
  }
}
