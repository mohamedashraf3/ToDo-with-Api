import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_application/view/components/customs/custom_button.dart';
import 'package:note_application/view/screens/register/register.dart';
import 'package:note_application/view/screens/statistics/statistics_screen.dart';
import 'package:note_application/view_model/bloc/cubit/auth/auth_cubit.dart';
import 'package:note_application/view_model/utils/app_colors.dart';
import 'package:note_application/view_model/utils/imgs.dart';
import '../../components/customs/text_custom.dart';
import '../../components/customs/textfeild_custom.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);
    return BlocProvider.value(
      value: cubit..restControllers(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.loginFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          Imgs.logo,
                          width: 250,
                          height: 230,
                        ),
                        const TextCustom(
                          text: "ToDo App",
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          prefixIcon: const Icon(Icons.email),
                          labelText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          controller: cubit.emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email must not be empty";
                            } else {
                              return null;
                            }
                          },
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          prefixIcon: const Icon(Icons.security),
                          obscureText: true,
                          labelText: "Password",
                          controller: cubit.passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password must not be empty";
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomButton(
                          color: AppColors.teal,
                          onPressed: state is! LoginLoadingState
                              ? () {
                                  if (cubit.loginFormKey.currentState!
                                      .validate()) {
                                    cubit
                                        .loginWithApi(context: context)
                                        .then((value) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return const StatisticsScreen();
                                        }),
                                        (route) => false,
                                      );
                                    });
                                  }
                                }
                              : null,
                          child: Visibility(
                              visible: state is! LoginLoadingState,
                              replacement: const CircularProgressIndicator(),
                              child: const TextCustom(
                                text: "Login",
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const SizedBox(height: 15),
                        CustomButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return const RegisterScreen();
                              },
                            ));
                          },
                          color: AppColors.deepPurple,
                          child: const TextCustom(
                            text: "Register",
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
